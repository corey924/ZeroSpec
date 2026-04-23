# ZeroSpec — INIT-BUILD Prompt Pack

> **Step 2: Generate AGENTS.md + docs/README.md.** After completing [INIT-SCAN](INIT-SCAN.md) analysis, use this Prompt to create the project's AI navigation files.

---

## Prerequisites

- Completed [`INIT-SCAN.md`](INIT-SCAN.md) analysis
- Confirmed analysis results and answered clarification questions

---

## How to Use

1. In the same conversation (or a new one), confirm the INIT-SCAN results have been accepted
2. Copy the Prompt below and paste into the Agent
3. The Agent asks C-class questions (5–8 items), each with a suggested default
4. Answer or confirm, then the Agent outputs `AGENTS.md` + `docs/README.md`
5. Review both files — if the environment supports file writing, ask the Agent to create the files

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start to prevent the AI from modifying other projects:
>
> ```
> Target project: my-backend
> Generate AGENTS.md and docs/README.md for this project.
> ```
>
> Or open any file within the target project (Active File anchoring) so the Agent prioritizes that project's context.
> If the target file path falls outside the target project scope, stop and report — do not write.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Based on the prior project analysis, create two files: `AGENTS.md` and `docs/README.md`.
Follow these four steps in strict order:

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.

## Step 1: Import SCAN Results

Read the following from the confirmed INIT-SCAN output (if in a new conversation, re-scan the project for equivalent information):

- **A-class (auto-extracted)**: Tech stack, version source of truth, common commands, directory structure, Base Namespace/Package/Alias
- **B-class (reviewed drafts)**: Docs navigation table, domain-to-code map, architecture layers, naming conventions, related projects

## Step 2: Ask C-class Questions (Team decisions only humans can answer)

Ask each question below. Provide a suggested default (prefixed with `Suggested:`) inferred from the SCAN phase, so the user can confirm or adjust:

1. **Project summary**: Describe this project's business purpose in one sentence
   > Suggested: "{inferred from SCAN}"
2. **Deployment method**: How is this project deployed?
   > Suggested: {inferred from CI/CD config or Dockerfile}
