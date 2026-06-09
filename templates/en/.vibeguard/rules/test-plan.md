# Test Plan

This rule controls how AI writes, adjusts, and runs tests and static checks.

Testing here means the full verification system, not only test cases.

## Principle

Tests and static checks should prove the current change, not inflate coverage or process noise.

Use fixed project commands. Do not invent commands ad hoc.

Priority:

1. reuse existing tests or check commands
2. adjust existing tests or assertions
3. add focused tests only for clear gaps

## Check Types

Choose based on the project. Not every project needs all checks.

Static Checks:

- lint
- format check
- type check
- build
- security or dependency audit, if already configured

Behavior Tests:

- unit tests
- integration tests
- e2e tests
- regression tests

## Fixed Command Policy

Prefer fixed project commands recorded in `.vibeguard/state/project-commands.md`.

If state has no command, discover it from:

- package scripts
- Makefile
- pyproject.toml
- uv.lock
- justfile
- Taskfile
- README
- CI config
- user-provided command

When a durable command is found, suggest writing it back to `.vibeguard/state/project-commands.md` with an evidence label.

Do not directly run global `pytest`, `flake8`, `eslint`, `tsc`, `npm test`, or similar commands unless they are project-declared or user-provided.

Verification output should include the command actually run. Include source when known.

Example:

```text
Verified: `uv run pytest tests/foo_test.py` (source: uv project command)
```

## Before Adding Tests

Before adding tests, check:

- whether existing tests cover the same behavior
- whether existing assertions only need adjustment
- whether there is a closest existing test file
- whether the new test duplicates the same functional path
- whether a new test tool is needed; if yes, trigger dependency hard gate

If these checks cannot be completed, explain why before adding tests.

## Forbidden Behavior

Do not:

- add duplicate tests for the same behavior
- create a parallel test structure for convenience
- add a test framework or runner
- broadly rewrite legacy test setup
- write tests that only verify mock calls without verifying real behavior
- bypass all existing tests just because they are hard to understand
- use bare global commands as project verification

## Legacy Test Budget

Reuse first, but do not wrestle legacy tests indefinitely.

If existing tests cannot be safely reused after short inspection:

- add a focused regression test near the closest existing test location
- do not rewrite large setup
- explain in the handoff why existing tests were not reused
- if legacy tests block verification, record an open item instead of endlessly patching

## Verification Selection

Run the smallest check set that sufficiently proves the change.

Fast Path:

- may skip checks
- or run minimal static check, format check, or focused verification

Standard Path:

- run a reasonable combination of relevant static check, type check, focused test, or affected module test
- commands must come from fixed project commands, project scripts, README, CI, or user instruction

Governed Path:

- explain test and verification strategy first
- run static checks, type checks, focused tests, full suite, or build based on risk
- for dependency, framework, data, security, or public API changes, prefer build or higher-confidence verification

If checks cannot run, report reason and risk.

## State Update

When fixed project commands are discovered or confirmed, update `.vibeguard/state/project-commands.md`.

When a test gap, verification risk, or legacy test blockage is discovered, update `.vibeguard/state/open-items.md`.

State entries must be short and include an evidence label.
