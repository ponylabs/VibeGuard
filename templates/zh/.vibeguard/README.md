# VibeGuard

这里是 VibeGuard 项目治理入口。

## 首次使用

如果 `.vibeguard/state/` 还没有初始化，开始日常开发前先读取 `.vibeguard/bootstrap.md`。

Bootstrap 会判断当前是已有项目审计，还是新项目技术栈选型。它应该先提出 state 更新草案，等待用户确认后再写入。

建议提示词：

```text
读取 `.vibeguard/README.md` 并运行 VibeGuard Bootstrap。
如果这是已有项目，请审计当前项目并提出 state 更新草案。
如果这是新项目，请先引导我完成技术栈选型，再写入 state。
```

## 可选 Python 辅助脚本

VibeGuard 随模板提供两个项目本地 Python 辅助脚本，用于执行确定性检查：

```sh
python3 .vibeguard/bin/vibeguard-status.py
python3 .vibeguard/bin/vibeguard-audit.py
```

这些脚本只使用 Python 标准库。它们不会安装包、修改 shell 配置、创建虚拟环境，也不会给项目新增运行时依赖。

`vibeguard-status.py` 检查 VibeGuard 文件和 AI 入口 marker 是否存在。

`vibeguard-audit.py` 检查当前 git 改动，并提示依赖清单、锁文件、安装器、CI workflow、AI 入口文件或 VibeGuard 规则等治理风险。

如果当前项目本身不使用 Python，或者 `python3` 不可用，不要静默配置 Python 环境。请先向用户解释并征得许可，再为 VibeGuard 辅助脚本配置 Python 环境，并把获批的解释器命令或路径记录到 `.vibeguard/state/project-commands.md`。

如果辅助脚本无法运行，请继续使用下面的手动规则流程。

## VibeGuard 工作区边界

不要在 `.vibeguard/` 下新增文件。

AI agent 只能更新已有官方文件。项目事实、决策、命令、风险和后续事项必须写入 `.vibeguard/state/state-index.md` 列出的既有 `.vibeguard/state/` 文件。

如果信息无法放入既有文件，请在交付说明中报告，不要创建新的 `.vibeguard/` 文件。新的 VibeGuard 文件只能来自未来的 VibeGuard 模板版本和 `--update`。

## 语言约定

中文模板中，面向用户的标题、说明和脚本提示使用中文。

证据标签、风险值、文件名、命令、marker 和其他机器可依赖 token 保持英文，例如 `user-approved`、`observed-in-code`、`verified-by-command`、`low/medium/high`、`.vibeguard/state/` 和 `<!-- VIBEGUARD:START -->`。

必要时使用“中文标签（English anchor）”格式，例如“风险等级（Risk）”，兼顾中文可读性和 AI agent 的稳定理解。

## 更新 VibeGuard

当 VibeGuard 发布新版本后，可以在项目根目录重新运行对应安装器，并传入 `--update` 来刷新本项目的 VibeGuard。

Codex 示例：

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --update
```

`--update` 会刷新 VibeGuard README、bootstrap、rules、辅助脚本和 AI 入口 managed block。它会保留已有 `.vibeguard/state/` 文件，只复制缺失的 state 模板文件。

更新输出会报告本地 state schema 和模板 state schema 的版本。当前 VibeGuard 只报告 schema 差异，不会自动迁移 state。

## 日常任务

请按以下顺序阅读：

1. `.vibeguard/rules/task-flow.md`
2. `.vibeguard/rules/change-area.md`
3. `.vibeguard/rules/dependency-check.md`
4. `.vibeguard/rules/test-plan.md`
5. `.vibeguard/rules/final-check.md`
6. `.vibeguard/rules/state-update.md`
7. `.vibeguard/state/state-index.md`，然后只读取和当前任务相关的状态文件

`rules/` 存放跨项目通用的 AI 开发规范。

`state/` 存放当前项目自己的事实、决策、风险和验证记录；这些内容必须有证据支撑。
