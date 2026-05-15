# AGENTS.md — ZeroSpec AI Navigation Guide

> **For AI agents contributing to ZeroSpec itself.**
> This file provides the minimal pre-coding context needed before editing files in this repo.
> For methodology details, see [GUIDE.md](GUIDE.md). For daily usage patterns, see [DAILY-USAGE.md](DAILY-USAGE.md).

## Project Summary

**ZeroSpec** — Zero-dependency, pure-Markdown AI readability framework (Layer 0).
Provides AI coding agents with project context (architecture rules, module navigation, source of truth) before they start editing files.

- **Version**: See `README.md` header; release notes in [CHANGELOG.md](CHANGELOG.md)
- **Format**: Plain Markdown only — no runtime, no CLI, no platform lock-in
- **Standard**: Builds on open [AGENTS.md](https://agents.md/) format
- **Version source of truth**: `README.md` header (`**Version**: vX.Y.Z`)

---

## Quick Constraints

1. **Do NOT create standalone new files** for governance rules (except core entry files such as `AGENTS.md` and GitHub community health files such as `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`) — integrate updates into existing docs (`GUIDE.md`, `DAILY-USAGE.md`, etc.)
2. **Do NOT copy Prompt Pack content** into `templates/prompts/*.prompt.md` — use `#file:` references only
3. **Do NOT bind features to a single AI platform** — ZeroSpec core must remain tool-agnostic (Copilot, Cursor, Claude Code, Windsurf, JetBrains)
4. **Always sync zh-TW counterparts** in the same PR as EN changes (README, GUIDE, DAILY-USAGE, anti-patterns, community docs, and examples when paired files exist)
5. **Run verification before every PR** (`bash scripts/verify-zerospec.sh` or `pwsh -File scripts\verify-zerospec.ps1`) — FAIL blocks merge
6. **Keep EN docs English-only** except language-switch links, quoted examples, or intentional multilingual guidance

---

## Domain-to-Code Map

| Domain                            | Primary Files                                                                                                                              |
| --------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Bootstrap / onboarding            | `prompts/INIT-SCAN.md`, `prompts/INIT-BUILD.md`                                                                                            |
| Continuous maintenance            | `prompts/UPDATE.md`, `prompts/AUDIT.md`, `prompts/DRIFT.md`                                                                                |
| Document types (SPEC/ADR/SA)      | `prompts/SPEC.md`, `prompts/ADR.md`, `prompts/SA.md`                                                                                       |
| Methodology & design rules        | `GUIDE.md` + `GUIDE.zh-TW.md`                                                                                                              |
| Daily usage & IDE config          | `DAILY-USAGE.md` + `DAILY-USAGE.zh-TW.md`                                                                                                  |
| Anti-pattern catalog              | `anti-patterns.md` + `anti-patterns.zh-TW.md`                                                                                              |
| Document templates                | `templates/ADR-TEMPLATE.md`, `SPEC-TEMPLATE.md`, `SA-TEMPLATE.md`, `DOCS-README-TEMPLATE.md`                                               |
| VS Code adapter (optional)        | `templates/prompts/*.prompt.md`                                                                                                            |
| Platform pointer setup (optional) | `templates/pointers/` — `copilot-instructions.md`, `CLAUDE.md`, `.cursorrules`, `.windsurfrules`                                           |
| OSS community health              | `CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`                                                               |
| Verification & CI                 | `scripts/verify-zerospec.sh`, `scripts/verify-zerospec.ps1`, `.github/workflows/verify-zerospec.yml`                                       |
| Real-world examples               | `examples/minimal-day1/`, `examples/dotnet-dual-api/`, `examples/java-library/`, `examples/python-package/`, `examples/react-nx-monorepo/` |

---

## Code Generation Rules

- **No new runtime dependencies** — all features must be achievable in plain Markdown
- **Prompt Packs** (`prompts/`) must maintain `---BEGIN PROMPT---` / `---END PROMPT---` delimiters and ` ``` ` fencing — CI asserts these
- **`templates/prompts/` adapter files** must use `#file:` reference, not inline prompt content; each file ≤ 9 lines
- **AGENTS.md bloat limit**: 300 lines / ~4K tokens — applies to `examples/*/AGENTS.md`; verify scripts emit WARNING if exceeded
- **PR scope**: one concern per PR — do not mix `prompts/` edits with `scripts/` changes
- **Versioning**: update `README.md` version header and add `CHANGELOG.md` entry for every released change; `GUIDE.md` internal version tag is separate

---

## Common Commands

| Command                                                                 | Description                                 |
| ----------------------------------------------------------------------- | ------------------------------------------- |
| `bash scripts/verify-zerospec.sh`                                       | macOS/Linux: run all assertions (PASS/FAIL) |
| `pwsh -File scripts\verify-zerospec.ps1`                                | Windows: same as above                      |
| `pwsh -File scripts\verify-zerospec.ps1 2>&1 \| Select-Object -Last 10` | Quick summary view                          |

---

## Docs Maintenance Reminders

- **PR adds/changes a Prompt Pack** → update `CHANGELOG.md` + check `DAILY-USAGE.md` for affected scenarios
- **PR adds a new `templates/` file** → update `README.md` Repo Structure tree + `README.zh-TW.md`
- **PR changes community health files** (`CODE_OF_CONDUCT.md`, `SECURITY.md`, `SUPPORT.md`, `.github/ISSUE_TEMPLATE/`) → sync README repo structure / contributor entry points in the same PR
- **PR changes `scripts/`** → run verify script locally first; ensure Windows `.ps1` and shell `.sh` are in sync
- **PR changes methodology** (e.g., bloat thresholds, GUIDE §3.4) → sync `GUIDE.zh-TW.md` in the same PR
- **Any EN change** → sync zh-TW counterpart in the same commit
