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
