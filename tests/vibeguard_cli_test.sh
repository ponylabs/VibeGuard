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
  grep -F "$2" "$1" >/dev/null 2>&1 || fail "expected $1 to contain $2"
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
}

test_state_schema_version_is_documented() {
  assert_exists "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version"
  assert_exists "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version"
  assert_contains "$ROOT_DIR/templates/en/.vibeguard/state/.schema-version" '1'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/.schema-version" '1'
  assert_contains "$ROOT_DIR/templates/en/.vibeguard/state/state-index.md" 'state directory schema version'
  assert_contains "$ROOT_DIR/templates/zh/.vibeguard/state/state-index.md" 'state 结构版本'
}

command -v "$PYTHON" >/dev/null 2>&1 || fail "missing Python interpreter: $PYTHON"

test_status_script_reports_template_setup
test_audit_script_flags_dependency_and_lock_changes
test_readmes_explain_python_helper_and_permission_boundary
test_state_schema_version_is_documented

printf 'ok - vibeguard cli tests passed\n'
