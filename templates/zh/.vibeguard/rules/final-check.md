# 最终检查（Final Check）

本规则用于控制 AI 什么时候可以声称任务完成，以及如何报告验证结果、验证失败和验证缺口。

`final-check.md` 只定义完成门槛和证据要求。测试与静态检查命令选择遵守 `.vibeguard/rules/test-plan.md`。

## 原则

没有新鲜验证证据，不得声称任务完成。

验证应证明本次任务的成功标准，而不是制造流程噪音。

声称成功前，必须读取验证命令或检查结果的输出。

声称完成前，必须完成 state reconciliation：检查本次任务是否产生需要未来任务复用的项目事实、固定命令、人类批准决策、风险或验证缺口。需要时按 `.vibeguard/rules/state-update.md` 更新 `.vibeguard/state/`；不需要时，在最终回复中简短说明 state 未更新的原因。

## 可接受验证

根据任务风险选择最小但足够的验证。

可接受验证包括：

- 项目固定命令
- lint 或静态分析
- format check
- type check
- 聚焦测试
- 受影响模块测试
- 完整测试套件
- build
- 用户指定的手动验证

验证命令优先来自 `.vibeguard/state/project-commands.md` 中登记的固定项目命令。

如果没有登记命令，按 `.vibeguard/rules/test-plan.md` 从项目脚本、README、CI 或用户指令中查找。

## 不可接受验证

不要把以下内容当作完成证据：

- “看起来没问题”
- “应该可以”
- 只读代码但没有运行检查
- 裸跑非项目命令冒充项目验证
- 用 lint 通过推导业务正确
- 用 type check 通过推导运行时行为正确
- 用无关测试通过推导本次变更正确
- 忽略失败检查后声称完成

## verified-by-command 边界

`verified-by-command` 只能记录命令结果。

它不能用于写入业务、架构或产品结论。

允许：

```text
- verified-by-command: `pnpm test` passed with 42 tests.
```

不允许：

```text
- verified-by-command: checkout logic is correct.
```

## 验证失败

如果验证失败：

- 不得声称任务完成
- 报告失败命令
- 摘要说明失败原因
- 区分看起来是本次变更导致，还是既有问题
- 无法判断时停止并说明不确定性

不要为了让检查通过而扩大修改范围，除非用户确认。

## 无法验证

如果无法运行必要验证：

- 说明没运行什么
- 说明原因
- 说明风险
- 在最终回复的 `Open:` 中记录验证缺口
- 有必要时写入 `.vibeguard/state/open-items.md`

无法验证时，可以交付变更，但不得把它描述为已完全验证。

## 最终回复

最终回复必须包含验证结果或验证缺口。

最终回复还必须包含 state 更新结果或不更新原因。

使用简洁格式：

```text
Verified: `command` passed.
State: updated `.vibeguard/state/project-info.md`.
```

或：

```text
Open: 未运行 `command`，原因是 ...；风险是 ...
State: 未更新；本次变更未产生新的持久项目知识。
```

不要输出完整内部 checklist。
