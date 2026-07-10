# AGENTS.md — etl-pipeline-core AI Navigation Guide

> Primary entry point for GenAI Agents. Read before starting any task.

## Project Summary

**ETL Pipeline Core Library** — Encapsulates ETL pipeline task scheduling, retry mechanisms, and multi-source Adapter integration. Delivered as a **Python Package** installed into the main application service.

- **Tech Stack**: Python 3.12 + SQLAlchemy 2.0 + APScheduler 3.10
- **Root Package**: `etl_pipeline_core` (follow actual `src/` structure)
- **Architecture**: Library — no standalone HTTP API; initialized via config and injected into main app
- **Public API**: Only `PipelineService` is public — all other modules are internal
- **Version source of truth**: dependency versions per `pyproject.toml`

## Quick Constraints

1. `PipelineService` is the only public API — MUST NOT add HTTP endpoints (no FastAPI / Flask routes)
2. Scheduling logic (`TaskScheduler`) is owned by this library — MUST NOT move to consumer application
3. Adding a new Adapter MUST update `AdapterFactory` registry AND SPEC

## Domain-to-Code Map

| Domain              | Key Module / Class                              |
| ------------------- | ----------------------------------------------- |
| **Public API**      | `service/pipeline_service.py`                   |
| **Task Scheduling** | `scheduler/task_scheduler.py`                   |
| **Source Adapter**  | `adapter/base_adapter.py`, `adapter/factory.py` |
| **Retry & Backoff** | `retry/retry_handler.py`, `retry/backoff.py`    |
| **Data Access**     | `repository/task_repository.py`                 |

## Code Generation Rules

### Architecture Constraints

- **No HTTP endpoints**: Only public API is `PipelineService` — do not add FastAPI / Flask routes
- **Scheduling logic is library-owned**: `TaskScheduler` is managed internally — do not delegate to consumer
- **New Adapter MUST update** `AdapterFactory` registry AND SPEC interface description

### Typing & Style

- Use Python Type Hints (PEP 484) on all public function / method parameters and return values
- Use Pydantic v2 for DTO / Config models
- Follow Ruff for linting and code formatting

### Interface Change Rules

- Any `PipelineService` public method signature change MUST update SPEC Changelog in the same PR

## GenAI Documentation Navigation

| What you want to do               | Read this first                      |
| --------------------------------- | ------------------------------------ |
| Understand system components      | docs/analysis/SA-001                 |
| Look up public interface contract | docs/spec/SPEC-001 (Source of Truth) |
| Integration with main application | docs/INTEGRATION.md                  |

## Common Commands

| Command            | Description                     |
| ------------------ | ------------------------------- |
| `make test`        | Run tests (pytest)              |
| `make lint`        | Ruff formatting & static checks |
| `pip install -e .` | Local development install       |
| `make build`       | Build package                   |

## Related Projects

| Project    | Relationship     | Notes                        |
| ---------- | ---------------- | ---------------------------- |
| `main-api` | Package consumer | Imports this library via pip |

## Documentation Maintenance Reminders

- **`PipelineService` interface change**: update SPEC Changelog
- **Integration step change**: update `docs/INTEGRATION.md`
- **New architecture decision**: write new ADR
- Docs governance rules: `docs/README.md`

## Post-Edit Self-Check

Before declaring work complete:
1. List changed files from the current diff.
2. Cross-reference every changed file with the Code-to-Docs Map above.
3. For each candidate doc, state `Update needed` or `No update needed` with a reason.
4. Apply Contract Ownership: update an in-scope narrative SPEC when required; otherwise state why the machine contract or no document update is sufficient.
5. Run `make test` and `make lint` to confirm no regressions.

**Forcing Function**: AI agents MUST append a `### Docs Impact` block at the end of any response containing code changes, listing: (a) affected `docs/spec/` files and their update status; (b) reason if no update is needed.
