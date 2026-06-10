<p align="center">
  <img src="docs/assets/vibeguard-logo.svg" alt="VibeGuard logo" width="340">
</p>

<h1 align="center">VibeGuard</h1>

<p align="center">
  <strong>轻量级 vibe coding / AI-assisted development 治理层。</strong>
</p>

<p align="center">
  <a href="README.md">English</a>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/license-MIT-2e7d5b.svg"></a>
  <img alt="Install: curl pipe sh" src="https://img.shields.io/badge/install-curl%20%7C%20sh-11a683.svg">
  <img alt="Installers: Codex, Claude Code, Cursor" src="https://img.shields.io/badge/installers-Codex%20%7C%20Claude%20Code%20%7C%20Cursor-4f79e8.svg">
  <img alt="Templates: English and Chinese" src="https://img.shields.io/badge/templates-en%20%7C%20zh-8a63d2.svg">
</p>

<p align="center">
  <img src="docs/assets/vibeguard-banner.zh-CN.svg" alt="VibeGuard 横幅" width="100%">
</p>

VibeGuard 会把一个轻量的 `.vibeguard/` 治理工作区安装到你的项目里，并为 Codex、Claude Code、Cursor 等 AI 编码工具写入一段简短入口说明。

```text
安装 VibeGuard -> 初始化项目状态 -> 让 AI 辅助变更保持有边界、可验证、可记忆
```

## 为什么用它

VibeGuard 帮助快速迭代的项目让 AI 辅助变更始终围绕：

- 🧭 清晰的变更边界
- 🧰 克制的依赖和工具链策略
- ✅ 明确的测试与验证要求
- 🧠 有证据支撑的项目记忆
- 📌 已知风险和后续事项

它刻意保持轻量：不向你的项目新增运行时依赖，不引入新框架，也不需要启动额外服务。

## 快速开始

在你想治理的项目根目录运行一个安装器。以下命令默认安装英文模板。

Codex:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh
```

Claude Code:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/claude.sh | sh
```

Cursor:

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/cursor.sh | sh
```

全部支持的工具：

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/all.sh | sh
```

然后让 AI 初始化项目状态：

```text
读取 `.vibeguard/README.md` 并运行 VibeGuard Bootstrap。
如果这是已有项目，请审计当前项目并提出 state 更新草案。
如果这是新项目，请先引导我完成技术栈选型，再写入 state。
```

## 安装参数

任意安装器都可以安装中文模板：

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --lang zh
```

可用参数：

```text
--lang <en|zh>   安装模板语言，默认 en
--version <ref>  从指定分支或 tag 安装，默认 main
--force          替换已有 .vibeguard
--dry-run        只展示计划，不修改文件
--yes            跳过确认
--help           查看帮助
```

运行要求：POSIX `sh` 以及安装器使用的常见 Unix 工具，包括 `curl`、`tar`、`mktemp`、`cp`、`rm`、`mkdir`、`grep`、`sed`、`awk`、`dirname` 和 `find`。

## 安装内容

每个安装器都会把对应语言的治理模板复制到当前项目：

```text
.vibeguard/
  README.md       # AI assistant 入口
  bootstrap.md    # 首次项目体检或技术栈选型流程
  bin/            # 可选的项目本地 Python 辅助脚本
  rules/          # 可复用的任务、依赖、测试和验证规则
  state/          # 项目事实、决策、命令和开放事项
```

安装器还会向对应工具的入口文件注入一个受管理的区块：

```text
install/codex.sh  -> AGENTS.md
install/claude.sh -> CLAUDE.md
install/cursor.sh -> .cursor/rules/vibeguard.mdc
install/all.sh    -> 以上全部入口
```

受管理区块使用 marker 标记，并且可以幂等更新；重复运行安装器会更新 VibeGuard 区块，不会重复追加。已有 `.vibeguard/` 默认会被保护，只有传入 `--force` 才会替换。

## 工作方式

VibeGuard 会给 AI 编码工具提供一份面向当前项目的小型操作手册：

| 部分 | 作用 |
| --- | --- |
| 🧭 `rules/` | 定义任务流程、变更边界、依赖、测试、验证和状态更新规则。 |
| 🧠 `state/` | 记录项目事实、固定命令、人类批准的决策和未解决风险。 |
| 🪄 `bootstrap.md` | 帮助已有项目或新项目初始化这些状态。 |
| 🧪 `bin/` | 可选的项目本地 Python 辅助脚本，用于 status 和 git 改动 audit 检查。 |

最终形成一个可重复的循环：读取项目规则，检查相关状态，做最小必要修改，运行正确验证，并报告剩余风险。

## 仓库结构

```text
templates/
  en/.vibeguard/  # 英文治理模板，默认安装
  zh/.vibeguard/  # 中文治理模板
install/          # 由共享模板生成的工具安装脚本
tests/            # 安装器测试
```

本仓库根目录的 `.vibeguard/` 是维护 VibeGuard 自身使用的状态目录。安装器不会复制这个目录，而是把 `templates/<lang>/.vibeguard/` 复制到目标项目根目录，生成 `.vibeguard/`。

## 许可证

[MIT](LICENSE)
