# VibeGuard

[中文说明](README.zh-CN.md)

A lightweight governance layer for vibe coding and AI-assisted development.

VibeGuard provides installable project rules and state templates for AI coding tools such as Codex, Claude Code, and Cursor. It helps fast-moving projects control scope, dependencies, tests, verification, and project memory.

## Repository Layout

```text
templates/
  en/.vibeguard/  # English governance template, installed by default
  zh/.vibeguard/  # Chinese governance template
install/          # Tool-specific installers
tests/            # Installer tests
```

The VibeGuard repository itself does not use the template from the project root. Installers copy `templates/<lang>/.vibeguard/` into the target project as `.vibeguard/`.

## Install

Install the English template by default:

Codex:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh
```

Claude Code:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/claude.sh | sh
```

Cursor:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/cursor.sh | sh
```

All supported tools:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/all.sh | sh
```

Install the Chinese template:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --lang zh
```

Options:

```text
--lang <en|zh>   Template language. Defaults to en.
--version <ref>  Install from a branch or tag. Defaults to main.
--force          Replace an existing .vibeguard directory.
--dry-run        Print planned actions without changing files.
--yes            Skip confirmation prompts.
--help           Print usage.
```

## First Run

After installation, ask your AI assistant to initialize project state:

```text
Read `.vibeguard/README.md` and run VibeGuard Bootstrap.
If this is an existing project, audit the current project and propose state updates.
If this is a new project, guide me through stack selection before writing state.
```

Bootstrap is a one-time project audit or stack selection flow. It records evidence-backed project facts, fixed commands, human-approved decisions, and open risks under `.vibeguard/state/`.
