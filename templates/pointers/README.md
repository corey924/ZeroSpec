# Pointer Templates

After generating `AGENTS.md` with ZeroSpec, use the matching item below to connect it to your AI platform.

| Platform | Copy this file | Destination in your project |
|---|---|---|
| GitHub Copilot (VS Code) | `copilot-instructions.md` | `.github/copilot-instructions.md` |
| Claude Code | `CLAUDE.md` | `CLAUDE.md` (repo root) |
| Cursor | `.cursorrules` | `.cursorrules` (repo root) — optional |
| Windsurf | `.windsurfrules` | `.windsurfrules` (repo root) — optional |
| JetBrains AI Assistant | *(none)* | Use `AGENTS.md` directly (enable Attach project files) |

> Cursor and Windsurf read `AGENTS.md` natively (auto-read).
> Their pointer files are **optional** — use only when you need platform-specific overrides.

**Rule**: Never copy `AGENTS.md` content into these files. Reference or import it only.

Source: [DAILY-USAGE.md §2](../../DAILY-USAGE.md#2-ide-and-agent-platform-configuration)
