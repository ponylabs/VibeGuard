# 项目决策（Project Decisions）

记录人类批准的项目决策，或通过已接受任务结果清晰确立的决策。

不要记录 AI 猜测、偏好或泛泛总结。

## 架构决策（Architecture Decisions）

尚未记录。

模板：

```text
- user-approved: API 层保持 REST，不引入 GraphQL。
```

## 依赖决策（Dependency Decisions）

尚未记录。

模板：

```text
- user-approved: 服务端数据校验使用 zod，不再引入 yup。
```

## 测试决策（Testing Decisions）

尚未记录。

模板：

```text
- user-approved: MVP 阶段优先补关键路径回归测试，暂不建设完整 e2e 套件。
```

## 产品或交付决策（Product Or Delivery Decisions）

尚未记录。

模板：

```text
- user-approved: 当前版本接受手动导入数据，自动同步放入后续迭代。
```

## 已拒绝选项（Rejected Options）

尚未记录。

模板：

```text
- user-approved: 不采用 Redux；原因是当前状态复杂度不足以抵消维护成本。
```
