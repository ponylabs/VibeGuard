#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TMP_ROOT=$(mktemp -d)
PYTHON=${PYTHON:-python3}

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

assert_contains() {
  grep -F -- "$2" "$1" >/dev/null 2>&1 || fail "expected $1 to contain $2"
}

assert_not_contains() {
  ! grep -F -- "$2" "$1" >/dev/null 2>&1 || fail "expected $1 not to contain $2"
}

make_project() {
  lang=$1
  dir=$(mktemp -d "$TMP_ROOT/project.XXXXXX")
  cp -R "$ROOT_DIR/templates/$lang/.vibeguard" "$dir/.vibeguard"
  cat > "$dir/AGENTS.md" <<'EOF'
<!-- VIBEGUARD:START -->
Before making changes, read and follow `.vibeguard/README.md`.
<!-- VIBEGUARD:END -->
EOF
  printf '%s\n' "$dir"
}

commit_project_baseline() {
  project=$1
  (
    cd "$project"
    git init >/dev/null 2>&1
    git add .
    git -c user.name='VibeGuard Test' -c user.email='test@example.com' commit -m baseline >/dev/null 2>&1
  )
}

test_status_script_reports_template_setup() {
  project=$(make_project en)
  out="$TMP_ROOT/status.out"

  (
    cd "$project"
    "$PYTHON" .vibeguard/bin/vibeguard-status.py > "$out"
  )

  assert_contains "$out" 'VibeGuard status: ok'
  assert_contains "$out" 'AGENTS.md: installed'
  assert_contains "$out" 'CLAUDE.md: missing'
  assert_contains "$out" 'Python helper: available'
}

test_zh_status_script_uses_chinese_labels_with_stable_tokens() {
  project=$(make_project zh)
  out="$TMP_ROOT/zh-status.out"

  (
    cd "$project"
    "$PYTHON" .vibeguard/bin/vibeguard-status.py > "$out"
  )

  assert_contains "$out" 'VibeGuard 状态（status）：ok'
  assert_contains "$out" '核心文件（Core files）：'
  assert_contains "$out" '入口文件（Entries）：'
  assert_contains "$out" '自动化（Automation）：'
  assert_contains "$out" 'AGENTS.md: installed'
  assert_contains "$out" 'Python helper: available'
}

