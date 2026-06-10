# 项目命令（Project Commands）

记录当前项目固定命令。

AI 运行测试、静态检查、构建或本地服务时，应优先使用这里登记的命令。

不要记录一次性命令流水。只记录未来任务会复用的项目命令。

## 安装（Install）

尚未记录。

模板：

```text
- observed-in-code: install command is `pnpm install`, from pnpm-lock.yaml.
```

## 开发（Development）

尚未记录。

模板：

```text
- observed-in-code: dev command is `pnpm dev`, from package.json.
- user-approved: VibeGuard helper interpreter is `python3`, approved for this project.
```

## 静态检查（Static Checks）

尚未记录。

模板：

```text
- observed-in-code: lint command is `pnpm lint`, from package.json.
- observed-in-code: format-check command is `pnpm format:check`, from package.json.
- observed-in-code: typecheck command is `pnpm typecheck`, from package.json.
```

## 测试（Tests）

尚未记录。

模板：

```text
- observed-in-code: unit-test command is `pnpm test`, from package.json.
- observed-in-code: focused-test command is `pnpm test -- <path>`, from package.json.
- observed-in-code: e2e command is `pnpm e2e`, from package.json.
```

## 构建（Build）

尚未记录。

模板：

```text
- observed-in-code: build command is `pnpm build`, from package.json.
```

## 验证记录（Verification Notes）

尚未记录。

模板：

```text
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: build command is not configured; production build was not verified.
```
