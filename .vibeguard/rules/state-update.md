# 状态更新（State Update）

本规则用于定义任务结束后如何读取、判断和更新 `.vibeguard/state/`。

`state/` 存放当前项目的实际情况，不存放通用规则。

## 原则

`.vibeguard/state/` 不是 AI 日记，也不是项目真理来源。

只记录有证据支撑、未来任务会用到的项目知识。

不要把临时过程、猜测、偏好或普通总结写入 state。

## 事实来源

state 是提示账本，不是真理来源。

按以下优先级信任信息：

1. 当前用户指令
2. 代码、依赖清单、配置文件、测试和 CI 文件
3. 项目文档
4. `.vibeguard/state/`

如果 state 和项目现实冲突，信任项目现实，并报告 state 可能已过期。

## 写入位置

根据内容写入对应文件：

- 项目事实、技术栈、运行环境、目录约定：`.vibeguard/state/project-info.md`
- 固定项目命令：`.vibeguard/state/project-commands.md`
- 人类批准的架构、依赖、工具或产品决策：`.vibeguard/state/project-decisions.md`
- 未解决风险、验证缺口、测试缺口、后续事项：`.vibeguard/state/open-items.md`

`.vibeguard/` 是封闭工作区。不要在 `.vibeguard/` 下新增文件，包括新的 state 文件、notes、plans、scratchpads、snapshots、logs 或 summaries。

如果信息无法放入以上官方文件，请在交付说明中报告，不要创建新文件。新的 VibeGuard 文件只能来自未来的 VibeGuard 模板版本和 `--update`。

不要把通用规则写入 state 文件。

## 证据标签

允许的证据标签：

- `user-approved`
- `observed-in-code`
- `verified-by-test`
- `verified-by-command`
- `unresolved-risk`

状态条目应使用最准确的窄分类：

- facts: `observed-in-code` 或 `user-approved`
- decisions: `user-approved`
- risks: `unresolved-risk` 或失败验证证据
- coverage: `verified-by-test`
- commands: `verified-by-command`

`verified-by-command` 只能记录命令结果，不能用于写入业务、架构或产品结论。

## 可以写入

可以写入：

- 用户明确批准的决策
- 从代码、配置、依赖清单、测试或 CI 中观察到的持久事实
- 固定项目命令及其来源
- 测试或验证明确覆盖的行为
- 未解决且会影响后续任务的风险
- 无法完成验证的原因和风险

## 禁止写入

不要写入：

- 猜测
- 个人偏好
- 泛泛总结
- 临时过程
- 一次性命令流水
- 没有长期价值的信息
- 可以从代码低成本查到的细节
- 未经验证的业务结论
- 用命令通过推导出的业务正确性

## 写入前检查

更新 state 前，确认：

- 项目知识是否真的发生变化
- 未来任务是否会受益
- 是否有明确证据标签
- 应该写入哪个 state 文件
- 是否应替换旧条目，而不是追加
- 是否与代码、配置、依赖、测试或 CI 冲突
- 是否没有创建新的 `.vibeguard/` 文件

如果答案不清楚，不要写入 state；在交付中简短说明即可。

## 交付前复查

Standard Path 或 Governed Path 在最终回复前必须做 state reconciliation。

检查本次任务是否改变了以下长期信息：

- 项目事实、技术栈、运行环境、目录结构或模块边界：更新 `.vibeguard/state/project-info.md`
- 固定命令、验证命令、CI 检查或运行方式：更新 `.vibeguard/state/project-commands.md`
- 用户批准的架构、依赖、工具、产品或流程决策：更新 `.vibeguard/state/project-decisions.md`
- 未解决风险、验证缺口、测试缺口或后续事项：更新 `.vibeguard/state/open-items.md`

如果任务修改了 README、CI、安装器、模板、测试、治理规则或工具脚本，但没有更新任何 state 文件，必须显式复查是否漏记项目知识。

复查后，如果不需要更新 state，在最终回复中说明原因，例如：

```text
State: 未更新；本次变更只修正文案，没有产生新的持久项目知识。
```

## 体积控制

state 文件必须保持紧凑：

- 条目通常 1-2 行
- 优先更新或删除过期条目
- 不要无限追加
- 不要复制大段日志、错误输出或计划
- 文件变得难以扫描时，按主题拆分，并更新 `.vibeguard/state/state-index.md`

## 读取预算

不要默认加载所有 state 文件。

默认先读取：

```text
.vibeguard/state/state-index.md
```

然后只读取和当前任务、受影响模块、依赖、测试区域或开放风险相关的 state 文件。

如果没有 state index，只读取明显相关的 state 文件，并报告 state 缺失。

## 示例

```text
- user-approved: 使用 pnpm 作为本项目包管理器。
- observed-in-code: 后端路由挂载在 /api，见 src/server.ts。
- verified-by-test: 折扣计算行为由 tests/checkout/discount.test.ts 覆盖。
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: 密码重置流程缺少 e2e 覆盖。
```
