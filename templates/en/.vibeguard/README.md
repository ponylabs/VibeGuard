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
