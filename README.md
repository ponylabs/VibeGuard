<p align="center">
  <img src="docs/assets/vibeguard-logo.svg" alt="VibeGuard logo" width="340">
</p>

<h1 align="center">VibeGuard</h1>

<p align="center">
  <strong>A lightweight governance layer for vibe coding and AI-assisted development.</strong>
</p>

<p align="center">
  <a href="README.zh-CN.md">中文说明</a>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-2e7d5b.svg"></a>
  <img alt="Install: curl pipe sh" src="https://img.shields.io/badge/install-curl%20%7C%20sh-11a683.svg">
  <img alt="Installers: Codex, Claude Code, Cursor" src="https://img.shields.io/badge/installers-Codex%20%7C%20Claude%20Code%20%7C%20Cursor-4f79e8.svg">
  <img alt="Templates: English and Chinese" src="https://img.shields.io/badge/templates-en%20%7C%20zh-8a63d2.svg">
</p>

<p align="center">
  <img src="docs/assets/vibeguard-banner.svg" alt="VibeGuard banner" width="100%">
</p>

VibeGuard installs a small `.vibeguard/` workspace into your project and adds a short entry instruction for AI coding tools such as Codex, Claude Code, and Cursor.

```text
install VibeGuard -> bootstrap project state -> keep AI-assisted changes scoped, verified, and remembered
```

## Why Use It

VibeGuard helps fast-moving projects keep AI-assisted changes grounded in:

- 🧭 clear change boundaries
- 🧰 dependency and toolchain discipline
- ✅ test and verification expectations
- 🧠 evidence-backed project memory
- 📌 known risks and follow-up items

It is intentionally small: no project runtime dependency, no new framework, and no separate service to run.

## Quick Start

Run an installer from the root of the project you want to govern. These commands install the English template by default.

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

Then ask your AI assistant to initialize project state:

```text
Read `.vibeguard/README.md` and run VibeGuard Bootstrap.
If this is an existing project, audit the current project and propose state updates.
If this is a new project, guide me through stack selection before writing state.
```

## Install Options

Install the Chinese template with any installer:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --lang zh
```

Available options:

```text
--lang <en|zh>   Template language. Defaults to en.
--version <ref>  Install from a branch or tag. Defaults to main.
--force          Replace an existing .vibeguard directory.
--dry-run        Print planned actions without changing files.
--yes            Skip confirmation prompts.
--help           Print usage.
```

Requirements: POSIX `sh` plus common Unix tools used by the installer, including `curl`, `tar`, `mktemp`, `cp`, `rm`, `mkdir`, `grep`, `sed`, `awk`, `dirname`, and `find`.

## What Gets Installed

Each installer copies a language-specific governance template into the current project:

```text
.vibeguard/
  README.md       # entry point for AI assistants
  bootstrap.md    # first-run project audit or stack selection flow
  rules/          # reusable task, dependency, test, and verification rules
  state/          # project-specific facts, decisions, commands, and open items
```

It also injects one managed block into the matching tool entry file:

```text
install/codex.sh  -> AGENTS.md
install/claude.sh -> CLAUDE.md
install/cursor.sh -> .cursor/rules/vibeguard.mdc
install/all.sh    -> all of the above
```

The managed block is marker-based and idempotent, so re-running an installer updates the VibeGuard block without duplicating it. Existing `.vibeguard/` directories are protected unless `--force` is provided.

## How It Works

VibeGuard gives AI coding tools a small operating manual for each project:

| Part | Purpose |
| --- | --- |
| 🧭 `rules/` | Reusable guidance for task flow, change boundaries, dependencies, testing, verification, and state updates. |
| 🧠 `state/` | Project-specific facts, fixed commands, human-approved decisions, and unresolved risks. |
| 🪄 `bootstrap.md` | First-run state initialization for an existing project or a new project. |

The result is a repeatable loop: read the project rules, check the relevant state, make the smallest useful change, run the right verification, and report any remaining risk.

## Repository Layout

```text
templates/
  en/.vibeguard/  # English governance template, installed by default
  zh/.vibeguard/  # Chinese governance template
install/          # tool-specific installers generated from a shared template
tests/            # installer tests
```

This repository has its own root `.vibeguard/` state for maintaining VibeGuard itself. Installers do not copy that directory. They copy `templates/<lang>/.vibeguard/` into the target project as `.vibeguard/`.

## License

[MIT](LICENSE)
