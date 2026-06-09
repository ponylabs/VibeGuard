# Open Items

记录未解决风险、验证缺口、测试缺口和后续事项。

只记录有证据支撑、值得带入未来任务的信息。

每条建议包含：证据标签、事项、影响、建议下一步。

## Risks

尚未记录。

模板：

```text
- unresolved-risk: 密码重置流程缺少 e2e 覆盖。Impact: auth 回归可能漏检。Next: 发布前补关键路径 e2e。
```

## Verification Gaps

尚未记录。

模板：

```text
- unresolved-risk: 未运行生产 build。Impact: 打包错误可能未被发现。Next: 配置并运行固定 build 命令。
```

## Test Gaps

尚未记录。

模板：

```text
- unresolved-risk: 价格折扣边界条件缺少回归测试。Impact: 促销规则修改容易回归。Next: 在 checkout 测试附近补聚焦用例。
```

## Follow-Ups

尚未记录。

模板：

```text
- user-approved: 后续拆分 billing service。Impact: 当前模块继续增长会影响维护。Next: 完成支付 MVP 后评估拆分。
```
