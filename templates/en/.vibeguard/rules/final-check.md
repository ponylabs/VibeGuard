# Final Check

This rule controls when AI may claim task completion, and how to report verification results, failures, and gaps.

`final-check.md` defines only completion threshold and evidence requirements. Test and static check command selection follows `.vibeguard/rules/test-plan.md`.

## Principle

Do not claim completion without fresh verification evidence.

Verification should prove the task success criteria, not create process noise.

Before claiming success, read the output of verification commands or checks.

Before claiming completion, perform state reconciliation: check whether this task created project facts, fixed commands, human-approved decisions, risks, or verification gaps that future tasks should reuse. When needed, update `.vibeguard/state/` according to `.vibeguard/rules/state-update.md`; when not needed, briefly state why state was not updated in the final response.

## Acceptable Verification

Choose the smallest sufficient verification based on task risk.

Acceptable verification includes:

- fixed project commands
- lint or static analysis
- format check
- type check
- focused tests
- affected module tests
- full test suite
- build
- user-specified manual verification

Verification commands should first come from fixed project commands recorded in `.vibeguard/state/project-commands.md`.

If no command is recorded, follow `.vibeguard/rules/test-plan.md` to discover commands from project scripts, README, CI, or user instructions.

## Unacceptable Verification

Do not treat these as completion evidence:

- "looks fine"
- "should work"
- only reading code without running checks
- running non-project global commands as project verification
- using lint success to infer business correctness
- using type check success to infer runtime behavior correctness
- using unrelated test success to infer this change is correct
- ignoring failed checks and claiming completion

## verified-by-command Boundary

`verified-by-command` may only record command results.

It must not be used for business, architecture, or product conclusions.

Allowed:

```text
- verified-by-command: `pnpm test` passed with 42 tests.
```

Not allowed:

```text
- verified-by-command: checkout logic is correct.
```

## Verification Failure

If verification fails:

- do not claim completion
- report the failed command
- summarize the failure
- distinguish whether it appears caused by the current change or pre-existing
- stop and state uncertainty when unsure

Do not expand scope just to make checks pass unless the user confirms.

## Unable To Verify

If necessary verification cannot run:

- state what was not run
- state why
- state the risk
- record the verification gap in final response `Open:`
- update `.vibeguard/state/open-items.md` when useful

When unable to verify, you may hand off the change, but must not describe it as fully verified.

## Final Response

Final response must include verification result or verification gap.

Final response must also include state update result or why no state update was needed.

Use concise format:

```text
Verified: `command` passed.
State: updated `.vibeguard/state/project-info.md`.
```

or:

```text
Open: did not run `command` because ...; risk is ...
State: not updated; this change did not create new persistent project knowledge.
```

Do not output the full internal checklist.
