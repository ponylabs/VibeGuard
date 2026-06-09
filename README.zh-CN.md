# VibeGuard

[English](README.md)

轻量级 vibe coding / AI-assisted development 治理层。

VibeGuard 为 Codex、Claude Code、Cursor 等 AI 编码工具提供一套可安装的项目规则与状态模板，帮助项目在快速迭代时控制范围、依赖、测试、验证和项目记忆。

## 仓库结构

```text
templates/
  en/.vibeguard/  # 英文治理模板，默认安装
  zh/.vibeguard/  # 中文治理模板
install/          # 面向不同 AI 工具的安装脚本
tests/            # 安装器测试
```

VibeGuard 仓库本身不在根目录使用模板。安装器会把 `templates/<lang>/.vibeguard/` 复制到目标项目根目录，生成 `.vibeguard/`。

## 安装

默认安装英文模板：

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

安装中文模板：

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

## 首次使用

安装后，让 AI 先初始化项目状态：

```text
读取 `.vibeguard/README.md` 并运行 VibeGuard Bootstrap。
如果这是已有项目，请审计当前项目并提出 state 更新草案。
如果这是新项目，请先引导我完成技术栈选型，再写入 state。
```

Bootstrap 是一次性的项目体检或技术栈选型流程。它会把有证据支撑的项目事实、固定命令、人类批准的决策和开放风险记录到 `.vibeguard/state/`。

## 发布

发布通过版本 tag 触发，并且只有自动验证通过后才创建 GitHub Release。

使用语义化版本 tag：

```sh
git tag v0.1.0
git push origin v0.1.0
```

推送 `v*` tag 后会运行 release workflow。该 workflow 会检查 shell 语法、运行安装器测试，然后创建带自动生成说明的 GitHub Release。

用户可以通过 `--version` 安装指定 release：

```sh
curl -fsSL https://raw.githubusercontent.com/ponylabs/VibeGuard/main/install/codex.sh | sh -s -- --version v0.1.0
```
