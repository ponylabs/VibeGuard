# Project Commands

记录当前项目固定命令。

AI 运行测试、静态检查、构建或本地服务时，应优先使用这里登记的命令。

不要记录一次性命令流水。只记录未来任务会复用的项目命令。

## Install

- observed-in-code: Python 环境同步命令是 `uv sync`，见 pyproject.toml 和 uv.lock。
- observed-in-code: 当前 Python 依赖清单为空，见 pyproject.toml 和 uv.lock。

## Development

- observed-in-code: 本项目没有本地开发服务命令；仓库主体是 shell 安装器和 Markdown 模板。
- observed-in-code: installer generation command is `sh install/generate-installers.sh`.
- observed-in-code: Python helper scripts should be run with `uv run <command>` so they use the pinned Python 3.12 environment.
- observed-in-code: 根目录已安装的 VibeGuard status/audit helper 可用 `python3 .vibeguard/bin/vibeguard-status.py` 和 `python3 .vibeguard/bin/vibeguard-audit.py` 运行，见 .vibeguard/README.md。
- observed-in-code: 更新当前项目 VibeGuard 的命令是 `sh install/codex.sh --update --lang zh --version <tag> --yes`；更新模板文件并保留既有 state。

## Static Checks

- observed-in-code: shell syntax check command is `sh -n install/installer.template.sh install/generate-installers.sh install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh tests/vibeguard_cli_test.sh`.
- observed-in-code: Python helper syntax check command is `PYTHONPYCACHEPREFIX="${TMPDIR:-/tmp}/vibeguard-pycache" python3 -m py_compile templates/en/.vibeguard/bin/vibeguard-status.py templates/en/.vibeguard/bin/vibeguard-audit.py templates/zh/.vibeguard/bin/vibeguard-status.py templates/zh/.vibeguard/bin/vibeguard-audit.py`.
- observed-in-code: CI runs shell syntax checks on pull requests and pushes to main, see .github/workflows/ci.yml.
- observed-in-code: release workflow runs shell syntax check with `sh -n install/installer.template.sh install/generate-installers.sh install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh tests/vibeguard_cli_test.sh`, see .github/workflows/release.yml.
- observed-in-code: installer sync check is part of `sh tests/installers_test.sh`; it compares installer diffs before and after `sh install/generate-installers.sh`.

## Tests

- observed-in-code: installer test command is `sh tests/installers_test.sh`, from tests/installers_test.sh.
- observed-in-code: VibeGuard helper test command is `sh tests/vibeguard_cli_test.sh`, from tests/vibeguard_cli_test.sh.
- observed-in-code: CI runs installer tests on pull requests and pushes to main, see .github/workflows/ci.yml.
- observed-in-code: CI runs VibeGuard helper tests on pull requests and pushes to main, see .github/workflows/ci.yml.
- observed-in-code: release workflow runs installer tests with `sh tests/installers_test.sh`, see .github/workflows/release.yml.
- observed-in-code: release workflow runs VibeGuard helper tests with `sh tests/vibeguard_cli_test.sh`, see .github/workflows/release.yml.

## Build

- observed-in-code: 本项目没有 build 命令；未发现构建配置或 package scripts。

## Verification Notes

- verified-by-command: `sh tests/installers_test.sh` passed.
- verified-by-command: `sh tests/vibeguard_cli_test.sh` passed.
- verified-by-command: `sh -n install/installer.template.sh install/generate-installers.sh install/codex.sh install/claude.sh install/cursor.sh install/all.sh tests/installers_test.sh tests/vibeguard_cli_test.sh` passed.
- verified-by-command: `PYTHONPYCACHEPREFIX="${TMPDIR:-/tmp}/vibeguard-pycache" python3 -m py_compile templates/en/.vibeguard/bin/vibeguard-status.py templates/en/.vibeguard/bin/vibeguard-audit.py templates/zh/.vibeguard/bin/vibeguard-status.py templates/zh/.vibeguard/bin/vibeguard-audit.py` passed.
- verified-by-command: `sh install/codex.sh --update --lang zh --version v0.1.3 --yes` passed and reported `state schema: local 1, template 1`.
- verified-by-command: `python3 .vibeguard/bin/vibeguard-status.py` passed with `VibeGuard status: ok`.
- verified-by-command: `python3 .vibeguard/bin/vibeguard-audit.py` exited 0 and reported expected `attention needed` for governance rule/helper/test changes with state files updated.
- verified-by-command: `uv sync --offline` passed.
- verified-by-command: `uv run --offline python --version` printed Python 3.12.13.
