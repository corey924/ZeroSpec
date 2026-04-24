# ZeroSpec — SPEC Prompt Pack

> Use when an **API is added or its behavior changes**. Paste the Prompt below into your AI Agent to generate a SPEC document draft.

---

## Trigger Conditions

- New external API endpoint
- Modified Request / Response structure of an existing API
- Changed API permission requirements or business rules
- **Bug fix that changes external behavior** (the SPEC should record the before/after difference — see "Bugfix Variant" below)

---

## How to Use

1. Confirm a trigger condition is met
2. Copy the Prompt below and paste into the Agent
3. Review the SPEC draft and save to `docs/spec/`

### Bugfix Variant (when the trigger is a behavior-changing bug fix)

If this change is a bug fix rather than a new feature, record it as a delta update instead of rewriting the full interface definition:

- **Current Behavior**: Actual behavior before the fix (infer from the prior SPEC or Git log)
- **Expected Behavior**: Correct behavior after the fix
- **Unchanged Behavior**: Behavior not affected by this fix (to prevent regression misunderstandings)
- **Impact Scope**: Affected consumers / downstream systems

Write the above as a new entry in `## Changelog`. Example: `- YYYY-MM-DD Bugfix: {summary} (Before: … → After: …)`.

> **Reference**: Kiro Bugfix Spec's current/expected/unchanged structure helps prevent oscillation; ZeroSpec incorporates it as a lightweight addition to existing SPECs rather than a separate Bugfix file.

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start to prevent the AI from modifying other projects:
>
> ```
> Target project: my-backend
> Generate a SPEC document for this API change.
> ```
>
> Or open any file within the target project (Active File anchoring) so the Agent prioritizes that project's context.
> If the target file path falls outside the target project scope, stop and report — do not write.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Generate or update a SPEC document for this API change.

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.
> To override, prepend `Respond in {locale}` (e.g. `Respond in zh-TW`) before pasting this prompt.

## Prerequisites

- `AGENTS.md` exists (if not, run INIT-SCAN + INIT-BUILD first)
- `docs/README.md` exists (if not, run INIT-BUILD first)

## Steps

1. **Read AGENTS.md**: Understand the project's tech stack, architecture layers, API path conventions, and permission format
2. **Read docs/README.md**: Confirm naming regex, SPEC numbering sequence, and candidate document list
3. **Scan related source code**: Read the Controller, Service, and DTO classes involved in this change
4. **Read existing document (if updating)**: If this updates an existing SPEC, MUST read the original `docs/spec/SPEC-xxx.md` content first to avoid overwriting existing API definitions
5. **Produce SPEC draft** in the following format:

```markdown
# SPEC-xxx: {Business Domain Name}

| Field   | Value                                         |
| ------- | --------------------------------------------- |
| Version | v0.1                                          |
| Status  | Draft                                         |
| Scope   | (Controllers / Services covered by this SPEC) |
| Related | SA-xxx, ADR-xxx (if any)                      |

## Overview
(Infer the domain's business goal and API endpoint scope from code)

## Interface Definitions
### `METHOD /api/v1/resource`
| Item       | Description |
| ---------- | ----------- |
| Function   | ...         |
| Permission | ...         |
| Request    | ...         |
| Response   | ...         |

## DTO Definitions
(List key DTO classes and fields)

## Business Rules
(Infer from validation logic and comments in code)

## Changelog
| Version | Date           | Changes       |
| ------- | -------------- | ------------- |
| v0.1    | {today's date} | Initial draft |
```

## Rules

- Naming format: `SPEC-{3-digit}_{lowercase-hyphenated-desc}.md`
- If updating an existing SPEC: modify only the changed sections + append one row to Changelog
- Write versions as Major.Minor only — omit Patch
- Extract DTO fields from actual code — DO NOT guess
- If any field lacks code or config evidence, mark `[unverified]` — DO NOT guess
- Mark business rules and permission definitions with `[needs review]` (requires human confirmation of boundary conditions and RBAC consistency)

## Post-Output Verification

1. Verify that every class / method / API path referenced in the document actually exists in code
2. Confirm `docs/README.md` document index includes the newly created SPEC
3. If a matching entry exists in the candidate documents table, move it to the document index

---END PROMPT---
````
