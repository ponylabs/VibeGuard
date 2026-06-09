# Project Decisions

记录人类批准的项目决策，或通过已接受任务结果清晰确立的决策。

不要记录 AI 猜测、偏好或泛泛总结。

## Architecture Decisions

- user-approved: VibeGuard 仓库根目录可以保留并追踪 .vibeguard/，不再通过 .gitignore 忽略。
- observed-in-code: 安装器把 templates/<lang>/.vibeguard/ 复制到目标项目根目录，见 README.md 和 install/*.sh。
- user-approved: 工具安装器保持可直接 `curl | sh` 的 standalone 文件，但由 install/installer.template.sh 和 install/generate-installers.sh 生成，降低重复维护成本。

## Dependency Decisions

- user-approved: 使用 uv 初始化项目 Python 环境，用于后续需要 Python helper 或图片处理等工具脚本的场景。
- observed-in-code: 当前 Python 依赖清单为空；安装器仍使用系统 shell 和常见 Unix 工具，见 pyproject.toml、uv.lock 和 install/*.sh。

## Testing Decisions

- observed-in-code: 安装器行为通过 tests/installers_test.sh 覆盖，包含语言模板、entry 注入、dry-run、force、版本 URL 和 marker 幂等。
- observed-in-code: shell 脚本静态检查使用 `sh -n`。

## Product Or Delivery Decisions

- observed-in-code: VibeGuard 支持 Codex、Claude Code、Cursor，以及 all 安装器，见 README.md 和 install/。
- observed-in-code: VibeGuard 支持英文和中文模板；英文是默认安装语言，见 README.md。
- user-approved: 采用半自动 release/tag 流程；推送 `v*` tag 后由 GitHub Actions 先运行 shell 语法检查和 installer tests，再创建 GitHub Release。

## Rejected Options

- user-approved: 暂不采用纯手动 release 流程。
- user-approved: 不拆出运行时 sourced shell library；原因是 `curl | sh` 安装入口必须保持单文件可用。

模板：

```text
- user-approved: 不采用 Redux；原因是当前状态复杂度不足以抵消维护成本。
```
