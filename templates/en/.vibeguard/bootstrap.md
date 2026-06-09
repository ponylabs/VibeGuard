# Bootstrap

Use this file after installing VibeGuard, or when `.vibeguard/state/` is mostly empty or clearly outdated.

Bootstrap is not the normal development workflow. Its job is to help the AI understand the current project before regular tasks begin.

## Goal

Choose one path:

- Existing project: audit the current project and propose state updates.
- New project: guide stack selection before writing project decisions.

Do not change product code, install dependencies, rewrite tests, or create a new architecture during Bootstrap unless the user explicitly asks for that as a separate task.

## Principles

- Observe project reality before writing state.
- Missing information is not permission to invent it.
- Ask when a missing item blocks safe future work.
- Propose state changes first; write them only after user confirmation.
- Write only evidence-backed information into `.vibeguard/state/`.
- Use `unresolved-risk` for important gaps that are not closed yet.

## Existing Project Audit

Scan the project in priority order. Keep the audit focused. Do not read every file.

### P0 Required Scan

These items affect whether AI can safely work in the project.

| Area | Look For | If Missing |
| --- | --- | --- |
| Project type | README, root files, directory names, framework config | Ask the user to confirm the project type. Do not guess. |
| Tech stack and runtime | `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `pom.xml`, `.python-version`, `.nvmrc`, `Dockerfile` | Ask the user to choose language, framework, and runtime version. |
| Package manager and lockfile | `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `uv.lock`, `poetry.lock`, `requirements.txt`, `go.sum`, `Cargo.lock` | Mark as Blocker if dependencies will be changed soon. Ask which package manager should be used. |
| Fixed commands | package scripts, `Makefile`, `justfile`, `Taskfile.yml`, README, CI | Recommend fixed install, dev, static check, test, and build commands. |
| Key directories | `src/`, `app/`, `pages/`, `server/`, `tests/`, `docs/`, `packages/`, `apps/` | Recommend a small directory boundary before feature work spreads. |
| Test status | test directories, test config, test scripts, CI test jobs | Recommend the smallest useful test strategy. Do not introduce a new framework without approval. |
| Static checks | ESLint, Prettier, TypeScript, Biome, Ruff, Mypy, Black, Clippy, CI checks | Recommend minimal static checks for the observed stack. |
| Environment and secrets | `.env.example`, README env docs, Docker Compose, devcontainer, CI secret references | Recommend documenting required env vars. Never inspect or record secret values. |

### P1 Recommended Scan

These items reduce future drift but should not block Bootstrap.

| Area | Look For | If Missing |
| --- | --- | --- |
| CI and release flow | `.github/workflows/`, GitLab CI, Dockerfile, deploy docs | Recommend minimal CI: install, static check, test, build. |
| Module boundaries | directory names, local READMEs, workspace config, import patterns | Record only observed boundaries. Put unclear boundaries in `open-items.md`. |
| Existing decisions | README, ADRs, docs, accepted implementation patterns | Ask the user to confirm important decisions before writing them. |
| High-risk areas | auth, permissions, payments, migrations, data deletion, security, infra | Mark as Governed Path areas when clearly present. |

### P2 Optional Scan

These can be added later:

- documentation completeness
- performance benchmarks
- end-to-end test coverage
- Storybook or component documentation
- observability
- release versioning
- code ownership

## Missing Item Levels

Classify gaps like this:

- Blocker: safe future work needs a human decision first.
- Recommendation: useful to fix soon, but normal development can continue.
- Optional: can wait until the project needs it.

Missing information does not automatically mean the AI should create files or install tools.

## Existing Project Output

Before writing state, output this draft:

```text
Project Audit Result

Found:
- ...

Missing:
- ...

Suggested:
- ...

State Draft:
- project-info.md: ...
- project-commands.md: ...
- project-decisions.md: ...
- open-items.md: ...

Need Confirmation:
- ...
```

After the user confirms, update only the relevant files under `.vibeguard/state/`.

## New Project Stack Selection

For a new project, there may be little project reality to scan. Do not fill `project-info.md` with guesses.

Ask only the decisions needed to start:

1. What type of project is this?
2. What language or framework does the user prefer?
3. Where will it run or deploy?
4. Does it need high-risk capabilities such as database migrations, authentication, payments, file uploads, permissions, or data deletion?
5. Is there a preferred package manager or runtime version?
6. What testing level is expected: MVP light, standard unit tests, or end-to-end tests?

Then propose 2-3 stack options with tradeoffs and a recommendation.

After the user chooses, write only confirmed decisions and open items:

```text
- user-approved: This project will use Next.js with TypeScript.
- user-approved: The package manager will be pnpm.
- user-approved: MVP phase will use lint, typecheck, and focused unit tests; e2e is deferred.
- unresolved-risk: The project scaffold does not exist yet. Impact: fixed commands cannot be verified. Next: run Bootstrap audit again after scaffolding.
```

After the project is scaffolded, run the Existing Project Audit path to fill `project-info.md` and `project-commands.md` from real files.
