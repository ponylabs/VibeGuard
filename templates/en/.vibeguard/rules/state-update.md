# State Update

This rule defines how to read, decide, and update `.vibeguard/state/` after a task.

`state/` stores current project reality, not general rules.

## Principle

`.vibeguard/state/` is not an AI diary and not the project source of truth.

Record only evidence-backed project knowledge that future tasks will use.

Do not write temporary process, guesses, preferences, or generic summaries into state.

## Source Of Truth

State is a hint ledger, not authority.

Trust sources in this order:

1. current user instruction
2. code, dependency manifests, config files, tests, and CI files
3. project documentation
4. `.vibeguard/state/`

If state conflicts with project reality, trust project reality and report that state may be stale.

## Write Location

Write content to the matching file:

- project facts, tech stack, runtime environment, directory conventions: `.vibeguard/state/project-info.md`
- fixed project commands: `.vibeguard/state/project-commands.md`
- human-approved architecture, dependency, tool, or product decisions: `.vibeguard/state/project-decisions.md`
- unresolved risks, verification gaps, test gaps, follow-ups: `.vibeguard/state/open-items.md`

`.vibeguard/` is a closed workspace. Do not create new files under `.vibeguard/`, including new state files, notes, plans, scratchpads, snapshots, logs, or summaries.

If information does not fit one of the official files above, report it in the handoff instead of creating a new file. New VibeGuard files can only arrive from a future VibeGuard template release and `--update`.

Do not write general rules into state files.

## Evidence Labels

Allowed evidence labels:

- `user-approved`
- `observed-in-code`
- `verified-by-test`
- `verified-by-command`
- `unresolved-risk`

Use the narrowest accurate category:

- facts: `observed-in-code` or `user-approved`
- decisions: `user-approved`
- risks: `unresolved-risk` or failed verification evidence
- coverage: `verified-by-test`
- commands: `verified-by-command`

`verified-by-command` may only record command results. It must not be used for business, architecture, or product conclusions.

## Allowed Writes

You may write:

- user-approved decisions
- durable facts observed in code, config, dependency manifests, tests, or CI
- fixed project commands and their source
- behavior clearly covered by tests or verification
- unresolved risks that affect future tasks
- reasons and risks for verification that could not be completed

## Forbidden Writes

Do not write:

- guesses
- personal preferences
- generic summaries
- temporary process
- one-off command logs
- information with no long-term value
- details that can be cheaply checked in code
- unverified business conclusions
- business correctness inferred from command success

## Before Writing

Before updating state, confirm:

- project knowledge actually changed
- future tasks will benefit
- an evidence label is clear
- the target state file is clear
- old entries should be replaced instead of appended
- the entry does not conflict with code, config, dependencies, tests, or CI
- no new `.vibeguard/` file is being created

If unclear, do not write state. Mention it briefly in handoff instead.

## Pre-Handoff Reconciliation

Standard Path or Governed Path tasks must perform state reconciliation before final response.

Check whether this task changed long-lived information:

- project facts, tech stack, runtime environment, directory structure, or module boundaries: update `.vibeguard/state/project-info.md`
- fixed commands, verification commands, CI checks, or run behavior: update `.vibeguard/state/project-commands.md`
- user-approved architecture, dependency, tool, product, or process decisions: update `.vibeguard/state/project-decisions.md`
- unresolved risks, verification gaps, test gaps, or follow-ups: update `.vibeguard/state/open-items.md`

If the task changed README, CI, installers, templates, tests, governance rules, or helper scripts but no state files changed, explicitly review whether project knowledge was missed.

After review, if no state update is needed, state why in the final response, for example:

```text
State: not updated; this was a copy edit and did not create persistent project knowledge.
```

## Size Control

Keep state compact:

- entries are usually 1-2 lines
- update or delete stale entries first
- do not append forever
- do not copy large logs, errors, or plans
- when files become hard to scan, split by topic and update `.vibeguard/state/state-index.md`

## Reading Budget

Do not load all state files by default.

Read first:

```text
.vibeguard/state/state-index.md
```

Then read only state files relevant to the current task, affected module, dependency, test area, or open risk.

If no state index exists, read only obviously relevant state files and report missing state.

## Examples

```text
- user-approved: Use pnpm as the package manager for this project.
- observed-in-code: Backend routes are mounted under /api, see src/server.ts.
- verified-by-test: Discount behavior is covered by tests/checkout/discount.test.ts.
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: Password reset flow lacks e2e coverage.
```
