#!/bin/sh
set -eu

# Generated from install/installer.template.sh by install/generate-installers.sh.
# Edit the template, then regenerate the tool-specific installers.

TOOL_NAME="__TOOL_NAME__"
ENTRY_FILES="__ENTRY_FILES__"
DEFAULT_VERSION="main"
REPO_OWNER="ponylabs"
REPO_NAME="VibeGuard"

VERSION="$DEFAULT_VERSION"
LANGUAGE="en"
FORCE=0
DRY_RUN=0
YES=0

START_MARKER='<!-- VIBEGUARD:START -->'
END_MARKER='<!-- VIBEGUARD:END -->'
ENTRY_LINE='Before making changes, read and follow `.vibeguard/README.md`.'

usage() {
  cat <<EOF
Usage: sh __SCRIPT_PATH__ [options]

Installs VibeGuard into the current project and injects __USAGE_TARGET__.

Options:
  --version <ref>  Install from a branch or tag. Defaults to main.
  --lang <en|zh>   Install template language. Defaults to en.
  --force          Replace an existing .vibeguard directory.
  --dry-run        Print planned actions without changing files.
  --yes            Skip interactive confirmation prompts.
  --help           Print usage.
EOF
}

die() {
  printf 'VibeGuard %s installer: %s\n' "$TOOL_NAME" "$1" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "missing required command: $1"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --version)
      [ "$#" -ge 2 ] || die "--version requires a value"
      VERSION=$2
      shift 2
      ;;
    --lang|--language)
      [ "$#" -ge 2 ] || die "--lang requires a value"
      LANGUAGE=$2
      shift 2
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --yes)
      YES=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
done

case "$LANGUAGE" in
  en|zh) ;;
  *) die "unsupported language: $LANGUAGE; use en or zh" ;;
esac

for cmd in curl tar mktemp cp rm mkdir grep sed awk dirname find; do
  need_cmd "$cmd"
done

[ -w . ] || die "current directory is not writable"

marker_state() {
  file=$1
  if [ ! -f "$file" ]; then
    printf 'create\n'
    return
  fi

  start_count=$(grep -F -c "$START_MARKER" "$file" 2>/dev/null || true)
  end_count=$(grep -F -c "$END_MARKER" "$file" 2>/dev/null || true)

  if [ "$start_count" = "0" ] && [ "$end_count" = "0" ]; then
    printf 'append\n'
    return
  fi

  if [ "$start_count" = "1" ] && [ "$end_count" = "1" ]; then
    start_line=$(grep -nF "$START_MARKER" "$file" | sed -n '1s/:.*//p')
    end_line=$(grep -nF "$END_MARKER" "$file" | sed -n '1s/:.*//p')
    if [ "$start_line" -lt "$end_line" ]; then
      printf 'update\n'
      return
    fi
  fi

  printf 'error\n'
}

preflight_entry() {
  file=$1
  state=$(marker_state "$file")
  [ "$state" != "error" ] || die "$file contains incomplete or duplicate VibeGuard markers"
}

print_dry_run_entry() {
  file=$1
  state=$(marker_state "$file")
  case "$state" in
    create) printf 'entry: create %s\n' "$file" ;;
    append) printf 'entry: append managed block to %s\n' "$file" ;;
    update) printf 'entry: update managed block in %s\n' "$file" ;;
    error) printf 'entry: blocked by incomplete markers in %s\n' "$file" ;;
  esac
}

confirm() {
  [ "$YES" -eq 0 ] || return 0
  [ -t 0 ] || return 0
  printf 'Install VibeGuard for %s in this directory? [y/N] ' "$TOOL_NAME" >/dev/tty
  read answer </dev/tty || answer=
  case "$answer" in
    y|Y|yes|YES) ;;
    *) die "installation cancelled" ;;
  esac
}

try_download() {
  ref_kind=$1
  ref_name=$2
  url="https://github.com/$REPO_OWNER/$REPO_NAME/archive/refs/$ref_kind/$ref_name.tar.gz"
  if curl -fsSL "$url" -o "$ARCHIVE_FILE"; then
    DOWNLOADED_URL=$url
    return 0
  fi
  return 1
}