3. **Hard rules**: What architecture hard rules (Do / Don't) MUST the team follow?
   > Suggested: {inferred from layering patterns, e.g., "Controllers MUST NOT contain business logic"}
4. **Routing conventions**: Are there conventions for API routes or page paths?
   > Suggested: {inferred from existing routes}
5. **Auth / state management**: Is there a specific pattern for access control or state management?
   > Suggested: {inferred from code — mark `[unverified]` if no clear pattern}
6. **Data access rules**: Are there rules for data access or database migrations? (Skip if no database)
   > Suggested: {inferred from ORM/migration config}
7. **Docs sync triggers**: Which PR changes require docs updates?
   > Suggested: Update SPEC on any API addition or behavior change
8. **Other hard rules**: Any other team-specific hard rules? (May skip)

## Step 3: Assemble Output

Combine all content into two files:

### File 1: AGENTS.md

```markdown
# AGENTS.md — {project name} AI Navigation Guide

> This file is the primary entry point for GenAI Agents to understand the {project name} project. Read this file completely before performing any code task.

## Project Summary
{C1 answer + A-class tech stack, architecture pattern, deployment method}
{A-class Base Namespace/Package/Alias}
{A-class version source of truth declaration}

## Quick Constraints
Extract 5–8 hard rules from "Code Generation Rules" below (violations cause PR rejection or system errors). Place them here as concise bullet points.
{Top 5–8 hard rules from C3, one per line}

## Domain-to-Code Map
{B-class domain-to-code map}

## Code Generation Rules
{C3 hard rules + C4 routing conventions + C5 auth/state + C6 data access + B-class naming conventions}
(Items already in Quick Constraints may have expanded details and examples here)

## GenAI Docs Navigation
{B-class docs navigation table (intent-driven format)}

## Common Commands
{A-class auto-extracted commands — MUST include build, test, lint, and type-check categories so the Agent can self-verify after task completion. If any category does not exist, explicitly mark "Not configured" to prompt the team to set it up.}

## Related Projects
{B-class related projects (omit this section if none)}

## Docs Maintenance Reminders
{C7 docs sync trigger conditions}
- Docs governance rules: see `docs/README.md`
```

> **Length guideline**: Keep AGENTS.md within 150–300 lines. If it exceeds 300 lines, move low-frequency sections to docs/ sub-documents and reference them in the navigation table.

### File 2: docs/README.md

```markdown
# {project name} — Docs Governance Hub

> This file defines the layering rules, naming conventions, and maintenance triggers for project documentation.
> GenAI Agents MUST read this file before performing any documentation task.

## SDD Document Classification

| Category                    | Directory        | Naming Format               | Trigger                                         |
| --------------------------- | ---------------- | --------------------------- | ----------------------------------------------- |
| SA (System Analysis)        | `docs/analysis/` | `SA-{3-digit}_{desc}.md`    | Milestone or major architecture change          |
| ADR (Architecture Decision) | `docs/adr/`      | `ADR-{3-digit}_{desc}.md`   | Cross-module either/or tech decision            |
| SPEC (Interface Contract)   | `docs/spec/`     | `SPEC-{3-digit}_{desc}.md`  | API addition or behavior change (**mandatory**) |
| INFRA (Infrastructure)      | `docs/infra/`    | `INFRA-{3-digit}_{desc}.md` | Deployment topology or CI change                |

- Naming regex: `^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`

## Source of Truth

SPEC is the primary reference for development and GenAI. Update SPEC directly on every interface addition or change, and track changes in the Changelog.

**Minimum maintenance rule**: Every PR involving interface or behavior changes MUST update the SPEC content and Changelog.

## ADR Trigger Conditions

- ✅ Needs ADR: architecture layering strategy, auth scheme design (e.g., JWT dual-token), either/or tech decision (e.g., Kafka vs Event Hubs), design decisions for cross-module shared components
- ❌ No ADR needed: adding a CRUD API, changing cache TTL defaults, simple bug fix

## Candidate Documents (Lazy Evaluation)

| Candidate | Trigger |
| --------- | ------- |
{From SCAN's "Recommended Minimal SDD Document Set"}

## Document Index

| Document                              | Path | Status |
| ------------------------------------- | ---- | ------ |
| (Update this table as docs are added) |      |        |
```

## Step 4: Assessment and Next Steps

After assembling both files, output the following assessment in the conversation (DO NOT write to file):

1. **Scan summary**: List detected tech stack, module count scale (few/moderate/many), existing docs/ file count
2. **Project type**: Based on detected Controller/endpoint count, mark **Greenfield** (< 10 endpoints or brand new) or **Brownfield** (existing moderate/large API surface)
3. **Recommended first SPEC**: Adjust recommendation by project type:
   - Greenfield: Create the first SPEC as soon as the first real API endpoint is complete (follow the development track)
   - Brownfield: Pick one API from a domain with code changes in the last 30 days and create the first SPEC
4. **Recommended minimal document set**: Based on project scale, suggest initial SDD documents (e.g., "Start with 1 SPEC + 1 SA; create ADR only when a decision arises")
5. **Next steps**: Output recommendations based on detected project type:

   **Greenfield path**:
   - Enter event-driven mode directly
   - Recommendation: Run SPEC Prompt as soon as the first real API endpoint is complete
   - Priority: `SPEC → ADR (when decisions arise) → SA (at milestones)`

   **Brownfield path**:
   - Run **SA Prompt** first (produce a system architecture snapshot for AI to gain global understanding)
   - Then pick an API with changes in the last 30 days as the priority for the first **SPEC**
   - Reminder: Write SPEC as As-Is (describe current code behavior — DO NOT mix in To-Be improvements)
   - Priority: `SA → High-priority SPEC (backfill) → Normal SPEC triggered by development`

## Drift Prevention Rules (Apply to all output)

- Write versions as Major.Minor only — omit Patch
- DO NOT list exact file counts; describe structural patterns
- Each version number MUST appear only once; second references MUST use "see X declaration"
- Declare "version source of truth" pointing to config files
- If any field lacks code or config evidence, mark `[unverified]` — DO NOT guess
- This Prompt produces ONLY `AGENTS.md` and `docs/README.md`; DO NOT create other docs/ sub-documents
- If existing docs/ files are found, reference them in the "GenAI Docs Navigation" table — DO NOT create or modify them
- AGENTS.md MUST NOT embed docs governance rules (classification table, naming regex); those belong in docs/README.md

---END PROMPT---
````

---

## Next Step

After Day-1 completion, use the matching Prompt Pack per event:

| Trigger Event          | Prompt Pack              |
| ---------------------- | ------------------------ |
| API addition/change    | [`SPEC.md`](SPEC.md)     |
| Architecture decision  | [`ADR.md`](ADR.md)       |
| System snapshot        | [`SA.md`](SA.md)         |
| Project evolution sync | [`UPDATE.md`](UPDATE.md) |
