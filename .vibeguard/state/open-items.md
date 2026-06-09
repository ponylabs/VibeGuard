# Open Items

记录未解决风险、验证缺口、测试缺口和后续事项。

只记录有证据支撑、值得带入未来任务的信息。

每条建议包含：证据标签、事项、影响、建议下一步。

## Risks

- unresolved-risk: 尚未配置 PR/main 分支 CI；当前 GitHub Actions 只在 `v*` tag release 时运行验证。Impact: 普通提交和 PR 仍无法自动拦截安装器回归。Next: 需要持续集成时，增加 push/PR workflow 复用 release 中的 shell 语法检查和 installer tests。

## Verification Gaps

- unresolved-risk: release workflow 尚未在真实 GitHub tag push 上跑过。Impact: 首次发布前仍需确认 GitHub Release 权限和生成说明符合预期。Next: 推送首个 `v*` tag 后检查 Actions 与 Release 页面。

## Test Gaps

- unresolved-risk: 当前测试覆盖安装器核心行为，但没有真实网络下载端到端验证。Impact: GitHub archive 或 raw URL 变化可能只在真实安装时暴露。Next: release 前手动跑一次真实安装命令或在 CI 中增加受控 smoke test。

## Follow-Ups

- user-approved: docs/superpowers/ 是本地设计和计划文档，不加入 GitHub。Impact: 发布内容保持聚焦。Next: 继续通过 .gitignore 排除。
