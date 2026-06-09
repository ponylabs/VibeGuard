# Project Info

记录当前项目相对稳定、后续任务会反复用到的事实。

不要记录通用规则、临时过程或可以低成本从代码中查到的小细节。

## Tech Stack

- observed-in-code: 本项目是 VibeGuard 安装器与治理模板仓库，见 README.md。
- observed-in-code: 安装器使用 POSIX sh，见 install/*.sh。
- observed-in-code: 治理规则和状态模板使用 Markdown 文件，见 templates/en/.vibeguard/ 和 templates/zh/.vibeguard/。

## Runtime And Environment

- observed-in-code: 本项目未声明 Node、Python、Go、Rust、Java 等运行时版本文件；安装器依赖系统 shell 与常见 Unix 工具，见 install/*.sh。

## Package And Tooling

- observed-in-code: 本项目没有 package manager 或依赖锁文件；没有 package.json、pyproject.toml、go.mod 或 Cargo.toml。
- observed-in-code: 安装器运行时需要 curl、tar、mktemp、cp、rm、mkdir、grep、sed、awk、dirname、find，见 install/*.sh。

## Key Directories

- observed-in-code: 面向用户的安装脚本位于 install/。
- observed-in-code: 安装器测试位于 tests/installers_test.sh。
- observed-in-code: 可安装模板位于 templates/en/.vibeguard/ 和 templates/zh/.vibeguard/，见 README.md。
- observed-in-code: 本仓库自己的治理状态位于根目录 .vibeguard/。

## Module Boundaries

- observed-in-code: 根目录 .vibeguard/ 是本仓库自身使用的治理状态；用户安装模板应继续从 templates/<lang>/.vibeguard/ 复制，见 README.md。
- observed-in-code: docs/superpowers/ 是本地设计/计划文档，不进入 GitHub，见 .gitignore。

## Project Conventions

- observed-in-code: README.md 是英文默认说明，README.zh-CN.md 是中文说明，见两个 README 文件。
- observed-in-code: 英文模板是默认安装语言，中文模板通过 --lang zh 安装，见 README.md 和 install/*.sh。
