# inventory-frontend — Docs Governance Hub

> This file defines the layering rules, naming conventions, and maintenance triggers for project documentation.
> GenAI Agents MUST read this file before performing any documentation task.

## SDD Document Classification

| Category                    | Directory        | Naming Format               | Trigger                                                        |
| --------------------------- | ---------------- | --------------------------- | -------------------------------------------------------------- |
| SA (System Analysis)        | `docs/analysis/` | `SA-{3-digit}_{desc}.md`    | Milestone or major architecture change                         |
| ADR (Architecture Decision) | `docs/adr/`      | `ADR-{3-digit}_{desc}.md`   | Cross-module either/or tech decision                           |
| SPEC (Narrative Contract)   | `docs/spec/`     | `SPEC-{3-digit}_{desc}.md`  | High-risk interface behavior, or an existing SPEC scope change |
| INFRA (Infrastructure)      | `docs/infra/`    | `INFRA-{3-digit}_{desc}.md` | Deployment topology or CI change                               |

- Naming regex: `^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **Extension**: Frontend projects may add a Components index

## Contract Ownership

- **Machine-verifiable contract**: BFF route and TypeScript definitions own fields and types.
- **Narrative SPEC**: Owns behavior, business rules, permissions, compatibility, and consumer impact.

**Maintenance rule**: Update an in-scope BFF/API-hook SPEC when its owned behavior changes. Create one for high-risk interface behavior.

## ADR Trigger Conditions

- ✅ Needs ADR: state management library selection, BFF architecture design, either/or tech decision
- ❌ No ADR needed: adding a page component, styling adjustments, simple bug fix

## Candidate Documents (Lazy Evaluation)

> Create only when the trigger condition is met — do not pre-create empty shells.

| Candidate                                | Trigger                                   |
| ---------------------------------------- | ----------------------------------------- |
| `SPEC-001_bff-api-proxy.md`              | BFF proxy layer needs a formal contract   |
| `SA-001_frontend-system-architecture.md` | Project grows and needs a system snapshot |

## Document Index

| Document | Path | Status           |
| -------- | ---- | ---------------- |
| —        | —    | No documents yet |
