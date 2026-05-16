# ZeroSpec Adapter Assets

ZeroSpec's core workflow is tool-agnostic: every agent can use the canonical Prompt Packs in
`prompts/*.md` by copy-paste, bookmark, or CLI stdin. This directory contains optional adapter
assets for tools that support a skill-style package.

## Which Path Should I Use?

| Tool / Environment            | Recommended Path                                                        |
| ----------------------------- | ----------------------------------------------------------------------- |
| GitHub Copilot (VS Code)      | Use `AGENTS.md` + optional `templates/prompts/*.prompt.md` shortcuts    |
| Codex CLI / Generic CLI       | Use `AGENTS.md` when supported; otherwise paste `prompts/*.md` directly |
| Claude Code                   | Optional: install the Router Skill in `skills/zerospec/`                |
| Cursor / Windsurf / JetBrains | Use `AGENTS.md` and paste Prompt Packs directly when needed             |

## Structure

```
skills/
└── zerospec/
    ├── SKILL.md              ← Router skill for tools that support SKILL.md packages
    └── prompts/
        ├── INIT-SCAN.md      ← Prompt sub-files (8 files, copied from /prompts/)
        ├── INIT-BUILD.md
        ├── UPDATE.md
        ├── AUDIT.md
        ├── DRIFT.md
        ├── SPEC.md
        ├── ADR.md
        └── SA.md
```

The prompt sub-files are kept in sync with `/prompts/*.md` via cross-platform sync scripts:

```bash
# macOS / Linux
bash scripts/sync-skills.sh
```

```powershell
# Windows PowerShell
pwsh -File scripts/sync-skills.ps1
```

## Optional Claude Code Install

Claude Code can load `SKILL.md` packages from `~/.claude/skills/`. Install the ZeroSpec Router Skill with the command that matches your OS:

```bash
# macOS / Linux
bash scripts/sync-skills.sh --install
```

```powershell
# Windows PowerShell
pwsh -File scripts/sync-skills.ps1 -Install
```

After installing, Claude Code users can say:

> "Run ZeroSpec audit on this project"

Claude should route to `prompts/AUDIT.md` and apply the built-in Self-Review before output.

## Phase 0 Verification (Claude Code Only)

After installing the Router Skill, verify these 3 assumptions in Claude Code:

**Test 1 — Sub-file reading:** Ask Claude:
> "Run ZeroSpec audit on this project"

Claude should read `prompts/AUDIT.md` and produce a structured audit report.
If Claude says it cannot find the file, check that `~/.claude/skills/zerospec/prompts/AUDIT.md`
exists after installation.

**Test 2 — Trigger accuracy:** Ask Claude about a general coding question.
Claude should answer normally and should not route the request through ZeroSpec.
If it does, tighten the description in `SKILL.md`.

**Test 3 — Self-Review follow-through:** After the audit output, check that:
- Score totals match dimension analysis
- Every Fix item references a scored dimension
No explicit self-review checklist should appear in the output.

## Update Prompt Sub-files

When `/prompts/*.md` changes, re-sync with the command for your OS:

```bash
# macOS / Linux
bash scripts/sync-skills.sh
```

```powershell
# Windows PowerShell
pwsh -File scripts/sync-skills.ps1
```

The Router `SKILL.md` itself is **not** overwritten by the sync scripts — edit it directly in
`skills/zerospec/SKILL.md` when the Route Table or Self-Review Matrix needs updating.

## Compatibility Notes

- `prompts/*.md` is the canonical, cross-tool source for all Prompt Packs.
- `templates/prompts/*.prompt.md` is the optional VS Code / Copilot shortcut layer.
- `skills/zerospec/SKILL.md` is currently verified for Claude Code-style skill loading.
- Codex CLI and generic CLI tools do not need this skill package; paste Prompt Packs directly.
