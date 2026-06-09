# Dependency Check

This rule controls whether AI may add, replace, upgrade, or remove dependencies.

Dependency rules are cross-project. Project-approved dependency facts and decisions should be recorded in `.vibeguard/state/`.

## Principle

Do not add dependencies by default.

Prefer:

1. standard library
2. existing project dependencies
3. existing project tooling
4. small local implementation

Consider a new dependency only when existing capability is clearly insufficient and the benefit outweighs long-term maintenance cost.

Do not add a dependency just to save a few lines of code.

## Hard Gate

Ask the user first before:

- adding runtime dependency
- adding dev dependency
- replacing an existing library
- removing an existing library
- upgrading a major framework or core tool
- introducing a package manager, build tool, test tool, or code generator
- modifying lockfile
- modifying global environment, system environment, or user-level tool config

When a hard gate is triggered, stop changing files, explain why, and provide the smallest viable options.

## Before Proposing A Dependency

Briefly explain:

- why existing dependencies or standard library cannot solve it
- why a small local implementation is not appropriate
- whether it is runtime or dev
- which files it affects
- whether it affects build, tests, deployment, bundle size, or runtime environment
- whether the project already has similar capability
- whether `.vibeguard/state/project-info.md` or `.vibeguard/state/project-decisions.md` needs an update

If you cannot answer these, do not introduce the dependency.

## Forbidden Behavior

Do not:

- add a library because an example used it
- add duplicate capability when the project already has a similar library
- add multiple candidate libraries to compare them
- modify lockfile without approval
- install global packages without approval
- introduce a new test framework without approval
- switch package manager without approval
- add long-term dependencies for one-off scripts
- use dependency changes to hide insufficient understanding of existing code

## Verification

After an approved dependency change, run the smallest relevant set of project-declared install, build, test, type check, or lint commands.

Verification commands should come from:

- package script
- Makefile target
- uv or project environment command
- justfile or task runner
- README instruction
- CI config
- user-provided command

Do not use bare global commands as project verification.

## State Update

After an approved dependency change, update state with evidence:

- `.vibeguard/state/project-info.md`: current project facts, such as package manager, key dependencies, and toolchain
- `.vibeguard/state/project-commands.md`: fixed install, test, and build commands
- `.vibeguard/state/project-decisions.md`: human-approved dependency direction or library choice
- `.vibeguard/state/open-items.md`: unfinished migration, verification gap, or dependency risk

State entries must be short and include an evidence label, for example:

```text
- user-approved: Use pnpm as the package manager for this project.
- observed-in-code: Project depends on React Query, see package.json.
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: Production bundle size was not verified after adding the chart library.
```
