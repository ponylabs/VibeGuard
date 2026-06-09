# Task Flow

This workflow governs AI-assisted changes in this project.

VibeGuard should preserve vibe coding speed while preventing code drift, dependency sprawl, forgotten context, and unverified changes.

For change boundaries, follow `.vibeguard/rules/change-area.md`.

For dependency, framework, build tool, test tool, and package manager changes, follow `.vibeguard/rules/dependency-check.md`.

For test cases, static checks, type checks, build checks, and verification commands, follow `.vibeguard/rules/test-plan.md`.

For completion claims, verification evidence, verification failures, and verification gaps, follow `.vibeguard/rules/final-check.md`.

For state reading, writing, evidence labels, and size control, follow `.vibeguard/rules/state-update.md`.

Read project facts, decisions, risks, and verification notes from `.vibeguard/state/state-index.md` first, then read only state files relevant to the current task.

Core principle:

```text
Move fast by default. Escalate by risk. Keep output concise. Write state only with evidence.
```

## 1. Task Modes

Choose the lightest mode that safely fits the task.

When uncertain, choose the higher-risk mode, but keep output concise.

Classify the whole logical task, not only the next small edit.

### Fast Path

Use for tiny, low-risk changes:

- typo fixes
- comment changes
- formatting of already-touched lines
- small copy changes
- one-line style adjustments
- changes with no behavior, dependency, API, data, or test impact

Fast Path rules:

- read the VibeGuard entry point
- follow `.vibeguard/rules/change-area.md`
- inspect only the immediately relevant file or area
- make the smallest necessary change
- run a minimal check when useful
- do not update `.vibeguard/state/`
- keep the final response to 1-3 lines

Fast Path must not add dependencies, modify tests, change public behavior, or touch unrelated files.

Fast Path is allowlist-based. Upgrade to Standard Path when any of these are true:

- editing a function, class, component, hook, API handler, or exported symbol
- changing conditionals, loops, error handling, async logic, data flow, or business rules
- touching a file used by multiple modules where behavior may change
- changing tests, config, dependency manifests, build scripts, generated files, or lockfiles
- editing more than one non-documentation file
- changing user-visible behavior
- this is the second or later Fast Path touching the same feature, file, module, API, or behavior in the same conversation
- the impact area is uncertain

### Standard Path

Use for normal development tasks:

- bug fixes
- small features
- localized refactors
- behavior changes within an existing module
- test additions or adjustments for a clear gap

Standard Path rules:

1. Read relevant VibeGuard rules and state.
2. Briefly restate the task when useful.
3. Inspect project state and locate the impact area.
4. Provide a short plan, usually 3-5 bullets.
5. Reuse or adjust existing tests before adding new tests.
6. Implement the smallest scoped change.
7. Run relevant checks.
8. Update governance state only when evidence-backed project knowledge changed.
9. Hand off with changes, verification, and unresolved risks.

### Governed Path

Use for high-risk or high-blast-radius changes:

- new dependency, framework, build tool, or test runner
- database schema or persisted data format changes
- authentication, authorization, security, payment, or data deletion behavior
- broad refactors
- cross-module architecture changes
- public API or config format changes affecting external users
- large file deletion, rename, or migration

Governed Path rules:

1. Read relevant VibeGuard rules and state.
2. Inspect affected code, tests, dependencies, and open items.
3. Present options or a plan with risks and rollback points.
4. Stop for hard gates before implementation.
5. Define test and verification strategy before coding.
6. Implement only the approved scope.
7. Run static checks, tests, builds, or equivalent verification.
8. Update governance state with evidence-backed changes.
9. Provide a handoff and version control recommendation.

## 2. Gates

Gates prevent irreversible or high-spread mistakes. They should not turn every task into an approval ceremony.

Hard Gate means: stop changing files and ask a concise question. Do not continue implementation until the user replies. If the tool cannot pause safely, leave the workspace unchanged and report the gate.

### Hard Gates

Stop and wait for human confirmation before:

- adding runtime dependencies
- adding development dependencies
- adding or replacing frameworks
- changing test frameworks, build systems, or package managers
- changing database schema or persisted data formats
- changing authentication, authorization, security, payment, or data deletion behavior
- deleting, renaming, or moving many files
- editing secrets, credentials, generated artifacts, vendor code, or lockfiles for unrelated reasons
- continuing when requirements conflict with VibeGuard rules or state

### Soft Gates

