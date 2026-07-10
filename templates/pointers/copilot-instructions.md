<!-- ZeroSpec pointer — copy this file to .github/copilot-instructions.md in your project -->
<!-- RULE: Do NOT paste AGENTS.md content here. VS Code loads root AGENTS.md automatically. -->

## Project Constraints

Use `AGENTS.md` as the project source of truth for architecture rules,
module navigation, and code generation constraints. Do not duplicate it here.

## Spec-Aware Coding Discipline

- After ANY code modification, state whether `docs/spec/` needs updating based on change scope.
- If `AGENTS.md` contains a **Code-to-Docs Map** or **Post-Edit Self-Check**, follow it strictly.
- If those sections are absent, apply Contract Ownership: update an existing SPEC in scope or create one only for high-risk behavior; otherwise state why the machine contract or no narrative update is sufficient.
- **Do NOT declare a coding task complete** without stating the docs impact assessment.
- If uncertain whether a SPEC update is needed, flag the question explicitly for user decision.

## Personal Preferences

<!-- Add cross-project preferences here (language, response format, style) -->
<!-- Example: "Respond in zh-TW" | "Prefer TypeScript strict mode" | "Use functional style" -->
