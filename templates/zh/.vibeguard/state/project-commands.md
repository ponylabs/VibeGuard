# Project Commands

记录当前项目固定命令。

AI 运行测试、静态检查、构建或本地服务时，应优先使用这里登记的命令。

不要记录一次性命令流水。只记录未来任务会复用的项目命令。

## Install

尚未记录。

模板：

```text
- observed-in-code: install command is `pnpm install`, from pnpm-lock.yaml.
```

## Development

尚未记录。

模板：

```text
- observed-in-code: dev command is `pnpm dev`, from package.json.
- user-approved: VibeGuard helper interpreter is `python3`, approved for this project.
```

## Static Checks

尚未记录。

模板：

```text
- observed-in-code: lint command is `pnpm lint`, from package.json.
- observed-in-code: format-check command is `pnpm format:check`, from package.json.
- observed-in-code: typecheck command is `pnpm typecheck`, from package.json.
```

## Tests

尚未记录。

模板：

```text
- observed-in-code: unit-test command is `pnpm test`, from package.json.
- observed-in-code: focused-test command is `pnpm test -- <path>`, from package.json.
- observed-in-code: e2e command is `pnpm e2e`, from package.json.
```

## Build

尚未记录。

模板：

```text
- observed-in-code: build command is `pnpm build`, from package.json.
```

## Verification Notes

尚未记录。

模板：

```text
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: build command is not configured; production build was not verified.
```
