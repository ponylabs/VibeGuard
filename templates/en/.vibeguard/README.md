# VibeGuard

This is the VibeGuard project governance entry point.

## First Run

If `.vibeguard/state/` has not been initialized yet, read `.vibeguard/bootstrap.md` before starting normal development.

Bootstrap decides whether this is an existing project audit or a new project stack selection. It should propose state updates first and wait for user confirmation before writing them.

Suggested prompt:

```text
Read `.vibeguard/README.md` and run VibeGuard Bootstrap.
If this is an existing project, audit the current project and propose state updates.
If this is a new project, guide me through stack selection before writing state.
```

## Optional Python Helper

VibeGuard includes two project-local Python helper scripts for deterministic checks:

```sh
python3 .vibeguard/bin/vibeguard-status.py
python3 .vibeguard/bin/vibeguard-audit.py
```

These scripts use only the Python standard library. They do not install packages, modify shell profiles, create virtual environments, or add project runtime dependencies.

`vibeguard-status.py` checks whether VibeGuard files and AI entry markers are present.

`vibeguard-audit.py` inspects current git changes and flags likely governance risks, such as dependency manifests, lockfiles, installer files, CI workflows, AI entry files, or VibeGuard rule changes.

If the current project does not already use Python, or if `python3` is unavailable, do not configure a Python environment silently. Explain that the helper is optional, ask the user before configuring a Python environment for VibeGuard, and record the approved interpreter command or path in `.vibeguard/state/project-commands.md`.

If the helper cannot run, continue with the manual rule flow below.

## VibeGuard Workspace Boundary

Do not create new files under `.vibeguard/`.

AI agents may update the existing official files only. Project-specific facts, decisions, commands, risks, and follow-ups must fit into the existing `.vibeguard/state/` files listed in `.vibeguard/state/state-index.md`.

If information does not fit the existing files, report it in the handoff instead of creating a new `.vibeguard/` file. New VibeGuard files can only arrive from a future VibeGuard template release and `--update`.

## Updating VibeGuard

To refresh VibeGuard in this project after a new release, re-run the matching installer with `--update` from the project root.

Example for Codex:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --update
```

`--update` refreshes VibeGuard README, bootstrap, rules, helper scripts, and managed AI entry blocks. It preserves existing `.vibeguard/state/` files and only copies missing state template files.

The update output reports local and template state schema versions. VibeGuard currently reports schema differences but does not migrate state automatically.

## Normal Tasks

Read in this order:

1. `.vibeguard/rules/task-flow.md`
2. `.vibeguard/rules/change-area.md`
3. `.vibeguard/rules/dependency-check.md`
4. `.vibeguard/rules/test-plan.md`
5. `.vibeguard/rules/final-check.md`
6. `.vibeguard/rules/state-update.md`
7. `.vibeguard/state/state-index.md`, then read only the state files relevant to the current task.

`rules/` stores general AI development rules that can apply across projects.

`state/` stores evidence-backed facts, decisions, risks, and verification notes for this project only.
