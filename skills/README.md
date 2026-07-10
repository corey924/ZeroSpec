# ZeroSpec Adapter Assets

ZeroSpec's core workflow is tool-agnostic: every agent can use the canonical Prompt Packs in
`prompts/*.md` by copy-paste, bookmark, or CLI stdin. This directory contains optional adapter
assets for tools that support a skill-style package.

## Which Path Should I Use?

| Tool / Environment            | Recommended Path                                                                                                               |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| GitHub Copilot (VS Code)      | **Local**: copy/symlink this repo's `skills/zerospec/` as `.agents/skills/zerospec/` in your repo (Git-distributed)            |
| Claude Code                   | **Global**: install to `~/.claude/skills/` — see [Global Install](#global-install) below                                       |
| Codex CLI                     | **Global**: if user skills are enabled, copy to `$HOME/.agents/skills/zerospec/` — see [Global Install](#global-install) below |
| Cursor / Windsurf / JetBrains | Use `AGENTS.md` and paste Prompt Packs directly when needed                                                                    |

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

## Project-Local Install (VS Code Copilot)

For **VS Code Copilot** (GitHub Copilot), copy or symlink `skills/zerospec/` into your project as
`.agents/skills/zerospec/`. Copilot can discover and read `SKILL.md` automatically.

The easiest approach is to use the ZeroSpec repo itself as the source:

```bash
# From your project root — macOS / Linux
mkdir -p .agents/skills
mkdir -p .agents/skills/zerospec
cp -r /path/to/zerospec/skills/zerospec/. .agents/skills/zerospec/
```

```powershell
# Windows PowerShell
New-Item -ItemType Directory -Path .agents/skills -Force | Out-Null
New-Item -ItemType Directory -Path .agents/skills/zerospec -Force | Out-Null
Copy-Item -Recurse -Force /path/to/zerospec/skills/zerospec/* .agents/skills/zerospec
```

Commit the `.agents/skills/zerospec/` directory so teammates get the skill via Git.

## Global Install (Claude Code / Codex CLI)

For **Claude Code**, use the helper script that matches your OS. It installs to `~/.claude/skills/zerospec/`:

```bash
# macOS / Linux
bash scripts/sync-skills.sh --install
```

```powershell
# Windows PowerShell
pwsh -File scripts/sync-skills.ps1 -Install
```

For **Codex CLI**, if your environment supports user-level skills, copy the same package manually:

```bash
# macOS / Linux
mkdir -p "$HOME/.agents/skills/zerospec"
cp -r skills/zerospec/. "$HOME/.agents/skills/zerospec/"
```

```powershell
# Windows PowerShell
New-Item -ItemType Directory -Path (Join-Path $HOME '.agents/skills/zerospec') -Force | Out-Null
Copy-Item -Recurse -Force skills/zerospec/* (Join-Path $HOME '.agents/skills/zerospec')
```

After installing or copying, invoke by intent — for example:

> "Run ZeroSpec init-scan on this project"

The skill routes to `prompts/INIT-SCAN.md` and applies the built-in Self-Review before output.
Use `"Run ZeroSpec audit on this project"` only after the target project already has `AGENTS.md`.

## Phase 0 Verification

After installing or copying the Router Skill, verify these 3 assumptions in the tool that will use it:

**Test 1 — Sub-file reading:** Ask the agent:
> "Run ZeroSpec init-scan on this project"

The agent should read `prompts/INIT-SCAN.md` and produce a structured scan report.
If it says it cannot find the file, check the install path you chose:
`~/.claude/skills/zerospec/prompts/INIT-SCAN.md` or `$HOME/.agents/skills/zerospec/prompts/INIT-SCAN.md`.

**Test 2 — Trigger accuracy:** Ask the agent about a general coding question.
It should answer normally and should not route the request through ZeroSpec.
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
- `skills/zerospec/SKILL.md` is currently verified for Claude Code-style skill loading; Codex CLI can use the same package layout when user-level skills are enabled.
- `skills/zerospec/prompts/*.md` are generated payload copies; CI link checks exclude them and validate links in canonical `prompts/*.md` instead.
- Generic CLI tools do not need this skill package; paste Prompt Packs directly.

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
