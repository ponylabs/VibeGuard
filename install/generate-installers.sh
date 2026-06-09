#!/bin/sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
TEMPLATE="$ROOT_DIR/install/installer.template.sh"

[ -f "$TEMPLATE" ] || {
  printf 'missing installer template: %s\n' "$TEMPLATE" >&2
  exit 1
}

generate() {
  output=$1
  tool_name=$2
  entry_files=$3
  script_path=$4
  usage_target=$5
  tmp_file="${output}.tmp.$$"

  sed \
    -e "s|__TOOL_NAME__|$tool_name|g" \
    -e "s|__ENTRY_FILES__|$entry_files|g" \
    -e "s|__SCRIPT_PATH__|$script_path|g" \
    -e "s|__USAGE_TARGET__|$usage_target|g" \
    "$TEMPLATE" > "$tmp_file"

  chmod 755 "$tmp_file"
  mv "$tmp_file" "$output"
}

generate "$ROOT_DIR/install/codex.sh" "Codex" "AGENTS.md" "install/codex.sh" "AGENTS.md"
generate "$ROOT_DIR/install/claude.sh" "Claude Code" "CLAUDE.md" "install/claude.sh" "CLAUDE.md"
generate "$ROOT_DIR/install/cursor.sh" "Cursor" ".cursor/rules/vibeguard.mdc" "install/cursor.sh" ".cursor/rules/vibeguard.mdc"
generate "$ROOT_DIR/install/all.sh" "all supported tools" "AGENTS.md CLAUDE.md .cursor/rules/vibeguard.mdc" "install/all.sh" "Codex, Claude Code, and Cursor entries"
