# State Index

This directory records evidence-backed state for the current project.

General rules live in `.vibeguard/rules/`. Do not put general rules in state files.

`.schema-version` records the state directory schema version. The current version is `1`; it is only for future update scripts to compare local state structure with template state structure. It is not a rules version and does not require automatic migration.

## Reading Rules

Read only this file by default.

Then read relevant files based on the current task:

- project facts: `.vibeguard/state/project-info.md`
- fixed commands: `.vibeguard/state/project-commands.md`
- human-approved decisions: `.vibeguard/state/project-decisions.md`
- unresolved items: `.vibeguard/state/open-items.md`

Do not read all state files by default.

Do not create new files under `.vibeguard/state/` or anywhere else under `.vibeguard/`. This state directory has a closed file set:

- `.vibeguard/state/.schema-version`
- `.vibeguard/state/state-index.md`
- `.vibeguard/state/project-info.md`
- `.vibeguard/state/project-commands.md`
- `.vibeguard/state/project-decisions.md`
- `.vibeguard/state/open-items.md`

If state conflicts with code, dependency manifests, config, tests, CI, or current user instruction, trust project reality and report that state may be stale.

## File Map

| File | Purpose | When To Read |
| --- | --- | --- |
| `project-info.md` | tech stack, runtime environment, directory structure, module boundaries, project conventions | when understanding project structure or implementation location |
| `project-commands.md` | fixed commands for install, dev, lint, typecheck, test, build | when running checks, tests, builds, or local services |
| `project-decisions.md` | user-approved or accepted project decisions | when touching architecture, dependencies, tools, test strategy, or product tradeoffs |
| `open-items.md` | unresolved risks, verification gaps, test gaps, follow-ups | when touching known risks or checking unresolved items before handoff |

## Maintenance

- Record only evidence-backed information that future tasks will use.
- Keep entries short, usually 1-2 lines.
- Prefer updating or deleting stale entries over appending forever.
- Each entry should include an evidence label, such as `user-approved`, `observed-in-code`, `verified-by-test`, `verified-by-command`, or `unresolved-risk`.
- Do not add custom state files. If the official files are insufficient, report the gap in the handoff.
