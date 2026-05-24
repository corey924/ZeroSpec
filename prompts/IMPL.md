# ZeroSpec — IMPL Prompt Pack

> Use when a **complex coding task is expected to touch multiple modules or affect multiple SPECs**. Paste the Prompt below to give the AI agent explicit guardrails for implementation and SPEC synchronization.

---

## Trigger Conditions

- Coding task expected to touch **3 or more Controllers** (or equivalent route/handler files)
- Coding task expected to affect **2 or more SPEC documents**
- Cross-module feature involving both API changes and business rule changes
- Major refactor that changes external behavior across several endpoints

For simpler tasks (single controller, single SPEC), using the Post-Edit Self-Check section in your project's `AGENTS.md` is sufficient — this Prompt Pack is not required.

---

## Quick Self-Assessment

Before pasting the prompt, answer these questions. If **any** answer is yes, this Prompt Pack applies:

1. Will this task touch **3 or more Controllers** (or equivalent handler files)?
2. Will this task change interfaces that **2 or more SPEC files** describe?
3. Does this task cross **module boundaries** (e.g., API host + service layer + DB schema all change)?
4. Is the expected changeset large enough that you **cannot hold all affected docs in memory** simultaneously?

If all answers are no, the Post-Edit Self-Check section in your project's `AGENTS.md` is enough.

---

## How to Use

1. Describe the coding task in your own words above or below the prompt
2. Copy the Prompt below and paste it into your AI Agent
3. Review the Docs Impact block the agent outputs at the end of each response

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start:
>
> ```
> Target project: my-backend
> Task: add Group Management API (3 controllers, affects SPEC-002 and SPEC-003)
> ```
>
> Or open any file within the target project (Active File anchoring).
> If a task path falls outside the target project scope, stop and report — do not modify other projects.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Implement the described coding task with explicit SPEC synchronization.

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.
> To override, prepend `Respond in {locale}` (e.g. `Respond in zh-TW`) before pasting this prompt.

## Prerequisites

- `AGENTS.md` exists (if not, run INIT-SCAN + INIT-BUILD first)
- The task description is provided above or below this prompt

## Steps

### Step 1: Understand Scope

1. Read `AGENTS.md` fully — note Quick Constraints, Code-to-Docs Map, and Post-Edit Self-Check sections.
2. List the Controllers / Services / DB models expected to change.
3. For each changed area, identify the corresponding SPEC file(s):
   - Prefer the Code-to-Docs Map in `AGENTS.md`.
   - If no map exists, read `docs/spec/README.md` (if present), then review relevant `docs/spec/SPEC-*.md` overview or scope sections before mapping.
   - If the mapping is still uncertain, state the ambiguity explicitly and ask before coding — do not guess from filename alone.
4. Before coding, output a brief plan: changed code areas → affected SPEC files.

### Step 2: Implement

Apply code changes according to the task description and Quick Constraints in `AGENTS.md`.

- Follow all rules in `## Quick Constraints` without exception. The first constraint (SPEC assessment) applies at the end of this task.
- If you encounter an ambiguity that could affect SPEC accuracy, pause and ask — do not silently choose.

### Step 3: SPEC Synchronization

For every SPEC identified in Step 1:

1. **New endpoint** → Add a row to `## Interface Definitions` with Method, Path, Description, Request, Response, Permission, and Error codes.
2. **Modified request/response schema** → Update the relevant DTO or parameter description; add a Changelog entry: `YYYY-MM-DD Change: {summary}`.
3. **Permission change** → Update the `Permission` column and add a Changelog entry.
4. **Business rule change** → Update `## Business Rules`; add Changelog entry.
5. **Behavioral bug fix** → Use the Bugfix Variant format in Changelog: `YYYY-MM-DD Bugfix: {summary} (Before: … → After: …)`.
6. If no SPEC update is needed for a file, state the reason explicitly.

### Step 4: Post-Edit Self-Check

After all code and SPEC changes are complete:

1. List every changed file.
2. Cross-reference the Code-to-Docs Map (or your Step 1 mapping) for each changed file.
3. State `Update needed` or `No update needed (reason)` for every candidate document.
4. Confirm all SPEC files identified in Step 1 have been updated or explicitly dismissed.
5. Run any applicable build/test command and confirm no regressions.

## Output Requirements

**Forcing Function**: Every response that contains code changes MUST end with a `### Docs Impact` block:

```markdown
### Docs Impact
| Changed path | Affected SPEC | Status | Notes |
| --- | --- | --- | --- |
| {path} | {SPEC file or "none"} | Updated / No update needed | {reason if no update} |
```

---END PROMPT---
````

---

## Relationship to Other Prompts

| Prompt | When to use |
| --- | --- |
| **IMPL** (this file) | Complex coding task touching 3+ Controllers/handlers or 2+ SPECs — use proactively |
| **SPEC** | After any single API change — generate or update one SPEC document |
| **DRIFT** | Periodic audit — verify existing SPECs still match code, read-only |
| **UPDATE** | Periodic sync — bring `AGENTS.md` up to date with code evolution |
| **AUDIT** | Deeper health check — stale paths, missing domains, bloat detection |
