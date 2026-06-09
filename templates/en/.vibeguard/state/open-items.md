# Open Items

Record unresolved risks, verification gaps, test gaps, and follow-up tasks.

Record only evidence-backed information worth carrying into future tasks.

Each entry should include: evidence label, item, impact, and suggested next step.

## Risks

No entries yet.

Template:

```text
- unresolved-risk: Password reset flow lacks e2e coverage. Impact: auth regression may be missed. Next: add key-path e2e before release.
```

## Verification Gaps

No entries yet.

Template:

```text
- unresolved-risk: Production build was not run. Impact: bundling errors may be missed. Next: configure and run fixed build command.
```

## Test Gaps

No entries yet.

Template:

```text
- unresolved-risk: Discount boundary cases lack regression tests. Impact: promo rule changes may regress. Next: add focused tests near checkout tests.
```

## Follow-Ups

No entries yet.

Template:

```text
- user-approved: Split billing service later. Impact: current module may keep growing. Next: evaluate split after payment MVP.
```
