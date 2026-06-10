#!/usr/bin/env python3
"""Project-local VibeGuard status check."""

from pathlib import Path
import sys


START_MARKER = "<!-- VIBEGUARD:START -->"
END_MARKER = "<!-- VIBEGUARD:END -->"

REQUIRED_FILES = [
    ".vibeguard/README.md",
    ".vibeguard/rules/task-flow.md",
    ".vibeguard/rules/change-area.md",
    ".vibeguard/rules/dependency-check.md",
    ".vibeguard/rules/test-plan.md",
    ".vibeguard/rules/final-check.md",
    ".vibeguard/rules/state-update.md",
    ".vibeguard/state/state-index.md",
    ".vibeguard/bin/vibeguard-status.py",
    ".vibeguard/bin/vibeguard-audit.py",
]

ENTRY_FILES = [
    "AGENTS.md",
    "CLAUDE.md",
    ".cursor/rules/vibeguard.mdc",
]


def has_managed_block(path: Path) -> bool:
    if not path.is_file():
        return False
    text = path.read_text(encoding="utf-8", errors="replace")
    return START_MARKER in text and END_MARKER in text


def main() -> int:
    root = Path.cwd()
    missing = [item for item in REQUIRED_FILES if not (root / item).is_file()]
    installed_entries = [item for item in ENTRY_FILES if has_managed_block(root / item)]

    status = "ok" if not missing and installed_entries else "attention needed"
    print(f"VibeGuard status: {status}")
    print()

    print("Core files:")
    for item in REQUIRED_FILES:
        state = "present" if (root / item).is_file() else "missing"
        print(f"- {item}: {state}")

    print()
    print("Entries:")
    for item in ENTRY_FILES:
        state = "installed" if has_managed_block(root / item) else "missing"
        print(f"- {item}: {state}")

    ci_file = root / ".github/workflows/ci.yml"
    print()
    print("Automation:")
    print(f"- CI workflow: {'present' if ci_file.is_file() else 'missing'}")
    print(f"- Python helper: available ({Path(sys.executable).name})")

    if missing or not installed_entries:
        print()
        print("Next:")
        print("- Read .vibeguard/README.md and repair missing files or entry wiring.")
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
