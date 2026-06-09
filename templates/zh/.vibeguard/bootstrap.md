# Bootstrap

本文件用于 VibeGuard 安装后，或 `.vibeguard/state/` 基本为空、明显过期时使用。

Bootstrap 不是日常开发流程。它的目标是在常规任务开始前，帮助 AI 理解当前项目。

## 目标

选择一条路径：

- 已有项目：审计当前项目，并提出 state 更新草案。
- 新项目：先引导技术栈选型，再写入项目决策。

除非用户明确把它作为单独任务要求，否则 Bootstrap 期间不要修改业务代码、安装依赖、重写测试或创建新架构。

## 原则

- 先观察项目现实，再写入 state。
- 缺少信息不等于可以编造信息。
- 缺失项会影响后续安全开发时，先询问用户。
- 先提出 state 修改草案，用户确认后再写入。
- `.vibeguard/state/` 只写有证据支撑的信息。
- 重要但未闭环的缺口使用 `unresolved-risk`。

## 已有项目审计

按优先级扫描项目。保持聚焦，不要通读所有文件。

### P0 必须扫描

这些项目会影响 AI 后续能否安全工作。

| 范围 | 扫描对象 | 缺失时 |
| --- | --- | --- |
| 项目类型 | README、根目录文件、目录命名、框架配置 | 让用户确认项目类型，不要猜。 |
| 技术栈与运行时 | `package.json`、`pyproject.toml`、`go.mod`、`Cargo.toml`、`pom.xml`、`.python-version`、`.nvmrc`、`Dockerfile` | 让用户选择语言、框架和运行时版本。 |
| 包管理器与锁文件 | `pnpm-lock.yaml`、`package-lock.json`、`yarn.lock`、`uv.lock`、`poetry.lock`、`requirements.txt`、`go.sum`、`Cargo.lock` | 如果近期会改依赖，标记为 Blocker，并询问使用哪个包管理器。 |
| 固定命令 | package scripts、`Makefile`、`justfile`、`Taskfile.yml`、README、CI | 建议固定 install、dev、静态检查、test、build 命令。 |
| 关键目录 | `src/`、`app/`、`pages/`、`server/`、`tests/`、`docs/`、`packages/`、`apps/` | 建议先建立简单目录边界，避免后续功能扩散。 |
| 测试现状 | 测试目录、测试配置、测试脚本、CI 测试任务 | 建议最小可用测试策略。未经批准不要引入新测试框架。 |
| 静态检查 | ESLint、Prettier、TypeScript、Biome、Ruff、Mypy、Black、Clippy、CI 检查 | 根据已观察到的技术栈，建议最小静态检查。 |
| 环境与密钥 | `.env.example`、README 环境说明、Docker Compose、devcontainer、CI secrets 引用 | 建议记录必需环境变量。不要读取或记录密钥值。 |

### P1 建议扫描

这些项目能减少后续漂移，但不应该阻塞 Bootstrap。

| 范围 | 扫描对象 | 缺失时 |
| --- | --- | --- |
| CI 与发布流程 | `.github/workflows/`、GitLab CI、Dockerfile、部署说明 | 建议最小 CI：install、静态检查、test、build。 |
| 模块边界 | 目录命名、局部 README、workspace 配置、import 关系 | 只记录已观察到的边界；不清楚的边界写入 `open-items.md`。 |
| 现有决策 | README、ADR、docs、已接受的实现模式 | 写入前先让用户确认重要决策。 |
| 高风险区域 | auth、权限、支付、migration、数据删除、安全、infra | 明确存在时，标记为 Governed Path 区域。 |

### P2 可选扫描

这些内容可以以后再补：

- 文档完整度
- 性能基准
- 端到端测试覆盖
- Storybook 或组件文档
- 可观测性
- 发布版本策略
- 代码所有权

## 缺失项等级

按以下方式分类缺口：

- Blocker：后续安全开发前需要人类先决策。
- Recommendation：建议尽快补，但普通开发可以继续。
- Optional：等项目真的需要时再补。

缺少信息不代表 AI 应该自动创建文件或安装工具。

## 已有项目输出格式

写入 state 前，先输出这个草案：

```text
项目体检结果

已发现：
- ...

缺失项：
- ...

建议：
- ...

State 更新草案：
- project-info.md: ...
- project-commands.md: ...
- project-decisions.md: ...
- open-items.md: ...

需要用户确认：
- ...
```

用户确认后，只更新 `.vibeguard/state/` 下相关文件。

## 新项目技术栈选型

新项目通常没有足够的项目现实可以扫描。不要把猜测写进 `project-info.md`。

只询问启动项目必要的决策：

1. 项目类型是什么？
2. 用户偏好的语言或框架是什么？
3. 项目会在哪里运行或部署？
4. 是否需要数据库 migration、认证、支付、文件上传、权限、数据删除等高风险能力？
5. 是否有包管理器或运行时版本偏好？
6. 测试等级是什么：MVP 轻量、标准单测，还是端到端测试？

然后给出 2-3 套技术栈方案，说明取舍，并给出推荐。

用户选择后，只写入已确认的决策和开放事项：

```text
- user-approved: 本项目使用 Next.js + TypeScript。
- user-approved: 包管理器使用 pnpm。
- user-approved: MVP 阶段使用 lint、typecheck 和聚焦单测，暂缓 e2e。
- unresolved-risk: 项目脚手架尚未创建。Impact: 固定命令还无法验证。Next: 脚手架生成后再次运行 Bootstrap 审计。
```

项目脚手架生成后，再走“已有项目审计”路径，根据真实文件补充 `project-info.md` 和 `project-commands.md`。
