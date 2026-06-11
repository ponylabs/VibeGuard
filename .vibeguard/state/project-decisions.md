# Project Decisions

记录人类批准的项目决策，或通过已接受任务结果清晰确立的决策。

不要记录 AI 猜测、偏好或泛泛总结。

## Architecture Decisions

- user-approved: VibeGuard 仓库根目录可以保留并追踪 .vibeguard/，不再通过 .gitignore 忽略。
- observed-in-code: 安装器把 templates/<lang>/.vibeguard/ 复制到目标项目根目录，见 README.md 和 install/*.sh。
- user-approved: 工具安装器保持可直接 `curl | sh` 的 standalone 文件，但由 install/installer.template.sh 和 install/generate-installers.sh 生成，降低重复维护成本。
- user-approved: VibeGuard 更新模式先保留已有 `.vibeguard/state/` 内容，只更新 README、bootstrap、rules、bin 和工具入口 block；state schema 差异只报告不迁移。
- user-approved: VibeGuard status/audit 先作为项目本地 Python 标准库辅助脚本交付，不做全局 CLI、不改 PATH、不新增第三方依赖。
- user-approved: 如果客户项目本身不涉及 Python，AI 不能静默配置 Python 环境；需先解释、征得许可，并把获批解释器记录到 `.vibeguard/state/project-commands.md`。
- user-approved: VibeGuard 完成门槛包含 state reconciliation；最终回复必须说明 state 更新结果或不更新原因。
- user-approved: 中文本地化采用“用户可见内容中文化、机器可依赖 token 保持英文”的边界；证据标签、风险值、文件名和命令名不翻译，必要时使用中文标签加英文锚点。

## Dependency Decisions

- user-approved: 使用 uv 初始化项目 Python 环境，用于后续需要 Python helper 或图片处理等工具脚本的场景。
- observed-in-code: 当前 Python 依赖清单为空；安装器仍使用系统 shell 和常见 Unix 工具，见 pyproject.toml、uv.lock 和 install/*.sh。

## Testing Decisions

- observed-in-code: 安装器行为通过 tests/installers_test.sh 覆盖，包含语言模板、entry 注入、dry-run、force、版本 URL 和 marker 幂等。
- observed-in-code: 安装器 update 模式通过 tests/installers_test.sh 覆盖，包含保留 state、刷新 rules/bin、补缺失 state、schema 版本报告、dry-run 和 help。
- observed-in-code: VibeGuard helper 与 README 指引通过 tests/vibeguard_cli_test.sh 覆盖。
- observed-in-code: audit 的 state review 提醒通过 tests/vibeguard_cli_test.sh 覆盖，包含未更新 state 时提醒、已更新 state 时不提醒。
- observed-in-code: shell 脚本静态检查使用 `sh -n`。

## Product Or Delivery Decisions

- observed-in-code: VibeGuard 支持 Codex、Claude Code、Cursor，以及 all 安装器，见 README.md 和 install/。
- observed-in-code: VibeGuard 支持英文和中文模板；英文是默认安装语言，见 README.md。
- observed-in-code: 中文模板标题使用中文加英文锚点，例如 `任务流程（Task Flow）` 和 `风险等级（Risk）`，见 templates/zh/.vibeguard/。
- user-approved: 采用半自动 release/tag 流程；推送 `v*` tag 后由 GitHub Actions 先运行 shell 语法检查、Python helper 语法检查、installer tests 和 helper tests，再创建 GitHub Release。

## Rejected Options

- user-approved: 暂不采用纯手动 release 流程。
- user-approved: 不拆出运行时 sourced shell library；原因是 `curl | sh` 安装入口必须保持单文件可用。

模板：

```text
- user-approved: 不采用 Redux；原因是当前状态复杂度不足以抵消维护成本。
```
