# booking-backend — Docs Governance Hub

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

## Contract Ownership

- **Machine-verifiable contract**: Code is the current machine-verifiable source for fields and types.
- **Narrative SPEC**: Owns behavior, business rules, permissions, compatibility, and consumer impact.

**Maintenance rule**: Update an existing SPEC when its scope changes. Create one for high-risk cross-system, multi-consumer, security, compatibility, or complex-rule behavior.

## ADR Trigger Conditions

- ✅ Needs ADR: architecture layering strategy, auth scheme design (e.g., JWT dual token), either/or tech decision
- ❌ No ADR needed: adding a CRUD API, changing cache TTL defaults, simple bug fix

## Candidate Documents (Lazy Evaluation)

> Create only when the trigger condition is met — do not pre-create empty shells.

| Candidate                           | Trigger                                   |
| ----------------------------------- | ----------------------------------------- |
| `SPEC-001_api-auth-and-rbac.md`     | Auth & RBAC API needs a formal contract   |
| `SA-001_system-overview.md`         | Project grows and needs a system snapshot |
| `INFRA-001_deployment-and-ci-cd.md` | Deployment topology needs formal record   |

## Document Index

| Document                              | Path                                      | Status   |
| ------------------------------------- | ----------------------------------------- | -------- |
| SA-001_system-overview.md             | analysis/SA-001_system-overview.md        | Active   |
| SPEC-001_api-auth-and-rbac.md         | spec/SPEC-001_api-auth-and-rbac.md        | Active   |
| ADR-001_dual-host-api-architecture.md | adr/ADR-001_dual-host-api-architecture.md | Accepted |
