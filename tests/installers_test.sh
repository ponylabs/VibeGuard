#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_ROOT=$(mktemp -d)
FAKE_BIN="$TMP_ROOT/bin"
FAKE_SRC="$TMP_ROOT/source"
FAKE_ARCHIVE="$TMP_ROOT/vibeguard.tar.gz"
FAKE_CURL_LOG="$TMP_ROOT/curl.log"

START_MARKER='<!-- VIBEGUARD:START -->'
END_MARKER='<!-- VIBEGUARD:END -->'
ENTRY_LINE='Before making changes, read and follow `.vibeguard/README.md`.'

cleanup() {
  rm -rf "$TMP_ROOT"
}
trap cleanup EXIT INT TERM

fail() {
  printf 'not ok - %s\n' "$1" >&2
  exit 1
}

assert_exists() {
  [ -e "$1" ] || fail "expected $1 to exist"
}

assert_not_exists() {
  [ ! -e "$1" ] || fail "expected $1 to be absent"
}

assert_contains() {
  grep -F -- "$2" "$1" >/dev/null 2>&1 || fail "expected $1 to contain $2"
}

assert_not_contains() {
  ! grep -F -- "$2" "$1" >/dev/null 2>&1 || fail "expected $1 not to contain $2"
}

assert_marker_count() {
  count=$(grep -F -c "$START_MARKER" "$1" 2>/dev/null || true)
  [ "$count" = "$2" ] || fail "expected $1 marker count $2, got $count"
}

test_ci_workflow_runs_installer_checks() {
  workflow="$ROOT_DIR/.github/workflows/ci.yml"

  assert_exists "$workflow"
  assert_contains "$workflow" 'pull_request:'
  assert_contains "$workflow" 'branches:'
  assert_contains "$workflow" 'main'
  assert_contains "$workflow" 'sh -n install/installer.template.sh install/generate-installers.sh install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh'
  assert_contains "$workflow" 'sh tests/installers_test.sh'
}

assert_generated_installers_current() {
  before="$TMP_ROOT/generated-before"
  after="$TMP_ROOT/generated-after"

  git -C "$ROOT_DIR" diff -- install/codex.sh install/claude.sh install/cursor.sh install/all.sh > "$before"
  sh "$ROOT_DIR/install/generate-installers.sh"
  git -C "$ROOT_DIR" diff -- install/codex.sh install/claude.sh install/cursor.sh install/all.sh > "$after"

  if ! cmp -s "$before" "$after"; then
    fail "generated installers are out of date; run sh install/generate-installers.sh"
  fi
}

make_project() {
  dir=$(mktemp -d "$TMP_ROOT/project.XXXXXX")
  printf '%s\n' "$dir"
}

reset_curl_log() {
  : > "$FAKE_CURL_LOG"
}

setup_fake_download() {
  mkdir -p "$FAKE_BIN" "$FAKE_SRC/VibeGuard-main/.vibeguard" "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/bin" "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/rules" "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/state" "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/bin" "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/rules" "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/state"
  printf '# Wrong Root VibeGuard\n' > "$FAKE_SRC/VibeGuard-main/.vibeguard/README.md"
  printf '# VibeGuard\n中文模板\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/README.md"
  printf '# VibeGuard\nEnglish template\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/README.md"
  printf '# Bootstrap\n中文初始化\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/bootstrap.md"
  printf '# Bootstrap\nEnglish bootstrap\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/bootstrap.md"
  printf '# Task Flow\n中文规则\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/rules/task-flow.md"
  printf '# Task Flow\nEnglish rules\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/rules/task-flow.md"
  printf '1\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/state/.schema-version"
  printf '1\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/state/.schema-version"
  printf '# Project Info\n模板事实\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/state/project-info.md"
  printf '# Project Info\nTemplate facts\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/state/project-info.md"
  printf '# Open Items\n模板事项\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/state/open-items.md"
  printf '# Open Items\nTemplate items\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/state/open-items.md"
  printf '# status\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/bin/vibeguard-status.py"
  printf '# audit\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/bin/vibeguard-audit.py"
  printf '# status\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/bin/vibeguard-status.py"
  printf '# audit\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/bin/vibeguard-audit.py"
  tar -czf "$FAKE_ARCHIVE" -C "$FAKE_SRC" VibeGuard-main

  cat > "$FAKE_BIN/curl" <<'EOF'
#!/bin/sh
out=
url=
while [ "$#" -gt 0 ]; do
  case "$1" in
    -o)
      out=$2
      shift 2
      ;;
    -*)
      shift
      ;;
    *)
      url=$1
      shift
      ;;
  esac