download_archive() {
  if [ "$VERSION" = "$DEFAULT_VERSION" ]; then
    try_download heads "$VERSION" || die "failed to download archive for $VERSION"
    return
  fi

  case "$VERSION" in
    v[0-9]*|[0-9]*)
      try_download tags "$VERSION" || try_download heads "$VERSION" || die "failed to download archive for $VERSION"
      ;;
    *)
      try_download heads "$VERSION" || try_download tags "$VERSION" || die "failed to download archive for $VERSION"
      ;;
  esac
}

find_vibeguard_dir() {
  find "$EXTRACT_DIR" -type d -path "*/templates/$LANGUAGE/.vibeguard" -print | sed -n '1p'
}

install_vibeguard_dir() {
  if [ -d .vibeguard ]; then
    [ "$FORCE" -eq 1 ] || die ".vibeguard already exists; use --force to replace it"
    rm -rf .vibeguard
  fi

  cp -R "$SOURCE_VIBEGUARD" ./.vibeguard
}

write_block() {
  printf '%s\n%s\n%s\n' "$START_MARKER" "$ENTRY_LINE" "$END_MARKER"
}

inject_entry() {
  file=$1
  state=$(marker_state "$file")
  dir=$(dirname "$file")
  [ "$dir" = "." ] || mkdir -p "$dir"

  case "$state" in
    create)
      write_block > "$file"
      ;;
    append)
      [ ! -s "$file" ] || printf '\n' >> "$file"
      write_block >> "$file"
      ;;
    update)
      tmp_file="${file}.vibeguard.$$"
      awk -v start="$START_MARKER" -v end="$END_MARKER" -v entry="$ENTRY_LINE" '
        $0 == start {
          print start
          print entry
          print end
          in_block = 1
          next
        }
        $0 == end {
          in_block = 0
          next
        }
        !in_block {
          print
        }
      ' "$file" > "$tmp_file"
      mv "$tmp_file" "$file"
      ;;
    *)
      die "$file contains incomplete or duplicate VibeGuard markers"
      ;;
  esac
}

for entry_file in $ENTRY_FILES; do
  preflight_entry "$entry_file"
done

if [ "$DRY_RUN" -eq 1 ]; then
  if [ -d .vibeguard ]; then
    if [ "$FORCE" -eq 1 ]; then
      printf '.vibeguard: would replace existing directory\n'
    else
      printf '.vibeguard: already exists; install would stop without --force\n'
    fi
  else
    printf '.vibeguard: would copy %s template from VibeGuard %s archive\n' "$LANGUAGE" "$VERSION"
  fi
  for entry_file in $ENTRY_FILES; do
    print_dry_run_entry "$entry_file"
  done
  exit 0
fi

[ ! -d .vibeguard ] || [ "$FORCE" -eq 1 ] || die ".vibeguard already exists; use --force to replace it"

confirm

TMP_DIR=$(mktemp -d "${TMPDIR:-/tmp}/vibeguard.XXXXXX")
ARCHIVE_FILE="$TMP_DIR/vibeguard.tar.gz"
EXTRACT_DIR="$TMP_DIR/extract"
DOWNLOADED_URL=
mkdir -p "$EXTRACT_DIR"
trap 'rm -rf "$TMP_DIR"' EXIT INT TERM

download_archive
tar -xzf "$ARCHIVE_FILE" -C "$EXTRACT_DIR" || die "failed to extract downloaded archive"
SOURCE_VIBEGUARD=$(find_vibeguard_dir)
[ -n "$SOURCE_VIBEGUARD" ] || die "downloaded archive does not contain templates/$LANGUAGE/.vibeguard"

install_vibeguard_dir
for entry_file in $ENTRY_FILES; do
  inject_entry "$entry_file"
done

printf 'VibeGuard installed for %s from %s (lang: %s)\n' "$TOOL_NAME" "$DOWNLOADED_URL" "$LANGUAGE"
if [ "$LANGUAGE" = "zh" ]; then
  printf '\n下一步：\n'
  printf '让 AI 读取 `.vibeguard/README.md` 并运行 VibeGuard Bootstrap。\n'
else
  printf '\nNext step:\n'
  printf 'Ask your AI assistant to read `.vibeguard/README.md` and run VibeGuard Bootstrap.\n'
fi
