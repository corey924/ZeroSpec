# {Project Name} — Docs Governance Hub

> This file defines the layering rules, naming conventions, and maintenance triggers for project documentation.
> GenAI Agents MUST read this file before documentation tasks, and when `AGENTS.md` Docs Impact checks point here.
>
> Copy this template to `docs/README.md` and replace `{placeholders}` before use.

## SDD Document Classification

| Category                    | Directory        | Naming Format               | Trigger                                                        |
| --------------------------- | ---------------- | --------------------------- | -------------------------------------------------------------- |
| SA (System Analysis)        | `docs/analysis/` | `SA-{3-digit}_{desc}.md`    | Milestone or major architecture change                         |
| ADR (Architecture Decision) | `docs/adr/`      | `ADR-{3-digit}_{desc}.md`   | Cross-module either/or tech decision                           |
| SPEC (Narrative Contract)   | `docs/spec/`     | `SPEC-{3-digit}_{desc}.md`  | High-risk interface behavior, or an existing SPEC scope change |
| INFRA (Infrastructure)      | `docs/infra/`    | `INFRA-{3-digit}_{desc}.md` | Deployment topology or CI change                               |

- Naming regex: `^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **Flexible extension**: Library projects may use INTEGRATION instead of INFRA; frontend projects may add a Components index

## Contract Ownership

- **Machine-verifiable contract** (for example OpenAPI, protobuf, JSON Schema, generated client, or code): {path or `not configured`} owns paths, fields, types, and requiredness.
- **Narrative SPEC**: owns behavior, business rules, permissions, state transitions, compatibility, and consumer impact. Link to the machine contract instead of copying it.
- If no machine-verifiable contract exists, a SPEC may own the complete interface description.

**Maintenance rule**: Update an existing SPEC when its scope changes. Create a new SPEC only for a high-risk interface change: cross-system or multi-consumer behavior, complex business rules/state, permission or security boundary, or compatibility commitment.

## ADR Trigger Conditions

- ✅ Needs ADR: architecture layering strategy, auth scheme design (e.g., JWT dual-token), either/or tech decision (e.g., Kafka vs Event Hubs), design decisions for cross-module shared components
- ❌ No ADR needed: adding a CRUD API, changing cache TTL defaults, simple bug fix

## SA Trigger Conditions

> SA is a system-level snapshot. Unlike narrative SPECs, it is created on-demand when global understanding is lacking.

- ✅ Suggest SA: entering a Brownfield codebase with no current architecture overview, cross-module boundaries shifting (3+ modules restructured), team members repeatedly asking "how does this system work?", or recent architecture-level changes not reflected in existing docs
- ❌ No SA needed: routine feature work within a single module, adding endpoints, bug fixes
- ⚠️ AI action: **Propose** the SA topic and scope — do NOT silently generate. Wait for human confirmation before using the SA Prompt Pack.

## AI Auto-Trigger Heuristics (Zero-Dependency)

> GenAI Agents MUST autonomously assess document needs during every coding task.
> This table is the **single decision matrix** — no external tooling required.

| Signal Detected in Task                                                                                                                   | Document to Create/Update | AI Action Mode                                                     |
| :---------------------------------------------------------------------------------------------------------------------------------------- | :------------------------ | :----------------------------------------------------------------- |
| Existing SPEC scope changes; cross-system or multi-consumer interface; complex rules/state; permission/security; compatibility commitment | **SPEC**                  | **Mandatory**: update in the same changeset.                       |
| Simple internal CRUD or a machine-contract-only field change with no narrative impact                                                     | —                         | State why no narrative SPEC update is needed.                      |
| Cross-module either/or tech decision; new third-party integration choice; shared pattern introduction                                     | **ADR**                   | **Propose**: explain alternatives, draft ADR after human approval. |
| Brownfield codebase with no current architecture overview; large-scale module restructure (3+ modules); team onboarding gaps              | **SA**                    | **Propose**: suggest scope, wait for human confirmation.           |
| Deployment topology, runtime configuration, IaC, or CI/CD release behavior changes                                                        | **INFRA**                 | **Mandatory** when deployment behavior changes.                    |
| None of the above signals detected                                                                                                        | —                         | State "No doc update needed" with reason in `### Docs Impact`.     |

### Route Selection

- **Best Route (built-in, zero-dependency)**: Use the `AGENTS.md` Post-Edit Self-Check + `### Docs Impact` Forcing Function. It is designed to work with mainstream LLMs (Claude, GPT, Gemini) without runtime tooling.
- **Fallback Route (optional)**: If your AI platform repeatedly skips the `### Docs Impact` block or cannot keep `docs/README.md` in context, consider installing the ZeroSpec Agent-Skill to add explicit routing in the toolchain.

## Candidate Documents (Lazy Evaluation)

> These are documents that may be needed. Create them only when the trigger condition is met — DO NOT pre-create empty shells.

| Candidate            | Trigger            |
| -------------------- | ------------------ |
| `SA-001_{desc}.md`   | {describe trigger} |
| `SPEC-001_{desc}.md` | {describe trigger} |
| `ADR-001_{desc}.md`  | {describe trigger} |

## Document Index

> Update this table as documents are added.

| Document | Path | Status           |
| -------- | ---- | ---------------- |
| —        | —    | No documents yet |

<!-- Sub-index trigger (per GUIDE §4.6):
     When docs/spec/ contains ≥ 8 SPEC files, create docs/spec/README.md
     using the ZeroSpec SPEC index template structure.
     Keep this flat list AND link to the sub-index for situational lookup. -->

<!-- Cross-system consensus (enable for multi-repo setups)
## Cross-System Consensus

| Project        | Docs Path                           |
| -------------- | ----------------------------------- |
| {related-repo} | ../../{related-repo}/docs/README.md |
-->