done

if [ -z "$out" ]; then
  cat "$FAKE_ARCHIVE"
else
  cp "$FAKE_ARCHIVE" "$out"
fi

printf '%s\n' "$url" >> "$FAKE_CURL_LOG"
EOF
  chmod +x "$FAKE_BIN/curl"
  reset_curl_log
}

run_installer() {
  script=$1
  project=$2
  shift 2
  (
    cd "$project"
    PATH="$FAKE_BIN:$PATH" \
      FAKE_ARCHIVE="$FAKE_ARCHIVE" \
      FAKE_CURL_LOG="$FAKE_CURL_LOG" \
      sh "$ROOT_DIR/$script" --yes "$@"
  )
}

test_codex_installs_only_agents() {
  project=$(make_project)
  reset_curl_log

  run_installer install/codex.sh "$project"

  assert_exists "$project/.vibeguard/README.md"
  assert_exists "$project/.vibeguard/bootstrap.md"
  assert_exists "$project/.vibeguard/state/.schema-version"
  assert_exists "$project/.vibeguard/bin/vibeguard-status.py"
  assert_exists "$project/.vibeguard/bin/vibeguard-audit.py"
  assert_contains "$project/.vibeguard/state/.schema-version" '1'
  assert_contains "$project/.vibeguard/README.md" '# VibeGuard'
  assert_contains "$project/.vibeguard/README.md" 'English template'
  assert_contains "$project/.vibeguard/bootstrap.md" 'English bootstrap'
  assert_not_contains "$project/.vibeguard/README.md" 'Wrong Root'
  assert_exists "$project/AGENTS.md"
  assert_contains "$project/AGENTS.md" "$ENTRY_LINE"
  assert_not_exists "$project/CLAUDE.md"
  assert_not_exists "$project/.cursor"
  assert_contains "$FAKE_CURL_LOG" 'refs/heads/main.tar.gz'
}

test_lang_zh_installs_chinese_template() {
  project=$(make_project)
  reset_curl_log

  run_installer install/codex.sh "$project" --lang zh

  assert_exists "$project/.vibeguard/README.md"
  assert_exists "$project/.vibeguard/bootstrap.md"
  assert_contains "$project/.vibeguard/README.md" '中文模板'
  assert_contains "$project/.vibeguard/bootstrap.md" '中文初始化'
  assert_not_contains "$project/.vibeguard/README.md" 'English template'
}

test_invalid_lang_fails_before_download() {
  project=$(make_project)
  reset_curl_log

  if run_installer install/codex.sh "$project" --lang fr >/dev/null 2>&1; then
    fail "expected invalid language to fail"
  fi

  assert_not_exists "$project/.vibeguard"
  [ ! -s "$FAKE_CURL_LOG" ] || fail "invalid language should fail before download"
}

test_claude_installs_only_claude() {
  project=$(make_project)
  reset_curl_log

  run_installer install/claude.sh "$project"

  assert_exists "$project/.vibeguard/README.md"
  assert_exists "$project/CLAUDE.md"
  assert_contains "$project/CLAUDE.md" "$ENTRY_LINE"
  assert_not_exists "$project/AGENTS.md"
  assert_not_exists "$project/.cursor"
}

test_cursor_installs_cursor_rule() {
  project=$(make_project)
  reset_curl_log

  run_installer install/cursor.sh "$project"

  assert_exists "$project/.vibeguard/README.md"
  assert_exists "$project/.cursor/rules/vibeguard.mdc"
  assert_contains "$project/.cursor/rules/vibeguard.mdc" "$ENTRY_LINE"
  assert_not_exists "$project/AGENTS.md"
  assert_not_exists "$project/CLAUDE.md"
}

