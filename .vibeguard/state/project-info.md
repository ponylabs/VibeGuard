# Project Info

记录当前项目相对稳定、后续任务会反复用到的事实。

不要记录通用规则、临时过程或可以低成本从代码中查到的小细节。

## Tech Stack

- observed-in-code: 本项目是 VibeGuard 安装器与治理模板仓库，见 README.md。
- observed-in-code: 安装器使用 POSIX sh，见 install/*.sh。
- observed-in-code: 治理规则和状态模板使用 Markdown 文件，见 templates/en/.vibeguard/ 和 templates/zh/.vibeguard/。
- observed-in-code: 可安装模板包含项目本地 Python 标准库辅助脚本，见 templates/en/.vibeguard/bin/ 和 templates/zh/.vibeguard/bin/。

## Runtime And Environment

- observed-in-code: 本项目声明 Python >=3.12，并通过 .python-version 固定 3.12，见 pyproject.toml 和 .python-version。
- observed-in-code: 安装器依赖系统 shell 与常见 Unix 工具，见 install/*.sh。

## Package And Tooling

- user-approved: 使用 uv 管理项目 Python 环境和依赖配置，见 pyproject.toml、.python-version 和 uv.lock。
- observed-in-code: 当前 Python 依赖清单为空，见 pyproject.toml 和 uv.lock。
- observed-in-code: 本项目没有 Node、Go、Rust、Java 等依赖清单或锁文件；未发现 package.json、go.mod 或 Cargo.toml。
- observed-in-code: 安装器运行时需要 curl、tar、mktemp、cp、rm、mkdir、grep、sed、awk、dirname、find，见 install/*.sh。

## Key Directories

- observed-in-code: 面向用户的安装脚本位于 install/。
- observed-in-code: install/codex.sh、install/claude.sh、install/cursor.sh、install/all.sh 由 install/installer.template.sh 和 install/generate-installers.sh 生成。
- observed-in-code: 安装器测试位于 tests/installers_test.sh。
- observed-in-code: 可安装模板位于 templates/en/.vibeguard/ 和 templates/zh/.vibeguard/，见 README.md。
- observed-in-code: 模板内 VibeGuard 辅助脚本位于 templates/<lang>/.vibeguard/bin/。
- observed-in-code: README 视觉素材位于 docs/assets/，包含源品牌 PNG 和用于 README 展示的 logo/banner SVG。
- observed-in-code: 本仓库自己的治理状态位于根目录 .vibeguard/。

## Module Boundaries

- observed-in-code: 根目录 .vibeguard/ 是本仓库自身使用的治理状态；用户安装模板应继续从 templates/<lang>/.vibeguard/ 复制，见 README.md。
- observed-in-code: docs/superpowers/ 是本地设计/计划文档，不进入 GitHub，见 .gitignore。

## Project Conventions

- observed-in-code: README.md 是英文默认说明，README.zh-CN.md 是中文说明，见两个 README 文件。
- observed-in-code: 英文模板是默认安装语言，中文模板通过 --lang zh 安装，见 README.md 和 install/*.sh。
