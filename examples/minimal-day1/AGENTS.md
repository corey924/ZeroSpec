# AGENTS.md — taskflow-api AI Navigation Guide

> Primary entry point for GenAI Agents. Read before starting any task.

## Project Summary

**Task Scheduling API** — REST backend for task creation, scheduling, and execution tracking.

- **Tech Stack**: .NET 10 (C#) + ASP.NET Core + EF Core + PostgreSQL 16
- **Base Namespace**: `TaskFlow.Api`, `TaskFlow.Service` (follow Solution structure)
- **Architecture**: Clean Architecture (Controller → Service → Repository)
- **Deployment**: Docker Compose (local) / Azure App Service (production)
- **Version source of truth**: .NET SDK per `global.json`; packages per `.csproj`

## Quick Constraints

1. Controllers handle HTTP request/response only — no business logic
2. Controllers MUST NOT access DbContext directly
3. API path format: `/api/v1/{resource}`

## Domain-to-Code Map

| Domain     | Controller           | Core Service       |
| ---------- | -------------------- | ------------------ |
| Auth       | `AuthController`     | `IAuthService`     |
| Tasks      | `TaskController`     | `ITaskService`     |
| Scheduling | `ScheduleController` | `IScheduleService` |

## Code Generation Rules

### Architecture

- Controllers handle HTTP only — business logic belongs in `TaskFlow.Service/Services`
- Data access belongs in `TaskFlow.Service/Repositories`

### Routing

- API path format: `/api/v1/{resource}`

### Prohibited

- Controllers MUST NOT access DbContext directly
- No real credentials or secrets in docs or code

## GenAI Documentation Navigation

| What you want to do        | Read this first |
| -------------------------- | --------------- |
| Understand docs governance | docs/README.md  |

## Common Commands

| Command                             | Description      |
| ----------------------------------- | ---------------- |
| `dotnet build TaskFlow.sln`         | Build solution   |
| `dotnet test TaskFlow.Test`         | Run unit tests   |
| `dotnet run --project TaskFlow.Api` | Start API server |

## Documentation Maintenance Reminders

- **API contract or behavior change**: update `docs/spec/` SPEC and Changelog
- **Architecture decision**: add `docs/adr/` ADR
- Docs governance rules: `docs/README.md`
