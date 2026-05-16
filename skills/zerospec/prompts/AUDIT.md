# ZeroSpec — AUDIT Prompt Pack

> Use when you want to **quantitatively assess your AGENTS.md quality**. Paste the Prompt below into your AI Agent. It produces a structured self-check report (**no files written**) for you to decide whether to trim, rewrite, or keep the current state.

---

## Trigger Conditions

- Monthly / quarterly review ([GUIDE.md Section 7](../GUIDE.md#7-adoption-and-continuous-operation))
- Agent repeatedly violates the same rule ([DAILY-USAGE Section 5.6](../DAILY-USAGE.md#56-ai-repeatedly-violates-the-same-agentsmd-rule))
- AGENTS.md mainline is getting long — evaluate whether trimming is needed
- New team member wants to verify the document is comprehensible

This Prompt does not write files or modify code — it only produces an assessment report.

---

## How to Use

1. Open the Agent at the target project root (Plan mode is acceptable)
2. Copy the Prompt below and paste in
3. The Agent outputs a self-check report — decide whether to adjust AGENTS.md accordingly

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start:
>
> ```
> Target project: my-backend
> Audit this project's AGENTS.md.
> ```
>
> Or open any file within the target project (Active File anchoring).
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Audit this project's `AGENTS.md` and produce a structured report across the dimensions below. **This task is read-only — DO NOT write any files.**

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.
> To override, prepend `Respond in {locale}` (e.g. `Respond in zh-TW`) before pasting this prompt.

## Prerequisites

- `AGENTS.md` exists (if not, prompt the user to run INIT-SCAN + INIT-BUILD first)
- This analysis targets the repo root's AGENTS.md; if nested AGENTS.md files exist, audit each separately and label them in the report

## Analysis Dimensions

### 1. Length & Structure

- Actual line count
- Character count (rough token estimate)
- Section distribution (list line-count share per `##` / `###` heading)
- Whether it exceeds ZeroSpec's recommended mainline length and upper limit

### 2. Rule Specificity

For each rule in `## Code Generation Rules` and `## Quick Constraints`, assess:

- **Verifiable** (e.g., "Controllers MUST NOT directly access DbContext")
- **Partially verifiable** (e.g., "Follow REST conventions")
- **Not verifiable** (e.g., "Keep code clean", "Write clear commit messages")

List all "Not verifiable" rules and suggest rewrite directions.

### 3. Rule Duplication & Conflicts

- Whether the same rule appears multiple times with inconsistent wording
- Whether two rules contradict each other
- Consistency between Quick Constraints and Code Generation Rules sections

### 4. Content AI Can Infer (Wasted context signals)

List content that **could be removed**, including:

- Language-built-in conventions (e.g., "Python uses snake_case", "TypeScript uses camelCase")
- Version numbers derivable from `.csproj` / `package.json` / `build.gradle`
- Generic code quality advice ("write clean code", "add appropriate comments")
- Build/test process already covered by Common Commands
- **Domain-to-code map necessity in small projects**: If the project is small AND the Agent supports semantic search (`#codebase` / Cursor indexing / Claude Code), the domain-to-code map's value is lower than the Agent's on-the-fly scanning — consider removing or heavily trimming

Apply this principle: **"Would removing this line cause the AI to make an error on its next task?" If not, it's a removal candidate.**

### 5. Missing ZeroSpec Required Fields

Check coverage of required sections ([GUIDE Section 3.1](../GUIDE.md#31-required-sections-and-generation-tiers)):

- Project Summary
- Anchor Information (Base Package / Alias / Version Source of Truth)
- Quick Constraints
- Domain-to-Code Map
- Code Generation Rules
- Docs Sync Triggers

### 6. Attention Weight Diagnosis

Assess whether the top section of AGENTS.md contains the most important information:

- Does the top section include "Project Summary + Anchor Information + Quick Constraints"?
- If the top section is occupied by onboarding narratives or lengthy background stories, flag as a high-priority trim target

### 7. Token Usage Observation (Optional)

AGENTS.md is injected into every Agent conversation's system context; longer content dilutes attention for other files. This dimension does not require precise calculation — provide a semantic judgment:

- **Low**: Minimal impact on other file attention
- **Moderate**: Noticeable but acceptable — review removal candidates from Dimension 4
- **High**: Clearly impacting context — prioritize trimming and deduplication

### 8. Domain-to-Code Map Health

Spot-check that entries in the Domain-to-Code Map still exist in the codebase or documentation tree:

- Pick 3–5 representative entries (Controller, Service, package, primary file, or directory) from the map
- Verify each still exists by direct path lookup, file search, glob expansion, or package/class declaration search
- Report: `✅ found`, `⚠️ not verified (no direct file access)`, or `❌ not found` for each spot-checked entry
- If ≥ 2 entries cannot be confirmed, flag as WARN; if ≥ 1 entry is confirmed absent, flag as FAIL

> Note: This dimension has limited accuracy without direct file-system access. If Agent cannot browse files freely, mark spot-checked entries as `⚠️ not verified` and note in the report.

### 9. Path Link Health

Check whether paths referenced in AGENTS.md resolve correctly:

- **Internal doc links** (`docs/`, `templates/`, relative markdown links): Do the target files exist?
- **Cross-repo relative paths** (`../other-repo/`, `../../shared/`): Are they resolvable from the current workspace root? If not, note and flag as WARN.
- **Broken links**: Any path reference that clearly does not exist → flag as FAIL

> Note: For cross-repo paths, use workspace context to determine whether the sibling repo is present. If it cannot be confirmed, mark as `⚠️ not verified` rather than FAIL.

## Output Format

Produce the report in Markdown:

```markdown
# AGENTS.md Audit Report — {project name}

Scan date: {YYYY-MM-DD}
File path: {AGENTS.md actual path}
Total lines: {n}

## Summary

- Health score: {PASS / WARN / FAIL} (any single FAIL condition triggers overall FAIL)
- Key findings:
  - …
  - …
  - …

## Detailed Analysis

### 1. Length & Structure
... (bullet points)

### 2. Rule Specificity
| Rule | Grade | Suggested Rewrite |
| ---- | ----- | ----------------- |
| ...  | ...   | ...               |

### 3. Rule Duplication & Conflicts
...

### 4. Removal Candidates
...

### 5. Missing Required Fields
...

### 6. Attention Weight Diagnosis
...

### 7. Token Usage Observation (Optional)
- Assessment: {Low / Moderate / High}
- Notes: {brief explanation}

### 8. Domain-to-Code Map Health
| Entry (file / class / package) | Status                                 |
| ------------------------------ | -------------------------------------- |
| `XxxController`                | ✅ found / ⚠️ not verified / ❌ not found |

### 9. Path Link Health
| Path Referenced | Target Exists?                |
| --------------- | ----------------------------- |
| `docs/spec/...` | ✅ / ⚠️ not verified / ❌ broken |

## Suggested Trim List (by priority)

1. **Must fix** (FAIL-level): ...
2. **Should fix** (WARN-level): ...
3. **Optional** (INFO): ...

## Actionable Fix List

For each finding, indicate the recommended follow-up action:

| #   | Finding                                            | Severity | Recommended Action                              |
| --- | -------------------------------------------------- | -------- | ----------------------------------------------- |
| 1   | Domain-to-code map entry `XxxController` not found | FAIL     | Update map manually or run UPDATE Prompt        |
| 2   | Broken link `docs/spec/SPEC-003.md`                | FAIL     | Create the missing SPEC or remove the reference |
| 3   | Unverifiable rule "write clean code"               | WARN     | Rewrite to a specific, testable constraint      |
| 4   | SPEC content may be stale after map/path changes   | INFO     | Run DRIFT Prompt on related SPECs               |

Action codes:
- **UPDATE**: Run [`prompts/UPDATE.md`](UPDATE.md) to sync AGENTS.md
- **SPEC**: Run [`prompts/SPEC.md`](SPEC.md) to create or update a SPEC
- **DRIFT**: Run [`prompts/DRIFT.md`](DRIFT.md) to verify SPEC content matches code
- **Manual**: Requires human judgment — cannot be automated

## Not Recommended to Change

Explicitly list items that "look like they should change but actually shouldn't" to prevent over-trimming.
```

## Health Score Criteria

- **PASS**: Mainline length within recommended range; few unverifiable rules and no obvious conflicts; top section dominated by core information; no confirmed broken Domain-to-Code Map entries or internal links
- **WARN**: Mainline slightly long, unverifiable rules / duplicates starting to accumulate, top section has some non-core content, or multiple map/path entries cannot be verified
- **FAIL**: Content clearly too long, many unverifiable rules / mutual conflicts, top section dominated by non-core content, or confirmed stale map entries / broken internal links already impact task comprehension

---END PROMPT---
````

---

## Post-Audit Actions

AUDIT only produces a report — no files are modified. If the report is WARN or FAIL, the recommended workflow:

1. **First, trim removal candidates** (Dimension 4) — highest impact for effort
2. **Then, rewrite unverifiable rules** (Dimension 2) — improves Agent compliance rate
3. **Fix confirmed map/path issues** (Dimensions 8–9) — stale navigation and broken links mislead Agents more than missing prose
4. **Finally, fill missing required fields** (Dimension 5) — if Quick Constraints are missing, run UPDATE Prompt to extract them from Code Generation Rules

If Dimensions 8–9 are clean but a related SPEC may still describe old behavior, run [DRIFT Prompt](DRIFT.md) before editing SPEC content.

If these actions involve file writes, use [UPDATE Prompt](UPDATE.md) with the audit report as input context, so UPDATE applies the report's recommendations to the actual AGENTS.md.

---

## Relationship to Other Prompts

| Prompt     | Action         | This Prompt's Role                                                   |
| ---------- | -------------- | -------------------------------------------------------------------- |
| INIT-SCAN  | Read + Analyze | Similar, but SCAN covers the whole repo; AUDIT focuses on AGENTS.md  |
| INIT-BUILD | Write files    | AUDIT does not write — only recommends                               |
| UPDATE     | Write files    | AUDIT output can serve as input for UPDATE                           |
| DRIFT      | Read + Report  | Use when AUDIT suggests valid navigation but stale SPEC behavior     |
| SPEC       | Write files    | Use only after deciding that SPEC content needs creation or update   |
| ADR        | Write files    | Unrelated unless AUDIT reveals missing architecture decision context |

---

## Limitations

- This Prompt can only diagnose `AGENTS.md` and the paths it references; it cannot evaluate actual Agent compliance rate.
- Actual compliance rate requires long-term observation of PR review history or repeated real-task sampling.
- If there is ambiguity in the report's "verifiable / not verifiable" judgment, use user experience as the final reference.
- **Dimension 8 (Domain-to-Code Map Health)**: Accuracy depends on whether the Agent can directly browse the filesystem. Without file access, entries are marked `⚠️ not verified` — treat as a prompt for manual spot-check, not a confirmed failure.
- **Dimension 9 (Path Link Health)**: Cross-repo relative paths can only be verified if the sibling repository is present in the current workspace. Paths outside the workspace are marked `⚠️ not verified`.
