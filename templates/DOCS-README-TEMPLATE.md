# {Project Name} — Docs Governance Hub

> This file defines the layering rules, naming conventions, and maintenance triggers for project documentation.
> GenAI Agents MUST read this file before performing any documentation task.
>
> Copy this template to `docs/README.md` and replace `{placeholders}` before use.

## SDD Document Classification

| Category                    | Directory        | Naming Format               | Trigger                                         |
| --------------------------- | ---------------- | --------------------------- | ----------------------------------------------- |
| SA (System Analysis)        | `docs/analysis/` | `SA-{3-digit}_{desc}.md`    | Milestone or major architecture change          |
| ADR (Architecture Decision) | `docs/adr/`      | `ADR-{3-digit}_{desc}.md`   | Cross-module either/or tech decision            |
| SPEC (Interface Contract)   | `docs/spec/`     | `SPEC-{3-digit}_{desc}.md`  | API addition or behavior change (**mandatory**) |
| INFRA (Infrastructure)      | `docs/infra/`    | `INFRA-{3-digit}_{desc}.md` | Deployment topology or CI change                |

- Naming regex: `^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **Flexible extension**: Library projects may use INTEGRATION instead of INFRA; frontend projects may add a Components index

## Source of Truth

SPEC is the primary reference for development and GenAI. Update SPEC directly on every interface addition or change, and track changes in the Changelog.

**Minimum maintenance rule**: Every PR involving interface or behavior changes MUST update the SPEC content and Changelog.

## ADR Trigger Conditions

- ✅ Needs ADR: architecture layering strategy, auth scheme design (e.g., JWT dual-token), either/or tech decision (e.g., Kafka vs Event Hubs), design decisions for cross-module shared components
- ❌ No ADR needed: adding a CRUD API, changing cache TTL defaults, simple bug fix

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

<!-- Cross-system consensus (enable for multi-repo setups)
## Cross-System Consensus

| Project        | Docs Path                           |
| -------------- | ----------------------------------- |
| {related-repo} | ../../{related-repo}/docs/README.md |
-->
