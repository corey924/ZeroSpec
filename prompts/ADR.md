# ZeroSpec — ADR Prompt Pack

> Use when a **cross-module either/or technical decision** is made. Paste the Prompt below into your AI Agent to generate an ADR document draft.

---

## Trigger Conditions

- Architecture layering strategy selection (e.g., Clean Architecture vs Hexagonal)
- Either/or technical decision (e.g., Kafka vs Event Hubs, JWT vs Session)
- Design decisions for cross-module shared components
- Infrastructure selection (e.g., PostgreSQL vs MySQL, Redis vs Memcached)

## Does NOT Trigger (No ADR needed)

- Adding a CRUD API
- Changing Redis TTL defaults
- Simple bug fix

---

## How to Use

1. Confirm a trigger condition is met
2. Copy the Prompt below and paste into the Agent
3. Review the ADR draft and save to `docs/adr/`

> **Multi-root Workspace Tip**
>
> When your workspace contains multiple projects, specify the target at the start to prevent the AI from modifying other projects:
>
> ```
> Target project: my-backend
> Generate an ADR document for this architecture decision.
> ```
>
> Or open any file within the target project (Active File anchoring) so the Agent prioritizes that project's context.
> If the target file path falls outside the target project scope, stop and report — do not write.
> See [DAILY-USAGE Section 2.4](../DAILY-USAGE.md#24-multi-root-workspace-notes).

---

````
---BEGIN PROMPT---

Generate an ADR document for this technical decision.

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.
> To override, prepend `Respond in {locale}` (e.g. `Respond in zh-TW`) before pasting this prompt.

## Prerequisites

- `AGENTS.md` exists (if not, run INIT-SCAN + INIT-BUILD first)
- `docs/README.md` exists (if not, run INIT-BUILD first)

## Steps

1. **Read AGENTS.md**: Understand the project's tech stack and architecture constraints
2. **Read docs/README.md**: Confirm naming regex and ADR numbering sequence
3. **Read existing ADRs**: Scan docs/adr/ to confirm numbering and existing decision context
4. **Confirm with me**:
   - What is the decision context? (Cite verifiable evidence first; if insufficient, mark `[unverified]` and ask)
   - What are the options? (List at least 2)
   - Which was chosen and why?
5. **Produce ADR draft** in the following format:

```markdown
# ADR-xxx: {Decision Title}

| Field         | Value                              |
| ------------- | ---------------------------------- |
| Decision Date | {today's date}                     |
| Status        | Proposed                           |
| Related       | SA-xxx, ADR-yyy, SPEC-xxx (if any) |
| Impact Scope  | (Affected modules or domains)      |

## Context
(Infer from conversation context and code, mark [needs review])

## Options Considered

### Option A — {Name}
- Pros: ...
- Cons: ...

### Option B — {Name}
- Pros: ...
- Cons: ...

## Decision
Chose Option X because...

## Consequences
- Positive impact: ...
- Negative impact / risks: ...
- Follow-up actions: ...
```

## Rules

- Naming format: `ADR-{3-digit}_{lowercase-hyphenated-desc}.md`
- Draft ADRs may be edited. After acceptance, preserve the decision body; a later ADR may update only the old record's Status/Related metadata to `Superseded by ADR-yyy`.
- Numbering starts from max existing ADR number + 1
- If no verifiable evidence exists, DO NOT fill in context details — mark `[unverified]` instead

## Post-Output Verification

1. Verify that modules and component names referenced in the document actually exist in code
2. Confirm `docs/README.md` document index includes the newly created ADR
3. If a matching entry exists in the candidate documents table, move it to the document index

---END PROMPT---
````
