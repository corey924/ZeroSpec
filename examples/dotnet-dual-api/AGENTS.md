# AGENTS.md — booking-backend AI Navigation Guide

> Primary entry point for GenAI Agents. Read before starting any task.

## Project Summary

**Large-scale Event Booking API** — Dual-host backend covering seat allocation, payment callbacks, reporting, and operations.

- **Tech Stack**: .NET 10 (C#) + ASP.NET Core + EF Core + SQL Server + MSTest
- **Architecture**: Dual API Host (Admin / EndUser) sharing a common Service layer
- **Base Namespace**: `Booking.Api.Admin`, `Booking.Api.EndUser`, `Booking.Service`, `Booking.Test` (follow `Booking.sln`)
- **Deployment**: Azure Web App (CI via GitHub Actions)
- **Version source of truth**: .NET SDK per `global.json`; packages per `.csproj`

## Quick Constraints

1. Controllers handle HTTP request/response only — no business logic
2. Controllers MUST NOT write SQL or access DbContext directly
3. Never bypass the auth chain (Filter / Middleware / Policy)
4. No real credentials or secrets in docs or code

## Domain-to-Code Map

| Domain                     | API Host        | Code Location                 |
| -------------------------- | --------------- | ----------------------------- |
| Auth & Authorization       | Admin + EndUser | `Controllers/`, `Middleware/` |
| Seat Planning & Operations | EndUser + Admin | `Booking.Service/Services/`   |
| Payment & Callbacks        | EndUser         | `Filters/`, `Services/`       |
| Reporting & Scheduling     | Admin           | `ScheduleJobs/`, `Services/`  |

## Code Generation Rules

### Architecture

- Controllers handle HTTP only — business logic belongs in `Booking.Service/Services`
- Data access belongs in `Booking.Service/Repositories`

### Naming

- New services: `{Domain}Service`
- New repositories: `{Domain}Repository`

### Prohibited

- Controllers MUST NOT write SQL or access DbContext directly
- Never bypass existing auth chain (Filter / Middleware / Policy)
- No real credentials or secrets in docs or code

## GenAI Documentation Navigation

| What you want to do          | Read this first                              |
| ---------------------------- | -------------------------------------------- |
| Understand system overview   | docs/analysis/SA-001_system-overview.md      |
| Look up API, JWT, auth, RBAC | docs/spec/SPEC-001_api-auth-and-rbac.md      |
| Query external integrations  | docs/spec/SPEC-002_external-integrations.md  |
| Check deployment / CI/CD     | docs/infra/INFRA-001_deployment-and-ci-cd.md |

## Common Commands

| Command                                        | Description       |
| ---------------------------------------------- | ----------------- |
| `dotnet build Booking.sln`                     | Build solution    |
| `dotnet test Booking.Test/Booking.Test.csproj` | Run unit tests    |
| `dotnet run --project Booking.Api.Admin`       | Start Admin API   |
| `dotnet run --project Booking.Api.EndUser`     | Start EndUser API |

## Documentation Maintenance Reminders

- **API contract or behavior change**: apply Contract Ownership; update an in-scope narrative SPEC and Changelog when required, otherwise state why the machine contract or no narrative update is sufficient
- **Architecture decision**: add or update `docs/adr/`
- **Deployment or CI/CD change**: update `docs/infra/`
- Docs governance rules: `docs/README.md`

## Post-Edit Self-Check

Before declaring work complete:
1. List changed files from the current diff.
2. Cross-reference every changed file with the Code-to-Docs Map above.
3. For each candidate doc, state `Update needed` or `No update needed` with a reason.
4. Apply Contract Ownership: update an in-scope narrative SPEC when required; otherwise state why the machine contract or no document update is sufficient.
5. Run `dotnet build` and `dotnet test` to confirm no regressions.

**Forcing Function**: AI agents MUST append a `### Docs Impact` block at the end of any response containing code changes, listing: (a) affected `docs/spec/` files and their update status; (b) reason if no update is needed.