test_all_installs_all_entries() {
  project=$(make_project)
  reset_curl_log

  run_installer install/all.sh "$project"

  assert_exists "$project/.vibeguard/README.md"
  assert_exists "$project/AGENTS.md"
  assert_exists "$project/CLAUDE.md"
  assert_exists "$project/.cursor/rules/vibeguard.mdc"
}

test_dry_run_changes_nothing() {
  project=$(make_project)
  reset_curl_log

  run_installer install/codex.sh "$project" --dry-run >/dev/null

  assert_not_exists "$project/.vibeguard"
  assert_not_exists "$project/AGENTS.md"
  [ ! -s "$FAKE_CURL_LOG" ] || fail "dry-run should not download"
}

test_update_dry_run_changes_nothing() {
  project=$(make_project)
  mkdir -p "$project/.vibeguard"
  printf 'old readme\n' > "$project/.vibeguard/README.md"
  reset_curl_log

  run_installer install/codex.sh "$project" --update --dry-run > "$TMP_ROOT/update-dry-run.out"

  assert_contains "$TMP_ROOT/update-dry-run.out" 'would update en template files'
  assert_contains "$project/.vibeguard/README.md" 'old readme'
  assert_not_exists "$project/AGENTS.md"
  [ ! -s "$FAKE_CURL_LOG" ] || fail "update dry-run should not download"
}

test_existing_vibeguard_requires_force() {
  project=$(make_project)
  mkdir -p "$project/.vibeguard"
  printf 'old\n' > "$project/.vibeguard/README.md"
  reset_curl_log

  if run_installer install/codex.sh "$project" >/dev/null 2>&1; then
    fail "expected install to fail when .vibeguard exists"
  fi

  assert_contains "$project/.vibeguard/README.md" 'old'
  assert_not_exists "$project/AGENTS.md"
}

test_force_replaces_existing_vibeguard() {
  project=$(make_project)
  mkdir -p "$project/.vibeguard"
  printf 'old\n' > "$project/.vibeguard/README.md"
  reset_curl_log

  run_installer install/codex.sh "$project" --force

  assert_contains "$project/.vibeguard/README.md" '# VibeGuard'
  assert_not_contains "$project/.vibeguard/README.md" 'old'
  assert_exists "$project/AGENTS.md"
}

test_update_refreshes_template_files_and_preserves_state() {
  project=$(make_project)
  mkdir -p "$project/.vibeguard/rules" "$project/.vibeguard/state"
  printf 'old readme\n' > "$project/.vibeguard/README.md"
  printf 'old bootstrap\n' > "$project/.vibeguard/bootstrap.md"
  printf 'old rules\n' > "$project/.vibeguard/rules/task-flow.md"
  printf 'user project facts\n' > "$project/.vibeguard/state/project-info.md"
  printf '0\n' > "$project/.vibeguard/state/.schema-version"
  printf 'custom before\n' > "$project/AGENTS.md"
  reset_curl_log

  run_installer install/codex.sh "$project" --update > "$TMP_ROOT/update.out"

  assert_contains "$project/.vibeguard/README.md" 'English template'
  assert_contains "$project/.vibeguard/bootstrap.md" 'English bootstrap'
  assert_contains "$project/.vibeguard/rules/task-flow.md" 'English rules'
  assert_exists "$project/.vibeguard/bin/vibeguard-status.py"
  assert_exists "$project/.vibeguard/bin/vibeguard-audit.py"
  assert_contains "$project/.vibeguard/state/project-info.md" 'user project facts'
  assert_contains "$project/.vibeguard/state/open-items.md" 'Template items'
  assert_contains "$project/.vibeguard/state/.schema-version" '0'
  assert_contains "$project/AGENTS.md" 'custom before'
  assert_contains "$project/AGENTS.md" "$ENTRY_LINE"
  assert_marker_count "$project/AGENTS.md" 1
  assert_contains "$TMP_ROOT/update.out" 'state schema: local 0, template 1'
}

test_update_requires_existing_vibeguard() {
  project=$(make_project)
  reset_curl_log

  if run_installer install/codex.sh "$project" --update >/dev/null 2>&1; then
    fail "expected update to fail without .vibeguard"
  fi

  assert_not_exists "$project/.vibeguard"
  [ ! -s "$FAKE_CURL_LOG" ] || fail "missing .vibeguard should block update before download"
}

