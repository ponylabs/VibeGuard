#!/usr/bin/env python3
"""Project-local VibeGuard git change audit."""

from pathlib import Path
import subprocess
from typing import List, Optional, Tuple


DEPENDENCY_FILES = {
    "package.json",
    "pyproject.toml",
    "requirements.txt",
    "requirements-dev.txt",
    "Pipfile",
    "Gemfile",
    "go.mod",
    "Cargo.toml",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
}

LOCKFILES = {
    "package-lock.json",
    "pnpm-lock.yaml",
    "yarn.lock",
    "uv.lock",
    "Pipfile.lock",
    "poetry.lock",
    "Gemfile.lock",
    "go.sum",
    "Cargo.lock",
}

ENTRY_FILES = {
    "AGENTS.md",
    "CLAUDE.md",
    ".cursor/rules/vibeguard.mdc",
}

STATE_REVIEW_PREFIXES = (
    ".github/workflows/",
    ".vibeguard/rules/",
    "install/",
    "templates/",
    "tests/",
)

STATE_REVIEW_FILES = {
    "README.md",
    "README.zh-CN.md",
    "AGENTS.md",
    "CLAUDE.md",
    "pyproject.toml",
}


def changed_files() -> Tuple[List[str], Optional[str]]:
    result = subprocess.run(
        ["git", "status", "--porcelain=v1"],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if result.returncode != 0:
        return [], result.stderr.strip() or "git status failed"

    files = []
    for line in result.stdout.splitlines():
        if not line:
            continue
        path = line[3:]
        if " -> " in path:
            path = path.split(" -> ", 1)[1]
        files.append(path)
    return sorted(set(files)), None


def classify(path: str) -> Tuple[str, str]:
    name = Path(path).name
    if name in LOCKFILES:
        return "high", "lockfile changed"
    if name in DEPENDENCY_FILES:
        return "high", "dependency manifest changed"
    if path.startswith(".vibeguard/rules/"):
        return "high", "governance rules changed"
    if path in ENTRY_FILES:
        return "medium", "AI entry file changed"
    if path.startswith("install/"):
        return "medium", "installer changed"
    if path.startswith(".github/workflows/"):
        return "medium", "CI workflow changed"
    if path.startswith(".vibeguard/state/"):
        return "low", "governance state changed"
    if path.startswith("tests/"):
        return "low", "test file changed"
    return "low", "project file changed"


def risk_rank(risk: str) -> int:
    return {"low": 0, "medium": 1, "high": 2}[risk]


def needs_state_review(files: List[str]) -> bool:
    if any(path.startswith(".vibeguard/state/") for path in files):
        return False
    for path in files:
        if path in STATE_REVIEW_FILES:
            return True
        if any(path.startswith(prefix) for prefix in STATE_REVIEW_PREFIXES):
            return True
    return False


def main() -> int:
    files, error = changed_files()
    if error:
        print("VibeGuard audit: unavailable")
        print()
        print(f"Git: {error}")
        print("Next: run this command from a git worktree, or follow .vibeguard/README.md manually.")
        return 1

    if not files:
        print("VibeGuard audit: ok")
        print()
        print("Changed files: none")
        return 0

    findings = [(path, *classify(path)) for path in files]
    highest = max((risk for _, risk, _ in findings), key=risk_rank)
    status = "attention needed" if risk_rank(highest) >= risk_rank("medium") else "ok"

    print(f"VibeGuard audit: {status}")
    print(f"Risk: {highest}")
    print()
    print("Changed files:")
    for path, risk, reason in findings:
        print(f"- {path}: {reason} ({risk})")

    if needs_state_review(files):
        print()
        print("State review: recommended")
        print("Project behavior, tooling, docs, tests, or governance changed but no state files changed.")
        print("Review .vibeguard/state/ before final delivery.")

    if risk_rank(highest) >= risk_rank("medium"):
        print()
        print("Next:")
        print("- Review .vibeguard/rules/task-flow.md for gate requirements.")
        print("- Run the project checks listed in .vibeguard/state/project-commands.md.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
