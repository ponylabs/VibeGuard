# Open Items

记录未解决风险、验证缺口、测试缺口和后续事项。

只记录有证据支撑、值得带入未来任务的信息。

每条建议包含：证据标签、事项、影响、建议下一步。

## Risks

尚未记录。

## Verification Gaps

尚未记录。

## Test Gaps

- unresolved-risk: 当前测试覆盖安装器核心行为，且 Codex main 真实网络安装和 Codex `--update --lang zh --version v0.1.4` 已手动 smoke 通过；但 CI 尚未自动覆盖真实网络安装，也未覆盖 Claude/Cursor/all 或所有 tag 安装。Impact: GitHub archive、raw URL 或工具入口差异可能只在真实安装时暴露。Next: 在 CI 中增加受控 smoke test，或 release 前手动验证各入口和 tag 安装。

## Follow-Ups

- user-approved: docs/superpowers/ 是本地设计和计划文档，不加入 GitHub。Impact: 发布内容保持聚焦。Next: 继续通过 .gitignore 排除。