test_help_mentions_update() {
  project=$(make_project)

  run_installer install/codex.sh "$project" --help > "$TMP_ROOT/help.out"

  assert_contains "$TMP_ROOT/help.out" '--update'
}

test_zh_help_uses_chinese_labels_with_stable_options() {
  project=$(make_project)

  run_installer install/codex.sh "$project" --lang zh --help > "$TMP_ROOT/help-zh.out"

  assert_contains "$TMP_ROOT/help-zh.out" '用法：sh install/codex.sh [options]'
  assert_contains "$TMP_ROOT/help-zh.out" '选项：'
  assert_contains "$TMP_ROOT/help-zh.out" '--update'
  assert_contains "$TMP_ROOT/help-zh.out" '更新 VibeGuard 规则、辅助脚本和入口 block；保留已有 state。'
}

test_incomplete_marker_blocks_before_copy() {
  project=$(make_project)
  printf '%s\n' "$START_MARKER" > "$project/AGENTS.md"
  reset_curl_log

  if run_installer install/codex.sh "$project" >/dev/null 2>&1; then
    fail "expected incomplete marker to fail"
  fi

  assert_not_exists "$project/.vibeguard"
  [ ! -s "$FAKE_CURL_LOG" ] || fail "incomplete marker should block before download"
}

test_version_tag_uses_tag_archive_url() {
  project=$(make_project)
  reset_curl_log

  run_installer install/codex.sh "$project" --version v0.1.0

  assert_contains "$FAKE_CURL_LOG" 'refs/tags/v0.1.0.tar.gz'
}

test_rerun_does_not_duplicate_marker() {
  project=$(make_project)
  reset_curl_log

  run_installer install/codex.sh "$project"
  run_installer install/codex.sh "$project" --force

  assert_marker_count "$project/AGENTS.md" 1
}

test_update_preserves_user_content_around_managed_block() {
  project=$(make_project)
  {
    printf 'custom before\n'
    printf '%s\n' "$START_MARKER"
    printf 'old managed entry\n'
    printf '%s\n' "$END_MARKER"
    printf 'custom after\n'
  } > "$project/AGENTS.md"
  reset_curl_log

  run_installer install/codex.sh "$project"

  assert_contains "$project/AGENTS.md" 'custom before'
  assert_contains "$project/AGENTS.md" "$ENTRY_LINE"
  assert_contains "$project/AGENTS.md" 'custom after'
  assert_not_contains "$project/AGENTS.md" 'old managed entry'
  assert_marker_count "$project/AGENTS.md" 1
}

test_all_rerun_does_not_duplicate_markers() {
  project=$(make_project)
  reset_curl_log

  run_installer install/all.sh "$project"
  run_installer install/all.sh "$project" --force

  assert_marker_count "$project/AGENTS.md" 1
  assert_marker_count "$project/CLAUDE.md" 1
  assert_marker_count "$project/.cursor/rules/vibeguard.mdc" 1
}

test_templates_include_state_schema_version() {
  assert_exists "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version"
  assert_exists "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version"
  assert_contains "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version" '1'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version" '1'
}

setup_fake_download
assert_generated_installers_current

test_ci_workflow_runs_installer_checks
test_templates_include_state_schema_version
test_codex_installs_only_agents
test_lang_zh_installs_chinese_template
test_invalid_lang_fails_before_download
test_claude_installs_only_claude
test_cursor_installs_cursor_rule
test_all_installs_all_entries
test_dry_run_changes_nothing
test_update_dry_run_changes_nothing
test_existing_vibeguard_requires_force
test_force_replaces_existing_vibeguard
test_update_refreshes_template_files_and_preserves_state
test_update_requires_existing_vibeguard
test_help_mentions_update
test_zh_help_uses_chinese_labels_with_stable_options
test_incomplete_marker_blocks_before_copy
test_version_tag_uses_tag_archive_url
test_rerun_does_not_duplicate_marker
test_update_preserves_user_content_around_managed_block
test_all_rerun_does_not_duplicate_markers

printf 'ok - installer tests passed\n'
