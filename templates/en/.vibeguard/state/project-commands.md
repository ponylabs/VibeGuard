# Project Commands

Record fixed project commands.

When AI runs tests, static checks, builds, or local services, it should prefer commands recorded here.

Do not record one-off command logs. Record only project commands future tasks will reuse.

## Install

No entries yet.

Template:

```text
- observed-in-code: install command is `pnpm install`, from pnpm-lock.yaml.
```

## Development

No entries yet.

Template:

```text
- observed-in-code: dev command is `pnpm dev`, from package.json.
```

## Static Checks

No entries yet.

Template:

```text
- observed-in-code: lint command is `pnpm lint`, from package.json.
- observed-in-code: format-check command is `pnpm format:check`, from package.json.
- observed-in-code: typecheck command is `pnpm typecheck`, from package.json.
```

## Tests

No entries yet.

Template:

```text
- observed-in-code: unit-test command is `pnpm test`, from package.json.
- observed-in-code: focused-test command is `pnpm test -- <path>`, from package.json.
- observed-in-code: e2e command is `pnpm e2e`, from package.json.
```

## Build

No entries yet.

Template:

```text
- observed-in-code: build command is `pnpm build`, from package.json.
```

## Verification Notes

No entries yet.

Template:

```text
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: build command is not configured; production build was not verified.
```
