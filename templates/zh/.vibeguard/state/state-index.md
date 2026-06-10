# 状态索引（State Index）

本目录记录当前项目有证据支撑的状态。

通用规则存放在 `.vibeguard/rules/`。不要把通用规则写进 state 文件。

`.schema-version` 记录本目录的 state 结构版本。当前版本为 `1`；它只用于未来更新脚本比较本地 state 结构和模板 state 结构，不表示规则版本，也不要求自动迁移。

## 读取规则

默认只读本文件。

然后根据当前任务读取相关文件：

- 项目事实：`.vibeguard/state/project-info.md`
- 固定命令：`.vibeguard/state/project-commands.md`
- 人类批准的决策：`.vibeguard/state/project-decisions.md`
- 未解决事项：`.vibeguard/state/open-items.md`

不要默认通读所有 state 文件。

如果 state 与代码、依赖清单、配置、测试、CI 或当前用户指令冲突，信任项目现实，并报告 state 可能已经过期。

## 文件用途

| 文件 | 用途 | 何时读取 |
| --- | --- | --- |
| `project-info.md` | 技术栈、运行环境、目录结构、模块边界、项目约定 | 需要理解项目结构或实现位置时 |
| `project-commands.md` | 安装、运行、lint、typecheck、test、build 等固定命令 | 需要运行检查、测试、构建或本地服务时 |
| `project-decisions.md` | 用户批准或已接受任务确立的项目决策 | 涉及架构、依赖、工具、测试策略、产品取舍时 |
| `open-items.md` | 未解决风险、验证缺口、测试缺口、后续事项 | 任务可能触碰已知风险或交付前检查未闭环事项时 |

## 维护要求

- 只记录有证据支撑、未来任务会用到的信息。
- 条目保持简短，通常 1-2 行。
- 优先更新或删除过期条目，不要无限追加。
- 每条内容应包含证据标签，例如 `user-approved`、`observed-in-code`、`verified-by-test`、`verified-by-command`、`unresolved-risk`。
