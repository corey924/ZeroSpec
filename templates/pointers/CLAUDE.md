@AGENTS.md

## Spec-Aware Coding Discipline

- After ANY code modification, state whether `docs/spec/` needs updating based on change scope.
- If `AGENTS.md` contains a **Code-to-Docs Map** or **Post-Edit Self-Check**, follow it strictly.
- If those sections are absent, apply judgment: new endpoint / schema change / permission change / business rule change / behavioral bugfix → update SPEC.
- **Do NOT declare a coding task complete** without stating the docs impact assessment.
- If uncertain whether a SPEC update is needed, flag the question explicitly for user decision.
- For tasks spanning **3+ Controllers/handlers or 2+ SPECs**, map all affected `docs/spec/` files before starting. If your project has an IMPL Prompt Pack (`prompts/IMPL.md`), use it for explicit step-by-step sync.
<!-- zh-TW 提示：若 AGENTS.md 尚未含 Code-to-Docs Map 或 Post-Edit Self-Check，請執行 ZeroSpec UPDATE prompt 升級。 -->

## Claude Code Specific Notes

<!-- Add Claude Code–only rules here (e.g. Plan mode triggers, auto-compact behavior) -->
<!-- Leave empty if none -->
