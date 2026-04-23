# ZeroSpec — UPDATE Prompt Pack

> Use when **project evolution causes AGENTS.md or docs/README.md to drift from the current codebase**. Paste the Prompt below into your AI Agent to compare the current state and update documents.

---

## Trigger Conditions

- Project adds or removes a business module
- Tech stack version change (framework Major/Minor bump)
- Architecture layer change (new layer added, modules merged)
- Domain-to-code map is visibly outdated
- Related projects added or removed
- docs/ has new files not indexed in docs/README.md

---

## How to Use

1. Confirm a trigger condition is met
2. Copy the Prompt below and paste into the Agent
3. The Agent outputs a diff report and proposed changes — confirm before writing

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start to prevent the AI from modifying other projects:
>
> ```
> Target project: my-backend
> Review whether this project's documentation has drifted from the current state.
> ```
>
> Or open any file within the target project (Active File anchoring) so the Agent prioritizes that project's context.
> If the target file path falls outside the target project scope, stop and report — do not modify.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Check and update this project's AGENTS.md and docs/README.md to keep them in sync with the codebase.

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.

## Steps

### Step 1: Re-scan A-class Information

Scan the project and extract the latest:
1. **Tech stack**: Read config files, extract language and framework versions (Major.Minor)
2. **Base Namespace / Package / Alias**: Infer from src/ structure
3. **Version source of truth**: Confirm whether config files have changed
4. **Common commands**: Scan Makefile / package.json scripts / gradlew etc.
5. **Directory structure**: List newly added or removed key directories

### Step 2: Diff Against Current AGENTS.md

Compare section by section and flag differences:

1. **Project Summary**: Does the tech stack version need updating?
2. **Quick Constraints**: Still consistent with Code Generation Rules? Still reflects the top 5–8 hard rules?
3. **Domain-to-Code Map**: Any Controllers / Services / Components added, removed, or renamed?
4. **Code Generation Rules**: Any new naming conventions or architecture changes?
5. **Docs Navigation**: Any new docs/ files not yet in the navigation table?
6. **Common Commands**: Any scripts added or removed?
7. **Related Projects**: Any new cross-project dependencies?
8. **Docs Maintenance Reminders**: Do trigger conditions need adjustment?

### Step 3: Diff Against docs/README.md

1. **Document Index**: Scan docs/ directory — confirm all .md files are listed
2. **Candidate Documents**: Move established candidates from the candidate table to the document index
3. **Classification**: Confirm whether new document types need to be added

### Step 4: Output Diff Report

Present differences as tables in the conversation (DO NOT write to files directly). Produce two reports:

- **AGENTS.md diff**: Section-by-section (Project Summary, Quick Constraints, Domain-to-Code Map, Code Generation Rules, Docs Navigation, Common Commands, Related Projects, Docs Maintenance Reminders). Mark each as "Update / Add / No change" + explanation
- **docs/README.md diff**: List document index and candidate document changes

### Step 5: Write After Confirmation

After receiving user confirmation, apply the following changes:
- Modify only sections with differences; preserve user-edited C-class content (hard rules, project summary, etc.)
- Mark new B-class content with `[needs review]`
- If Quick Constraints exist, re-extract from Code Generation Rules to keep both sections consistent
- Treat Quick Constraints as a pinned projection of C3 decisions: preserve original decision intent during sync, and write only after user confirmation
- Update docs/README.md document index

## Rules

- MUST NOT delete or modify C-class human decisions (hard rules, project summary, deployment strategy, permission format, etc.) — propose changes only and wait for user confirmation
- A-class information: update directly (tech stack versions, command lists, etc.)
- B-class information: mark `[needs review]` after update
- Follow drift prevention rules: Major.Minor versions only, no exact counts, DO NOT guess

---END PROMPT---
````

---

## Recommended Frequency

- **Rapid evolution phase**: Run once per month or at each Sprint end
- **Stable maintenance phase**: Run once per quarter
- **After major changes**: Run immediately (e.g., framework upgrade, module refactor)

Pair with the review checklist in [GUIDE.md Section 7](../GUIDE.md#7-adoption-and-continuous-operation).
