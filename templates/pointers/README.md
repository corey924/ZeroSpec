# Pointer Templates

After generating `AGENTS.md` with ZeroSpec, use the matching item below to connect it to your AI platform.

| Platform                 | Copy this file            | Destination in your project                                                      |
| ------------------------ | ------------------------- | -------------------------------------------------------------------------------- |
| GitHub Copilot (VS Code) | `copilot-instructions.md` | `.github/copilot-instructions.md`                                                |
| Claude Code              | `CLAUDE.md`               | `CLAUDE.md` (repo root)                                                          |
| Cursor                   | *(none)*                  | Use `AGENTS.md`; add `.cursor/rules/*.mdc` only for scoped Cursor-specific rules |
| Devin Desktop / Windsurf | *(none)*                  | Use `AGENTS.md`; add `.devin/rules/*.md` only for scoped platform rules          |
| JetBrains AI Assistant   | *(none)*                  | Use the selected agent's supported `AGENTS.md` or `CLAUDE.md` directly           |

> Cursor and Devin Desktop / Windsurf read `AGENTS.md` natively. Their current scoped-rule formats are preferable to legacy root pointer files.

**Rule**: Never copy `AGENTS.md` content into these files. Reference or import it only.

Source: [DAILY-USAGE.md §2](../../DAILY-USAGE.md#2-ide-and-agent-platform-configuration)