test_audit_script_flags_dependency_and_lock_changes() {
  project=$(make_project en)
  out="$TMP_ROOT/audit.out"

  (
    cd "$project"
    git init >/dev/null 2>&1
    printf '{"dependencies":{"left-pad":"1.0.0"}}\n' > package.json
    printf '{}\n' > package-lock.json
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" 'VibeGuard audit: attention needed'
  assert_contains "$out" 'Risk: high'
  assert_contains "$out" 'package.json: dependency manifest changed'
  assert_contains "$out" 'package-lock.json: lockfile changed'
}

test_zh_audit_script_uses_chinese_labels_with_stable_tokens() {
  project=$(make_project zh)
  out="$TMP_ROOT/zh-audit.out"

  (
    cd "$project"
    git init >/dev/null 2>&1
    printf '{"dependencies":{"left-pad":"1.0.0"}}\n' > package.json
    printf '{}\n' > package-lock.json
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" 'VibeGuard 审计（audit）：attention needed'
  assert_contains "$out" '风险等级（Risk）：high'
  assert_contains "$out" '变更文件（Changed files）：'
  assert_contains "$out" 'package.json: dependency manifest changed'
  assert_contains "$out" 'package-lock.json: lockfile changed'
}

test_audit_flags_unapproved_vibeguard_files_as_high_risk() {
  project=$(make_project en)
  out="$TMP_ROOT/unapproved-vibeguard-file.out"
  commit_project_baseline "$project"

  (
    cd "$project"
    printf 'agent notes\n' > .vibeguard/state/notes.md
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" 'VibeGuard audit: attention needed'
  assert_contains "$out" 'Risk: high'
  assert_contains "$out" '.vibeguard/state/notes.md: unapproved VibeGuard file'
}

test_zh_audit_flags_unapproved_vibeguard_files_as_high_risk() {
  project=$(make_project zh)
  out="$TMP_ROOT/zh-unapproved-vibeguard-file.out"
  commit_project_baseline "$project"

  (
    cd "$project"
    printf 'agent notes\n' > .vibeguard/notes.md
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" 'VibeGuard 审计（audit）：attention needed'
  assert_contains "$out" '风险等级（Risk）：high'
  assert_contains "$out" '.vibeguard/notes.md: unapproved VibeGuard file'
}

test_audit_recommends_state_review_for_project_knowledge_changes() {
  project=$(make_project en)
  out="$TMP_ROOT/state-review.out"
  commit_project_baseline "$project"

  (
    cd "$project"
    printf '\nProject behavior changed.\n' >> README.md
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" 'State review: recommended'
  assert_contains "$out" 'Project behavior, tooling, docs, tests, or governance changed but no state files changed.'
}

test_zh_audit_recommends_state_review_with_chinese_label_and_anchor() {
  project=$(make_project zh)
  out="$TMP_ROOT/zh-state-review.out"
  commit_project_baseline "$project"

  (
    cd "$project"
    printf '\nProject behavior changed.\n' >> README.md
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_contains "$out" '状态复查（State review）：建议执行'
  assert_contains "$out" '项目行为、工具、文档、测试或治理发生变化，但没有 state 文件变更。'
}

test_audit_skips_state_review_when_state_changed() {
  project=$(make_project en)
  out="$TMP_ROOT/state-review-skipped.out"
  commit_project_baseline "$project"

  (
    cd "$project"
    printf '\nProject behavior changed.\n' >> README.md
    printf '\n- observed-in-code: README changed.\n' >> .vibeguard/state/project-info.md
    "$PYTHON" .vibeguard/bin/vibeguard-audit.py > "$out"
  )

  assert_not_contains "$out" 'State review: recommended'
}

test_readmes_explain_python_helper_and_permission_boundary() {
  en_readme="$ROOT_DIR/templates/en/.vibeguard/README.md"
  zh_readme="$ROOT_DIR/templates/zh/.vibeguard/README.md"

  assert_contains "$en_readme" 'python3 .vibeguard/bin/vibeguard-status.py'
  assert_contains "$en_readme" 'python3 .vibeguard/bin/vibeguard-audit.py'
  assert_contains "$en_readme" 'ask the user before configuring a Python environment'
  assert_contains "$en_readme" '.vibeguard/state/project-commands.md'

  assert_contains "$zh_readme" 'python3 .vibeguard/bin/vibeguard-status.py'
  assert_contains "$zh_readme" 'python3 .vibeguard/bin/vibeguard-audit.py'
  assert_contains "$zh_readme" '先向用户解释并征得许可'
  assert_contains "$zh_readme" '.vibeguard/state/project-commands.md'
  assert_contains "$zh_readme" '语言约定'
  assert_contains "$zh_readme" 'user-approved'
  assert_contains "$zh_readme" 'low/medium/high'
  assert_contains "$en_readme" 'Do not create new files under `.vibeguard/`'
  assert_contains "$zh_readme" '不要在 `.vibeguard/` 下新增文件'
}

test_readmes_explain_update_mode() {
  en_readme="$ROOT_DIR/templates/en/.vibeguard/README.md"
  zh_readme="$ROOT_DIR/templates/zh/.vibeguard/README.md"

  assert_contains "$ROOT_DIR/README.md" '--update'
  assert_contains "$ROOT_DIR/README.md" 'stable tokens such as `user-approved`'
  assert_contains "$ROOT_DIR/README.zh-CN.md" '--update'
  assert_contains "$ROOT_DIR/README.zh-CN.md" '稳定英文 token'
  assert_contains "$en_readme" '--update'
  assert_contains "$en_readme" 'preserves existing `.vibeguard/state/` files'
  assert_contains "$zh_readme" '--update'
  assert_contains "$zh_readme" '保留已有 `.vibeguard/state/` 文件'
}

test_state_schema_version_is_documented() {
  assert_exists "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version"
  assert_exists "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version"
  assert_contains "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version" '1'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version" '1'
  assert_contains "$ROOT_DIR/templates/en/.vibeguard/state/state-index.md" 'state directory schema version'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/state-index.md" 'state 结构版本'
}

test_zh_template_headings_use_chinese_with_english_anchors() {
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/rules/task-flow.md" '# 任务流程（Task Flow）'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/rules/task-flow.md" '### 快速路径（Fast Path）'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/rules/dependency-check.md" '## 硬门禁（Hard Gate）'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/rules/state-update.md" '# 状态更新（State Update）'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/state-index.md" '# 状态索引（State Index）'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/project-commands.md" '## 验证记录（Verification Notes）'
}

command -v "$PYTHON" >/dev/null 2>&1 || fail "missing Python interpreter: $PYTHON"

test_status_script_reports_template_setup
test_zh_status_script_uses_chinese_labels_with_stable_tokens
test_audit_script_flags_dependency_and_lock_changes
test_zh_audit_script_uses_chinese_labels_with_stable_tokens
test_audit_flags_unapproved_vibeguard_files_as_high_risk
test_zh_audit_flags_unapproved_vibeguard_files_as_high_risk
test_audit_recommends_state_review_for_project_knowledge_changes
test_zh_audit_recommends_state_review_with_chinese_label_and_anchor
test_audit_skips_state_review_when_state_changed
test_readmes_explain_python_helper_and_permission_boundary
test_readmes_explain_update_mode
test_state_schema_version_is_documented
test_zh_template_headings_use_chinese_with_english_anchors

printf 'ok - vibeguard cli tests passed\n'
