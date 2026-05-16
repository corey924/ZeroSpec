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

> "Run ZeroSpec init-scan on this project"

Claude should route to `prompts/INIT-SCAN.md` and apply the built-in Self-Review before output.
Use `"Run ZeroSpec audit on this project"` only after the target project already has `AGENTS.md`.

## Phase 0 Verification (Claude Code Only)

After installing the Router Skill, verify these 3 assumptions in Claude Code:

**Test 1 — Sub-file reading:** Ask Claude:
> "Run ZeroSpec init-scan on this project"

Claude should read `prompts/INIT-SCAN.md` and produce a structured scan report.
If Claude says it cannot find the file, check that `~/.claude/skills/zerospec/prompts/INIT-SCAN.md`
exists after installation.

**Test 2 — Trigger accuracy:** Ask Claude about a general coding question.
Claude should answer normally and should not route the request through ZeroSpec.
If it does, tighten the description in `SKILL.md`.

**Test 3 — Self-Review follow-through:** After the scan output, check that:
- Scan findings cite real files or directories
- Greenfield / Brownfield judgment is backed by evidence
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
- `skills/zerospec/prompts/*.md` are generated payload copies; CI link checks exclude them and validate links in canonical `prompts/*.md` instead.
- Codex CLI and generic CLI tools do not need this skill package; paste Prompt Packs directly.

## Link-checking Decision

`skills/zerospec/prompts/*.md` are byte-for-byte copies of `prompts/*.md`. Some prompt wrappers
contain source-relative links such as `../DAILY-USAGE.md`; those links are valid in the canonical
source, but not from copied skill payloads.

This is intentional:

- CI checks links in the canonical source only (`lychee --offline --exclude-path skills/zerospec/prompts`).
- Sync scripts stay as plain copies, so parity checks remain simple and catch drift.
- Copied wrapper links are human guidance, not required for routing or prompt execution.

Rejected alternatives:

| Alternative         | Reason rejected                                                          |
| ------------------- | ------------------------------------------------------------------------ |
| Absolute URLs       | Bypasses offline Lychee local-link coverage and couples docs to repo URL |
| Rewrite during sync | Breaks byte-for-byte parity and adds shell/PowerShell transform logic    |
| Bundle root docs    | Enlarges the Skill package and adds context noise                        |
| Symlinks            | Less portable across Windows, Git settings, and tool install paths       |