Do not necessarily stop, but call out risk in the plan or handoff when changing:

- public API shape
- cross-module behavior
- configuration behavior
- test strategy
- performance-sensitive code
- error handling semantics
- user-visible workflows

Escalate a soft gate to a hard gate when the change is hard to reverse, affects external users, or has unclear blast radius.

## 3. Test Strategy

Testing and static checks follow `.vibeguard/rules/test-plan.md`.

Before adding tests, reuse or adjust existing tests first.

Verification commands should first use fixed project commands recorded in `.vibeguard/state/project-commands.md`.

If no command is recorded, discover it from project scripts, README, CI, or user instructions. When a durable command is found, update `.vibeguard/state/project-commands.md` with evidence.

## 4. Source Of Truth

`.vibeguard/state/` is a hint ledger, not the source of truth.

State describes the current project and must not contain general VibeGuard rules.

Trust sources in this order:

1. current user instruction
2. code, dependency manifests, config files, tests, and CI files
3. project documentation
4. `.vibeguard/state/`

If state conflicts with observable project reality, trust the project reality and report that state may be stale.

In Standard Path or Governed Path, verify relevant state claims against project reality when practical:

- approved dependency: check dependency manifests or lockfiles
- test command: check package scripts, Makefile, pyproject, justfile, task config, README, or CI
- API shape: check code and tests
- closed issue or risk: check implementation, tests, or user confirmation

Do not treat state as authority for facts that can be cheaply checked in the project.

## 5. Verification

Verification follows `.vibeguard/rules/final-check.md`.

Test, static check, type check, build check, and fixed command selection follow `.vibeguard/rules/test-plan.md`.

Before claiming task completion, have fresh verification evidence or clearly report verification gaps and risks.

## 6. Governance State Policy

State updates follow `.vibeguard/rules/state-update.md`.

Fast Path does not update state.

Standard Path updates state only when durable project knowledge changed.

Governed Path reviews whether state needs an update before handoff.

## 7. State Reading Budget

State reading budget follows `.vibeguard/rules/state-update.md`.

Read `.vibeguard/state/state-index.md` first, then read only state files relevant to the current task.

## 8. Anti-Salami Rule

Do not split one logically connected change into multiple Fast Path tasks to avoid Standard Path or Governed Path.

If a sequence of small edits contributes to one behavior, architecture, dependency, API, data, test, or config change, classify it by the highest-risk intended outcome.

If repeated small edits touch the same feature, file, module, API, or behavior, re-evaluate the mode before continuing.

## 9. Output Budget

Governance should guide actions, not inflate conversation.

Default output rules:

- do not print the full checklist unless asked
- do not narrate obvious file reads
- keep Fast Path final responses to 1-3 lines
- keep Standard Path plans to 3-5 bullets
- reserve detailed reasoning for Governed Path risks, gates, dependencies, API changes, data changes, and verification gaps
- report only incomplete checklist items or meaningful risks

Prefer compact handoffs over process logs.

Unless the user asks for detail, use these final response formats.

Fast Path:

```text
Changed: ...
Verified: ...
```

Standard Path:

```text
Changed: ...
Verified: ...
Open: ...
```

Governed Path:

```text
Changed: ...
Verified: ...
State: ...
Open: ...
Version: ...
```

Do not explain the workflow unless asked.

Do not include internal checklist items that passed.

## 10. Stop Conditions

Stop and ask the user before continuing when:

- a hard gate is triggered
- requirements are unclear and implementation would be guesswork
- requested scope expands beyond the original task
- repeated small edits appear to be one larger logical change
- root cause is still unclear after investigation
- necessary verification cannot be run and the risk is meaningful
- unrelated existing test failures block confidence
- implementation would conflict with VibeGuard rules or state
- safe completion requires changing dependencies, frameworks, data formats, security behavior, or broad architecture

When stopping, report:

- what was discovered
- why continuing is risky
- the recommended next decision

## 11. Completion Rules

Before final response, ensure:

- chosen task mode matched risk
- relevant governance files were read
- relevant state was checked against project reality when practical
- impact area was inspected
- gated changes were approved or avoided
- existing tests were reused or adjusted before adding new coverage
- verification used project-scoped commands when available, or the verification gap was reported
- governance state was updated only when evidence-backed project knowledge changed
- version control actions were not performed unless requested

Do not recite this checklist in the final response. Report only:

- what changed
- what was verified
- what was not verified or remains open
