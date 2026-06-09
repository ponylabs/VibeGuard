# Dependency Check

本规则用于控制 AI 是否可以新增、替换、升级或删除依赖。

依赖规则是跨项目通用规则。当前项目已批准的依赖事实和决策应记录在 `.vibeguard/state/`。

## 原则

默认不新增依赖。

优先使用：

1. 标准库
2. 项目已有依赖
3. 项目已有工具链
4. 小范围本地实现

只有当现有能力明显不足，且收益超过长期维护成本时，才考虑新增依赖。

不要为了少写几行代码新增依赖。

## Hard Gate

以下情况必须先询问用户：

- 新增 runtime dependency
- 新增 dev dependency
- 替换已有库
- 删除已有库
- 升级主框架或核心工具
- 引入新的包管理器、构建工具、测试工具或代码生成工具
- 修改 lockfile
- 修改全局环境、系统环境或用户级工具配置

触发 hard gate 时，停止改文件，说明原因，并给出最小可行选项。

## 新增依赖前必须说明

提出依赖变更前，必须简短说明：

- 为什么现有依赖或标准库不能解决
- 为什么不适合小范围本地实现
- 该依赖属于 runtime 还是 dev
- 会影响哪些文件
- 是否影响构建、测试、部署、包体积或运行环境
- 是否有项目内已有同类能力
- 是否需要更新 `.vibeguard/state/project-info.md` 或 `.vibeguard/state/project-decisions.md`

如果无法回答这些问题，不要引入依赖。

## 禁止行为

不要：

- 因为示例代码用了某个库就跟着引入
- 在项目已有同类库时再引入重复能力库
- 同时引入多个候选库再比较
- 未经批准修改 lockfile
- 未经批准安装全局包
- 未经批准引入新的测试框架
- 未经批准更换包管理器
- 为一次性脚本引入长期依赖
- 用依赖变更掩盖对现有代码理解不足

## 验证

依赖变更获批后，必须运行项目声明的安装、构建、测试、类型检查或 lint 命令中与本次变更相关的最小集合。

验证命令应来自：

- package script
- Makefile target
- uv 或项目环境命令
- justfile 或 task runner
- README instruction
- CI config
- user-provided command

不要用裸跑全局命令冒充项目验证。

## State 更新

依赖变更获批并完成后，按证据更新 state：

- `.vibeguard/state/project-info.md`：记录当前项目事实，例如已使用的包管理器、关键依赖和工具链
- `.vibeguard/state/project-commands.md`：记录安装、测试、构建等固定命令
- `.vibeguard/state/project-decisions.md`：记录人类批准的依赖方向或库选择
- `.vibeguard/state/open-items.md`：记录未完成迁移、验证缺口或依赖风险

state 条目必须简短，并包含证据标签，例如：

```text
- user-approved: 使用 pnpm 作为本项目包管理器。
- observed-in-code: 项目依赖 React Query，见 package.json。
- verified-by-command: `pnpm test` passed with 42 tests.
- unresolved-risk: 新增图表库后尚未验证生产包体积。
```
