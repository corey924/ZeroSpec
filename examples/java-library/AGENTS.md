# AGENTS.md — edge-comm-core AI Navigation Guide

> Primary entry point for GenAI Agents. Read before starting any task.

## Project Summary

**Edge Device Communication Core Library** — Encapsulates command dispatch, Job lifecycle management (polling, retry, timeout compensation), and vendor Adapter integration for automated warehouse devices. Delivered as a **Library JAR** injected into the main backend service.

- **Tech Stack**: Java 21 + Spring Boot 3.5 + Gradle 8.14 + PostgreSQL 16 (shared DB with main backend)
- **Base Package**: `com.example.communication` (follow actual `src/main/java` structure)
- **Architecture**: Library — no standalone HTTP API; integrated via Spring AutoConfiguration
- **Public API**: Only `CommunicationCoreService` is public — all other classes are internal
- **Version source of truth**: dependencies and plugin versions per `build.gradle`

## Quick Constraints

1. `CommunicationCoreService` is the only public API — MUST NOT add REST Controllers
2. Scheduling logic (`JobTimeoutScanner`, `JobRetryScheduler`) is owned by this library — MUST NOT move to consumer project
3. Adding a new vendor Adapter MUST update `AdapterFactory` registry AND SPEC

## Domain-to-Code Map

| Domain                | Key Package / Class                                          |
| --------------------- | ------------------------------------------------------------ |
| **Public API**        | `service/CommunicationCoreService`                           |
| **Command Dispatch**  | `dispatcher/CommandDispatcher`                               |
| **Vendor Adapters**   | `adapter/VendorAdapter`, `adapter/AdapterFactory`            |
| **Job Lifecycle**     | `scheduler/JobTimeoutScanner`, `scheduler/JobRetryScheduler` |
| **Callback Handling** | `callback/JobCompletionHandler`                              |
| **Data Access**       | `repository/JobRepository`, `repository/DeviceRepository`    |

## Code Generation Rules

### Architecture Constraints

- Only public API is `CommunicationCoreService` — do not add REST Controllers
- Scheduling logic is owned by this library — do not delegate to consumer project
- New vendor Adapters MUST update `AdapterFactory` registry and SPEC description

### Interface Change Rules

- Any `CommunicationCoreService` public method signature change MUST update SPEC Changelog in the same PR

## GenAI Documentation Navigation

| What you want to do               | Read this first                      |
| --------------------------------- | ------------------------------------ |
| Understand system components      | docs/analysis/SA-001                 |
| Look up public interface contract | docs/spec/SPEC-001 (Source of Truth) |
| Integration with main backend     | docs/INTEGRATION.md                  |

## Common Commands

| Command                         | Description            |
| ------------------------------- | ---------------------- |
| `./gradlew build`               | Build and run tests    |
| `./gradlew test`                | Run tests only         |
| `./gradlew publishToMavenLocal` | Publish to local Maven |

## Related Projects

| Project             | Relationship     | Notes                                            |
| ------------------- | ---------------- | ------------------------------------------------ |
| `logistics-api-hub` | Library consumer | Imports this library via Gradle local dependency |

## Documentation Maintenance Reminders

- **`CommunicationCoreService` interface change**: update SPEC Changelog
- **Integration step change**: update `docs/INTEGRATION.md`
- **Architecture decision**: write new ADR
- Docs governance rules: `docs/README.md`
