#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_ROOT=$(mktemp -d)
FAKE_BIN="$TMP_ROOT/bin"
FAKE_SRC="$TMP_ROOT/source"
FAKE_ARCHIVE="$TMP_ROOT/vibeguard.tar.gz"
FAKE_CURL_LOG="$TMP_ROOT/curl.log"

START_MARKER='<!-- VIBEGUARD:START -->'
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
  grep -F "$2" "$1" >/dev/null 2>&1 || fail "expected $1 to contain $2"
}

assert_not_contains() {
  ! grep -F "$2" "$1" >/dev/null 2>&1 || fail "expected $1 not to contain $2"
}

assert_marker_count() {
  count=$(grep -F -c "$START_MARKER" "$1" 2>/dev/null || true)
  [ "$count" = "$2" ] || fail "expected $1 marker count $2, got $count"
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
  mkdir -p "$FAKE_BIN" "$FAKE_SRC/VibeGuard-main/.vibeguard" "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard" "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard"
  printf '# Wrong Root VibeGuard\n' > "$FAKE_SRC/VibeGuard-main/.vibeguard/README.md"
  printf '# VibeGuard\n中文模板\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/README.md"
  printf '# VibeGuard\nEnglish template\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/README.md"
  printf '# Bootstrap\n中文初始化\n' > "$FAKE_SRC/VibeGuard-main/templates/zh/.vibeguard/bootstrap.md"
  printf '# Bootstrap\nEnglish bootstrap\n' > "$FAKE_SRC/VibeGuard-main/templates/en/.vibeguard/bootstrap.md"
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

setup_fake_download
assert_generated_installers_current

test_codex_installs_only_agents
test_lang_zh_installs_chinese_template
test_invalid_lang_fails_before_download
test_claude_installs_only_claude
test_cursor_installs_cursor_rule
test_all_installs_all_entries
test_dry_run_changes_nothing
test_existing_vibeguard_requires_force
test_force_replaces_existing_vibeguard
test_incomplete_marker_blocks_before_copy
test_version_tag_uses_tag_archive_url
test_rerun_does_not_duplicate_marker

printf 'ok - installer tests passed\n'
