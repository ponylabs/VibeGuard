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
