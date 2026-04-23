# ZeroSpec — INIT-SCAN Prompt Pack

> **Step 1: Analyze current state and build consensus.** Paste the Prompt below into your AI Agent. The agent scans the repository and produces a structured status report. **No files are written.**

---

## How to Use

1. Open an AI conversation at your project root (prefer Agent mode; if the platform's Plan mode can read the codebase, it also works for this scan step)
2. Copy everything between `---BEGIN PROMPT---` and `---END PROMPT---`
3. Paste into the Agent and send
4. The Agent scans the repo and outputs a structured analysis report
5. Review the results and answer clarification questions (~5–10 min)
6. Once confirmed, proceed with [`INIT-BUILD.md`](INIT-BUILD.md) to generate `AGENTS.md` + `docs/README.md`

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start to prevent the AI from modifying other projects:
>
> ```
> Target project: my-backend
> Scan this project and produce an analysis report.
> ```
>
> Or open any file within the target project (Active File anchoring) so the Agent prioritizes that project's context.
> If the current working directory is outside the target project scope, stop and report — do not proceed.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

## Role

Act as a project system analyst.
This task is analysis-only. Do not generate code or write files.

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.

## Goal

Produce a structured status report for this repository. Determine which documents should be created first to adopt SDD (Specification-Driven Development) at minimal cost.

## Definitions

The following are the four document types in SDD lean mode. Use these definitions throughout the analysis:
- **SA** (System Analysis): Milestone-level analysis snapshot recording gaps between specs and actual state
- **ADR** (Architecture Decision Record): Single architecture decision with context, options, and conclusion; append-only — supersede with a new ADR, never edit
- **SPEC** (Interface Specification): Behavioral contract for external interfaces; serves as the primary development reference (Source of Truth), includes Changelog
- **INFRA** (Infrastructure): Infrastructure selection and topology; Library projects may use INTEGRATION instead

## Analysis Framework

### Core Analysis (Required)

1. **Tech stack and runtime type**:
   - Read build.gradle / package.json / .csproj / pyproject.toml / go.mod / requirements.txt / Cargo.toml or equivalent config files
   - Extract language version, framework version (Major.Minor only — omit Patch)
   - Determine project type: library / API service / frontend SPA / monorepo / CLI tool / etc.

2. **External interfaces and integration points**:
   - API endpoints, SDKs, events, scheduled jobs, MQ, external system integrations
   - Which interfaces are most worth specifying first (high complexity, frequent changes, or multiple consumers)

3. **Existing documentation status**:
   - Identify README, design docs, API docs, architecture docs, spec files
   - Which can serve as Source of Truth
   - Which are likely outdated or insufficient

### Supplementary Analysis (Include only when findings exist)

4. **Directory and module structure**: Main directories' responsibilities, whether clear layering exists
5. **Architecture decisions and risk signals**: Important architecture choices inferred from code, places where ADRs may be needed

### Scan Order

Scan in this priority: root config files (package.json / build.gradle / .csproj etc.) → source entry (src/) → docs/ → CI/CD.

## Output Format

Use the structure below. Keep each section to 5–15 lines. Draft B-class content during analysis and mark each section `[needs review]`.

### 1. Project Status Summary
List 5–10 bullet points describing the current state of the project.

### 2. Tech Stack Extraction (A-class)
List all technical information auto-detected from config files.

### 3. Core Modules and Boundaries
List main modules, their responsibilities, and upstream/downstream relationships.

### 4. B-class Draft
Present these 5 items in order, each marked `[needs review]`:
1. **Docs navigation table**: Scan docs/, use intent-driven format (left column: "What you want to do", right column: path)
2. **Domain-to-code map**: Scan core classes, group by naming correlation
3. **Architecture layers**: Infer layering pattern or data flow from existing code
4. **Naming conventions**: Identify existing naming patterns from statistics
5. **Related projects**: Detect cross-project dependencies from build config or relative paths

### 5. Top Priorities for Specification (1–3 items)
List the topics most urgently needing a Source of Truth. Explain why.

### 6. Recommended Minimal SDD Document Set
Give direct recommendations in this format:
- `SA-001`: What to analyze
- `ADR-001`: What decision to record (omit if no clear need)
- `SPEC-001`: What interface or behavior to describe
- `INTEGRATION.md`: What integration flow to document (omit if not needed)

### 7. Open Questions (max 5)
List the most critical questions that cannot be determined from the current state. These will be carried into the next step (INIT-BUILD).

## Rules

- **This Prompt MUST NOT write any files** — output analysis in the conversation only
- Prioritize understanding the current state and building minimal consensus; DO NOT introduce heavy processes
- Write versions as Major.Minor only — omit Patch
- DO NOT list exact file counts; describe structural patterns (e.g., "multiple Controllers" not "19 Controllers")
- If any field lacks code or config evidence, mark `[unverified]` — DO NOT guess

---END PROMPT---
````

---

## Next Step

After confirming the analysis → use [`INIT-BUILD.md`](INIT-BUILD.md) to generate `AGENTS.md` + `docs/README.md`.
