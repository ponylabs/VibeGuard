# Project Info

记录当前项目相对稳定、后续任务会反复用到的事实。

不要记录通用规则、临时过程或可以低成本从代码中查到的小细节。

## Tech Stack

尚未记录。

模板：

```text
- observed-in-code: 前端使用 React，见 package.json。
- observed-in-code: 后端使用 FastAPI，见 pyproject.toml。
```

## Runtime And Environment

尚未记录。

模板：

```text
- observed-in-code: Python 版本要求为 3.12，见 .python-version。
- user-approved: 本项目本地开发必须使用 uv 管理虚拟环境。
```

## Package And Tooling

尚未记录。

模板：

```text
- observed-in-code: 包管理器为 pnpm，见 pnpm-lock.yaml。
- observed-in-code: TypeScript 配置入口为 tsconfig.json。
```

## Key Directories

尚未记录。

模板：

```text
- observed-in-code: API 路由位于 src/routes/。
- observed-in-code: 共享 UI 组件位于 src/components/。
```

## Module Boundaries

尚未记录。

模板：

```text
- observed-in-code: billing 模块不直接访问 auth 数据库表，见 src/billing/README.md。
```

## Project Conventions

尚未记录。

模板：

```text
- user-approved: 新页面优先复用现有布局组件，不新增平行布局系统。
```
