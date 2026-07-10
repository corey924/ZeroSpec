# AGENTS.md — ZeroSpec AI Navigation Guide

> **For AI agents contributing to ZeroSpec itself.**
> This file provides the minimal pre-coding context needed before editing files in this repo.
> For methodology details, see [GUIDE.md](GUIDE.md). For daily usage patterns, see [DAILY-USAGE.md](DAILY-USAGE.md).

## Project Summary

**ZeroSpec** — Zero-dependency, pure-Markdown AI readability framework (Layer 0).
Provides AI coding agents with project context (architecture rules, module navigation, source of truth) before they start editing files.

- **Version**: See `README.md` header; release notes in [CHANGELOG.md](CHANGELOG.md)
- **Format**: Plain Markdown only — no runtime service or dedicated execution engine, no platform lock-in
- **Standard**: Builds on open [AGENTS.md](https://agents.md/) format
- **Version source of truth**: `README.md` header (`**Version**: vX.Y.Z`)

---

## Quick Constraints

1. **Before touching any code or docs, assess whether a documented contract is affected.** Follow the project's Contract Ownership rule: update an existing in-scope SPEC, or create one only for a high-risk interface change (cross-system or multi-consumer behavior, complex rules/state, permission/security, or compatibility).
2. **Do NOT create standalone new files** for governance rules (except core entry files such as `AGENTS.md` and GitHub community health files such as `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`) — integrate updates into existing docs (`GUIDE.md`, `DAILY-USAGE.md`, etc.)
3. **Do NOT copy Prompt Pack content** into `templates/prompts/*.prompt.md` — use relative Markdown links to the canonical prompt only
4. **Do NOT bind features to a single AI platform** — ZeroSpec core must remain tool-agnostic (Copilot, Cursor, Codex CLI, Claude Code, Windsurf, JetBrains, generic CLI)
5. **Always sync zh-TW counterparts** in the same PR as EN changes (README, GUIDE, DAILY-USAGE, anti-patterns, community docs, and examples when paired files exist)
6. **Run verification before every PR** (`bash scripts/verify-zerospec.sh` or `pwsh -File scripts/verify-zerospec.ps1`) — FAIL blocks merge
7. **Keep EN docs English-only** — place zh-TW content only in `*.zh-TW.md` files

---

## Domain-to-Code Map

| Domain                            | Primary Files                                                                                                                               |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Bootstrap / onboarding            | `prompts/INIT-SCAN.md`, `prompts/INIT-BUILD.md`                                                                                             |
| Continuous maintenance            | `prompts/UPDATE.md`, `prompts/AUDIT.md`, `prompts/DRIFT.md`                                                                                 |
| Document types (SPEC/ADR/SA)      | `prompts/SPEC.md`, `prompts/ADR.md`, `prompts/SA.md`                                                                                        |
| Methodology & design rules        | `GUIDE.md` + `GUIDE.zh-TW.md`                                                                                                               |
| Daily usage & IDE config          | `DAILY-USAGE.md` + `DAILY-USAGE.zh-TW.md`                                                                                                   |
| Anti-pattern catalog              | `anti-patterns.md` + `anti-patterns.zh-TW.md`                                                                                               |
| Document templates                | `templates/ADR-TEMPLATE.md`, `SPEC-TEMPLATE.md`, `SA-TEMPLATE.md`, `DOCS-README-TEMPLATE.md`                                                |
| VS Code adapter (optional)        | `templates/prompts/*.prompt.md`                                                                                                             |
| Skill-style adapter (optional)    | `skills/zerospec/SKILL.md`, `skills/zerospec/prompts/` — sync via `scripts/sync-skills.sh` / `scripts/sync-skills.ps1`                      |
| Platform pointer setup (optional) | `templates/pointers/` — thin Copilot and Claude entry files; other agents can use `AGENTS.md` directly or their native scoped-rules feature |
| OSS community health              | `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`                                                                |
| Verification & CI                 | `scripts/verify-zerospec.sh`, `scripts/verify-zerospec.ps1`, `.github/workflows/verify-zerospec.yml`                                        |
| Real-world examples               | `examples/minimal-day1/`, `examples/dotnet-dual-api/`, `examples/java-library/`, `examples/python-package/`, `examples/react-nx-monorepo/`  |

---

## Code Generation Rules

- **No new runtime dependencies** — all features must be achievable in plain Markdown
- **Prompt Packs** (`prompts/`) must maintain `---BEGIN PROMPT---` / `---END PROMPT---` delimiters and ` ``` ` fencing — CI asserts these
- **`templates/prompts/` adapter files** must use a relative Markdown link, not inline prompt content; each file ≤ 9 lines
- **`skills/zerospec/prompts/` are copies of `prompts/`** — kept in sync by `scripts/sync-skills.sh` / `scripts/sync-skills.ps1`; do NOT edit sub-files directly, edit the source in `prompts/` and re-sync
- **AGENTS.md bloat check**: review files that exceed 200 lines; platform context limits differ, so keep only rules needed on most tasks
- **PR scope**: avoid unrelated concerns in one PR; include required prompt-copy or validation changes when a Prompt Pack contract changes
- **Versioning**: update `README.md` version header and add `CHANGELOG.md` entry for every released change; `README.md` is the only version source

---

## Common Commands

| Command                                                                 | Description                                 |
| ----------------------------------------------------------------------- | ------------------------------------------- |
| `bash scripts/verify-zerospec.sh`                                       | macOS/Linux: run all assertions (PASS/FAIL) |
| `pwsh -File scripts/verify-zerospec.ps1`                                | Windows: same as above                      |
| `pwsh -File scripts/verify-zerospec.ps1 2>&1 \| Select-Object -Last 10` | Quick summary view                          |
| `bash scripts/sync-skills.sh`                                           | macOS/Linux: sync prompts/ → skills/        |
| `bash scripts/sync-skills.sh --install`                                 | macOS/Linux: sync + install skill package   |
| `bash scripts/sync-skills.sh --check`                                   | macOS/Linux: check skills/ drift            |
| `pwsh -File scripts/sync-skills.ps1`                                    | Windows: sync prompts/ → skills/            |
| `pwsh -File scripts/sync-skills.ps1 -Install`                           | Windows: sync + install skill package       |
| `pwsh -File scripts/sync-skills.ps1 -Check`                             | Windows: check skills/ drift                |

---

## Docs Maintenance Reminders

- **PR adds/changes a Prompt Pack** — update `CHANGELOG.md` + run `bash scripts/sync-skills.sh` or `pwsh -File scripts/sync-skills.ps1` to keep `skills/zerospec/prompts/` in sync + update `skills/zerospec/SKILL.md` Route Table if a new pack is added + check `DAILY-USAGE.md` for affected scenarios
- **PR adds a new `templates/` file** → update `README.md` Repo Structure tree + `README.zh-TW.md`
- **PR changes community health files** (`CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`) → sync README repo structure / contributor entry points in the same PR
- **PR changes skill adapter or link checks** → keep Lychee excluding `skills/zerospec/prompts/`; canonical `prompts/*.md` links are still checked and copy parity is verified by scripts
- **PR changes `scripts/`** → run verify script locally first; ensure Windows `.ps1` and shell `.sh` are in sync
- **PR changes methodology** (e.g., bloat thresholds, GUIDE §3.4) → sync `GUIDE.zh-TW.md` in the same PR
- **Any EN change** → sync zh-TW counterpart in the same commit

---

## Code-to-Docs Map

Use this map after every code or documentation edit. List changed paths, map them to the owning docs below, then update or explicitly mark each candidate as "No update needed" with a reason.

| Changed Path                                                                            | Docs / Artifacts to Check                                                                            | Notes                                                                                                                   |
| --------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| `prompts/*.md`                                                                          | `CHANGELOG.md`, `skills/zerospec/prompts/`, `skills/zerospec/SKILL.md`, `DAILY-USAGE.md`, `GUIDE.md` | Sync skill prompt copies after prompt changes; update route tables and user docs only when behavior or scenarios change |
| `templates/*.md`, `templates/prompts/*.prompt.md`, `templates/pointers/*`               | `README.md`, `README.zh-TW.md`, `DAILY-USAGE.md`, `DAILY-USAGE.zh-TW.md`                             | Keep repo structure, setup, and adapter guidance accurate                                                               |
| `scripts/*.sh`, `scripts/*.ps1`                                                         | Matching shell/PowerShell script, `README.md`, `README.zh-TW.md`, `DAILY-USAGE.md`, `CHANGELOG.md`   | Keep cross-platform behavior in sync; update docs only for user-facing command or behavior changes                      |
| `skills/zerospec/**`                                                                    | `skills/README.md`, `README.md`, `README.zh-TW.md`, `CHANGELOG.md`                                   | Generated prompt copies must match canonical `prompts/*.md`                                                             |
| `.github/workflows/**`, `.github/ISSUE_TEMPLATE/**`, `.github/pull_request_template.md` | `README.md`, `README.zh-TW.md`, `CONTRIBUTING.md`, `CONTRIBUTING.zh-TW.md`, `CHANGELOG.md`           | Update contributor entry points when workflow or template expectations change                                           |
| `GUIDE.md`, `DAILY-USAGE.md`, `anti-patterns.md`, community docs                        | Matching `*.zh-TW.md`, `README.md`, `CHANGELOG.md`                                                   | English docs are primary; zh-TW counterpart must stay synchronized                                                      |
| `examples/**/AGENTS.md`, `examples/**/docs/**/*.md`, `examples/**/README.md`            | Matching zh-TW example files, verify scripts                                                         | Example docs and zh-TW indexes must stay consistent                                                                     |
| `CHANGELOG.md` release entry                                                            | `README.md`, `README.zh-TW.md`                                                                       | Update version headers for released version entries                                                                     |

## Post-Edit Self-Check

Before declaring work complete:

1. List changed files from the current diff.
2. Cross-reference every changed file with the Code-to-Docs Map.
3. For each candidate doc or artifact, state `Update needed` or `No update needed` with a reason.
4. Run the relevant verification command (`bash scripts/verify-zerospec.sh` or `pwsh -File scripts/verify-zerospec.ps1`) when ZeroSpec files changed.
5. If prompt files changed, run the relevant sync script and verify prompt-copy parity.
