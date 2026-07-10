# etl-pipeline-core — Docs Governance Hub

> This file defines the layering rules, naming conventions, and maintenance triggers for project documentation.
> GenAI Agents MUST read this file before performing any documentation task.

## SDD Document Classification

| Category                    | Directory        | Naming Format               | Trigger                                                     |
| --------------------------- | ---------------- | --------------------------- | ----------------------------------------------------------- |
| SA (System Analysis)        | `docs/analysis/` | `SA-{3-digit}_{desc}.md`    | Milestone or major architecture change                      |
| ADR (Architecture Decision) | `docs/adr/`      | `ADR-{3-digit}_{desc}.md`   | Cross-module either/or tech decision                        |
| SPEC (Narrative Contract)   | `docs/spec/`     | `SPEC-{3-digit}_{desc}.md`  | High-risk public behavior, or an existing SPEC scope change |
| INFRA (Infrastructure)      | `docs/infra/`    | `INFRA-{3-digit}_{desc}.md` | Deployment topology or CI change                            |

- Naming regex: `^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$`
- **Extension**: Library projects may use INTEGRATION instead of INFRA

## Contract Ownership

- **Machine-verifiable contract**: Python public signatures own fields and types.
- **Narrative SPEC**: Owns behavior, business rules, permissions, compatibility, and consumer impact.

**Maintenance rule**: Update the `PipelineService` SPEC when its owned behavior changes. Create new narrative contracts only for high-risk public behavior.

## ADR Trigger Conditions

- ✅ Needs ADR: Adapter design pattern choice, scheduler engine selection, either/or tech decision
- ❌ No ADR needed: adding an Adapter implementation, changing retry parameters, simple bug fix

## Candidate Documents (Lazy Evaluation)

> Create only when the trigger condition is met — do not pre-create empty shells.

| Candidate                                     | Trigger                                          |
| --------------------------------------------- | ------------------------------------------------ |
| `SPEC-001_pipeline-service-interface.md`      | Public interface needs a formal contract         |
| `SA-001_etl-pipeline-core-system-analysis.md` | Project grows and needs a system snapshot        |
| `INTEGRATION.md`                              | Integration steps with main application need doc |

## Document Index

| Document | Path | Status           |
| -------- | ---- | ---------------- |
| —        | —    | No documents yet |
