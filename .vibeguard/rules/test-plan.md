# Test Plan

本规则用于控制 AI 如何编写、调整和运行测试与静态检查。

这里的 testing 指完整验证体系，不只包含测试用例。

## 原则

测试和静态检查用于证明本次变更，而不是堆覆盖率或制造流程噪音。

使用项目固定命令，不临时发明命令。

优先级：

1. 复用现有测试或检查命令
2. 调整现有测试或断言
3. 在明确缺口处新增聚焦测试

## 检查类型

根据项目实际情况选择，不要求每个项目都有全部检查。

Static Checks:

- lint
- format check
- type check
- build
- security 或 dependency audit，前提是项目已经配置

Behavior Tests:

- unit tests
- integration tests
- e2e tests
- regression tests

## 固定命令策略

优先使用 `.vibeguard/state/project-commands.md` 中登记的固定项目命令。

如果 state 未登记命令，从以下位置查找：

- package scripts
- Makefile
- pyproject.toml
- uv.lock
- justfile
- Taskfile
- README
- CI config
- user-provided command

找到持久命令后，建议用证据标签写回 `.vibeguard/state/project-commands.md`。

不要直接运行全局 `pytest`、`flake8`、`eslint`、`tsc`、`npm test` 等命令，除非它们是项目声明命令或用户指定命令。

验证输出中应说明实际运行命令；能确定来源时，也说明来源。

示例：

```text
Verified: `uv run pytest tests/foo_test.py` (source: uv project command)
```

## 新增测试前必须检查

新增测试前，先检查：

- 是否已有测试覆盖同一行为
- 是否只需要调整现有断言
- 是否存在最接近的测试文件
- 是否会重复测试同一个功能路径
- 是否需要新测试工具；如果需要，触发 dependency hard gate

如果无法完成这些检查，先说明原因，不要直接堆新测试。

## 禁止行为

不要：

- 为同一行为重复新增测试
- 为了方便新建平行测试结构
- 新增测试框架或 runner
- 大规模重写 legacy test setup
- 写只验证 mock 调用、但不验证真实行为的测试
- 因为现有测试难懂就绕开全部旧测试
- 用裸跑全局命令冒充项目验证

## Legacy Test Budget

优先复用，但不要和遗留测试无限缠斗。

如果短时间检查后仍无法安全复用旧测试：

- 在最接近的位置新增聚焦回归测试
- 不重写大型 setup
- 在交付中说明为什么没有复用旧测试
- 如果遗留测试阻塞验证，记录为 open item，而不是无限修补

## 验证选择

运行最小但足够证明变更的检查集合。

Fast Path:

- 可不运行检查
- 或运行最小静态检查、格式检查、聚焦验证

Standard Path:

- 至少运行相关静态检查、类型检查、聚焦测试或受影响模块测试中的合理组合
- 命令必须来自项目固定命令、项目脚本、README、CI 或用户指令

Governed Path:

- 先说明测试和验证策略
- 根据风险运行静态检查、类型检查、聚焦测试、完整测试套件或 build
- 涉及依赖、框架、数据、安全或公开 API 时，优先包含 build 或更高置信度验证

无法运行检查时，报告原因和风险。

## State 更新

当发现或确认固定项目命令时，更新 `.vibeguard/state/project-commands.md`。

当发现测试缺口、无法验证的风险或遗留测试阻塞时，更新 `.vibeguard/state/open-items.md`。

state 条目必须简短，并包含证据标签。
