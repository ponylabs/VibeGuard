# Change Area

This rule controls the allowed change boundary for AI-assisted work.

`change-area.md` is a general cross-project rule. Project-specific boundaries, facts, and constraints belong in `.vibeguard/state/`.

## Principle

Change only what is necessary to satisfy the current user request.

Do not improve, refactor, rename, reorganize, or clean up unrelated code unless the user explicitly asks for it.

Classify the whole logical change, not just the next small edit.

## Allowed Changes

You may edit:

- files directly required by the task
- tests directly covering the changed behavior
- documentation directly affected by the change
- `.vibeguard/state/` only when evidence-backed project knowledge changed

Keep changes close to the existing project style and structure.

## Out-Of-Scope Changes

Do not make these changes without explicit user approval:

- unrelated refactors
- broad formatting changes
- dependency changes
- new frameworks or libraries
- new test tools or test structure
- renaming files, modules, APIs, or directories
- deleting existing code not directly related to the task
- changing generated files, lockfiles, vendor code, or secrets
- changing behavior outside the requested feature or bugfix
- adding speculative abstractions or future-proofing

## Existing Problems

If you notice unrelated problems:

- mention them in the handoff when relevant
- do not fix them during the current task
- add them to `.vibeguard/state/open-items.md` only when they are evidence-backed and worth tracking

Do not turn incidental observations into project state.

## Scope Drift

Stop and ask the user when:

- the required change is larger than expected
- the task reveals an architectural issue
- the fix requires touching many files
- requested behavior conflicts with existing rules or project state
- continuing would require guessing
- repeated small edits appear to be one larger logical change

## Minimality Check

Before final response, internally confirm:

- every changed file maps to the user request
- every new test covers changed behavior
- no dependency or framework was added without approval
- no unrelated cleanup was included
- `.vibeguard/state/` was updated only for evidence-backed project knowledge
