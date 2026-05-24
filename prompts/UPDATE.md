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
> To override, prepend `Respond in {locale}` (e.g. `Respond in zh-TW`) before pasting this prompt.

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

### Step 3.5: Sub-Index Check

Count files matching `docs/spec/SPEC-*.md`.

- If count **≥ 8** AND `docs/spec/README.md` does **not** exist → propose creating it using the ZeroSpec SPEC index template structure, populated with current SPEC metadata. Localize human-facing README content (headings, prose, table labels, scenarios, maintenance rule descriptions, and status meanings) to the detected repository language or explicit `Respond in {locale}` override. Keep file paths, code identifiers, SPEC filenames, commands, and links literal. Add a link row in `docs/README.md` pointing to the new sub-index.
- If `docs/spec/README.md` already exists → verify its Document Index table lists all and only current SPEC files. Report missing, stale, renamed, or duplicate entries. Review "How to Choose" and "Maintenance Rules" for missing, stale, or duplicate scenario/maintenance mappings.

This check applies to SPEC only. Other document categories do not have sub-index rules unless explicitly added later.

### Step 3.7: Code-to-Docs Map Check

Check whether `AGENTS.md` contains a **Code-to-Docs Map** section (or equivalent) that maps source path patterns to owning documentation.

- If the section **exists** → verify it covers the project's main code areas (service layer, host config, DB models/migrations, public API, external integrations, deployment config). Report any gaps as "Update" items.
- If the section **does not exist** → propose adding one. Use the template below as a starting point. Do not write without user confirmation.

Minimum Code-to-Docs Map template:

| Changed path pattern | Docs to check | Notes |
| --- | --- | --- |
| `{service layer}` — new file or responsibility change | SA (domain-and-service-map) | Add relevant SPEC if external integration |
| `{host config}` — Program.cs / DI / middleware | SA (runtime-architecture) | |
| `{config files}` — structure change | SA (runtime-architecture), INFRA | |
| `{DB model / migration}` | SA (domain-and-service-map), relevant SPEC | |
| New public-facing interface / endpoint | Relevant SPEC + Changelog | |
| External integration behavior change | Relevant SPEC | |
| Deployment / CI/CD / infra topology change | INFRA | |
| Cross-module either/or architectural decision | New or updated ADR | |

After confirming the map exists or is proposed, remind the user that AI agents should use the Code-to-Docs Map as a **mandatory post-edit checklist**: list changed files → cross-reference the map → state "needs update / no update (reason)" for each candidate doc — before declaring the coding task complete.

### Step 3.8: Post-Edit Self-Check Audit

Check whether `AGENTS.md` contains a **Post-Edit Self-Check** section.

- If the section **exists** → verify it includes: (a) instructions to list changed files, (b) cross-reference with Code-to-Docs Map, (c) a **Forcing Function** requiring AI to output a `### Docs Impact` block after any response containing code changes. Report any missing elements as "Update" items.
- If the section **does not exist** → propose adding one. Use the template below as a starting point. Do not write without user confirmation.

Minimum Post-Edit Self-Check template:

```
## Post-Edit Self-Check
Before declaring work complete:
1. List changed files from the current diff.
2. Cross-reference every changed file with the Code-to-Docs Map (if present).
3. For each candidate doc, state `Update needed` or `No update needed` with a reason.
4. If interface, schema, permission, or business rules changed, update the relevant SPEC.
5. Run any applicable build/test command to confirm no regressions.

**Forcing Function**: AI agents MUST append a `### Docs Impact` block at the end of any
response containing code changes, listing: (a) affected `docs/spec/` files and their update
status; (b) reason if no update is needed.
```

### Step 4: Output Diff Report

Present differences as tables in the conversation (DO NOT write to files directly). Produce the following reports as applicable:

- **AGENTS.md diff**: Section-by-section (Project Summary, Quick Constraints, Domain-to-Code Map, Code Generation Rules, Docs Navigation, Common Commands, Related Projects, Docs Maintenance Reminders). Mark each as "Update / Add / No change" + explanation
- **docs/README.md diff**: List document index and candidate document changes
- **Sub-Index proposal** (only if Step 3.5 triggered): Present the proposed `docs/spec/README.md` creation or update content for user review
- **Code-to-Docs Map check**: State whether the map exists, whether its path patterns cover the changed areas, and any proposed additions
- **Post-Edit Self-Check check**: State whether the section exists and whether it includes changed-file listing, Code-to-Docs Map cross-reference, and the `### Docs Impact` Forcing Function

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
