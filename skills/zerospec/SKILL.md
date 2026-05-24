---
name: zerospec
description: |
  Use only for ZeroSpec documentation workflows: init-scan/init-build AGENTS.md,
  update or audit AGENTS.md, check SPEC-vs-code drift, or create ZeroSpec
  SPEC / ADR / SA documents.

  Do NOT use for application code changes, tests, debugging, generic specs,
  general architecture discussion, or generic "update" tasks unless the request
  explicitly mentions ZeroSpec, AGENTS.md, or ZeroSpec-managed docs.
---

## ZeroSpec Skill Router

This skill routes ZeroSpec documentation tasks to the correct prompt pack and applies
a built-in Self-Review Protocol after task completion.

---

## Step 1 — Identify Task

Match the user's request to one row in the Route Table:

| Task                                     | Trigger Keywords                                                                 | Prompt File                                    |
| ---------------------------------------- | -------------------------------------------------------------------------------- | ---------------------------------------------- |
| Scan a project before creating AGENTS.md | zerospec init-scan, scan project for AGENTS.md, analyze repo for ZeroSpec        | [prompts/INIT-SCAN.md](prompts/INIT-SCAN.md)   |
| Build AGENTS.md for a new project        | zerospec init-build, create AGENTS.md, initialize AGENTS.md                      | [prompts/INIT-BUILD.md](prompts/INIT-BUILD.md) |
| Update an existing AGENTS.md             | update AGENTS.md, sync ZeroSpec docs, ZeroSpec docs out of date, zerospec update | [prompts/UPDATE.md](prompts/UPDATE.md)         |
| Evaluate AGENTS.md quality               | audit AGENTS.md, zerospec audit, score AGENTS.md, grade ZeroSpec docs            | [prompts/AUDIT.md](prompts/AUDIT.md)           |
| Check SPEC vs code drift                 | ZeroSpec SPEC drift, SPEC vs code, spec stale, zerospec drift                    | [prompts/DRIFT.md](prompts/DRIFT.md)           |
| Implement complex multi-module coding with SPEC sync | zerospec impl, multi-module impl, SPEC sync while coding, coding guardrail | [prompts/IMPL.md](prompts/IMPL.md) |
| Write a SPEC document                    | write ZeroSpec SPEC, zerospec spec, ZeroSpec API interface contract              | [prompts/SPEC.md](prompts/SPEC.md)             |
| Write an ADR                             | write ZeroSpec ADR, ZeroSpec architecture decision record                        | [prompts/ADR.md](prompts/ADR.md)               |
| Write a System Analysis document         | write ZeroSpec SA, ZeroSpec system analysis document                             | [prompts/SA.md](prompts/SA.md)                 |

If the request does not match any row, ask: **"Which ZeroSpec task do you want to run?"**
and list the 9 options above.

---

## Step 2 — Execute Prompt

1. Read the matched prompt file (linked above) in full.
2. Follow its instructions against the user's project exactly as written.
3. Do not skip sections, abbreviate output, or add unrequested content.

---

## Step 3 — Self-Review Protocol

After completing the task, silently apply the matching row below.
Fix any issues before outputting the final result — do **not** show the checklist to the user.

| Task       | Self-Review Checklist                                                                                                                                         |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| init-scan  | ① Scan findings match the actual filesystem ② No key directories or config files missed ③ Greenfield/Brownfield judgment backed by concrete evidence          |
| init-build | ① Output follows ZeroSpec structure (Quick Constraints / Domain Map / Commands) ② No fabricated file paths or commands ③ Every INIT-SCAN finding is addressed |
| update     | ① Changes reflect actual code evolution ② No contradictions with existing doc content ③ No paragraph bloat (old content trimmed when new content added)       |
| audit      | ① Score totals match dimension-by-dimension analysis ② Every Fix item references a dimension ③ No over- or under-scoring                                      |
| drift      | ① Every DRIFTED verdict cites a specific file path or line ② CLEAN verdicts have no overlooked inconsistencies ③ Severity levels are justified                |
| impl       | ① Affected code areas and SPECs are identified before coding ② `### Docs Impact` appears after code-changing output ③ SPEC update/no-update reasons are explicit |
| spec       | ① All described endpoints/behaviors are covered ② No fabricated request or response fields ③ Changelog format consistent with existing SPECs                  |
| adr        | ① Options pros/cons are unbiased and complete ② No missing alternatives ③ Conclusion follows logically from the analysis                                      |
| sa         | ① System boundary matches actual architecture ② No missing module dependencies ③ No implementation details (architecture level only)                          |
