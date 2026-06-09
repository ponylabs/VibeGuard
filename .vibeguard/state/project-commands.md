# Project Commands

记录当前项目固定命令。

AI 运行测试、静态检查、构建或本地服务时，应优先使用这里登记的命令。

不要记录一次性命令流水。只记录未来任务会复用的项目命令。

## Install

- observed-in-code: 本项目没有依赖安装命令；未发现 package manager 或依赖锁文件。

## Development

- observed-in-code: 本项目没有本地开发服务命令；仓库主体是 shell 安装器和 Markdown 模板。

## Static Checks

- observed-in-code: shell syntax check command is `sh -n install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh`.
- observed-in-code: release workflow runs shell syntax check with `sh -n install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh`, see .github/workflows/release.yml.

## Tests

- observed-in-code: installer test command is `sh tests/installers_test.sh`, from tests/installers_test.sh.
- observed-in-code: release workflow runs installer tests with `sh tests/installers_test.sh`, see .github/workflows/release.yml.

## Build

- observed-in-code: 本项目没有 build 命令；未发现构建配置或 package scripts。

## Verification Notes

- verified-by-command: `sh tests/installers_test.sh` passed.
- verified-by-command: `sh -n install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh` passed.
