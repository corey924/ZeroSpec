# ZeroSpec

> **ZeroSpec is a zero-dependency Markdown framework that helps AI agents understand your repository structure, rules, and source of truth before coding.**

> **🌐 [台灣正體中文版](README.zh-TW.md)**

**Version**: v0.4
**Status**: Active

---

## What is ZeroSpec?

ZeroSpec is a zero-dependency, pure-Markdown project baseline that organizes the context AI Agents actually need:

- Project summary
- Architecture constraints
- Version source of truth
- Module navigation
- Docs governance rules

Most AI Coding Agents read a guidance file (e.g. `AGENTS.md`) at the project root before starting a task. If that file lacks structure, is outdated, or buries critical rules in noise, typical failures include:

- Targeting the wrong module or directory
- Generating code that violates layer separation
- Referencing stale versions, deprecated paths, or nonexistent interfaces

ZeroSpec's goal: **Make your project instantly readable by AI Agents and consistently enforce team rules — at minimal maintenance cost.**

**Good fit**:

- You want your project AI-readable and long-term maintainable
- You prefer no extra CLI, framework, or platform lock-in
- You need docs that keep pace with development — not a one-time artifact

**Not a fit** (skip ZeroSpec):

- **Throwaway scripts / POC / tutorials** — no long-term maintenance; AGENTS.md overhead exceeds benefit
- **Research / notebook repos** — content-oriented projects need only a README
- **Architecture still in flux** — wait until you can write at least 3 stable hard rules
- **Already using a Layer 1 SDD tool with its own context injection** — ZeroSpec's core value is Agent auto-read; if already solved elsewhere, adding ZeroSpec increases maintenance burden

### Core Features

- **Zero dependency** — no tools, CLI, or runtime to install
- **Low human effort** — AI scans the repo and drafts; humans review key decisions only
- **Sustainable operation** — not a Day-1 artifact but ongoing update + review cycles
- **Event-triggered expansion** — files created only when needed, no pre-built empty shells
- **Aligned with AGENTS.md open standard** — builds on [AGENTS.md](https://agents.md/) (Agentic AI Foundation / Linux Foundation), adding SDD governance and on-demand document creation
- **Cross-agent compatible** — works with GitHub Copilot, Codex, Claude, Gemini, Cursor, and more
- **Composable** — serves as Layer 0 for higher-level workflow or spec management tools

### Layer 0 Positioning

ZeroSpec is **Layer 0 (Context Readiness)**, not an execution engine:

| Layer       | Responsibility                                                | Representative Tools |
| ----------- | ------------------------------------------------------------- | -------------------- |
| **Layer 0** | Make the project "AI-readable" — constraints, navigation, SoT | **ZeroSpec**         |
| **Layer 1** | Make AI "execute by process" — workflows, phase gates         | OpenSpec, SpecKit    |

ZeroSpec SPECs = AI-readable interface contracts & business context (read before task). Layer 1 specs = execution flow specs (drive workflow engines). They serve different purposes and coexist without overlap.

### Content Generation: Three-Tier Model

ZeroSpec's core design separates **who writes what**. See [GUIDE.md Section 0](GUIDE.md#0-what-is-zerospec).

| Tier                             | Owner                      | Human Effort           |
| -------------------------------- | -------------------------- | ---------------------- |
| **(A) AI auto-generated**        | AI scans repo              | Zero                   |
| **(B) AI drafts, human reviews** | AI infers + human confirms | ~5 min review          |
| **(C) Human must provide**       | Cannot infer from code     | Answer a few questions |

---

## Example Output

After running Prompt Packs, AI generates navigation files like this for your project:

````markdown
# AGENTS.md — my-backend AI Navigation Guide

## Project Summary
**Inventory Management API** — .NET 10 (C#) + ASP.NET Core + EF Core + PostgreSQL 16
Base Namespace: `MyApp.Api`, `MyApp.Service` (follow Solution structure as source of truth)
Version source of truth: package versions per `.csproj`; .NET SDK per `global.json`

## Quick Constraints
1. Controllers handle HTTP request/response only — no business logic
2. Controllers MUST NOT access DbContext directly
3. New API path format: `/api/v1/{resource}`

## Domain-to-Code Map
| Domain             | Controller          | Core Service      |
| ------------------ | ------------------- | ----------------- |
| Product Management | `ProductController` | `IProductService` |
| Authentication     | `AuthController`    | `IAuthService`    |

## Code Generation Rules
- Controllers handle HTTP request/response only; orchestration, validation, and transaction logic belong in Service (violations rejected in PR review)
- Controllers MUST NOT access DbContext directly; all data access goes through Repository/Service abstraction
- New API path format: `/api/v1/{resource}`; avoid verb-based paths and multi-version mixing

## Common Commands
| Command        | Description   |
| -------------- | ------------- |
| `dotnet build` | Build project |
| `dotnet test`  | Run tests     |
````

Full examples in [`examples/`](examples/): .NET dual-API, Java Library, Python Package, React Monorepo, and Day-1 minimal output.

---

## 30-Second Quick Start

For experienced users — detailed instructions in [Getting Started](#getting-started-under-30-minutes):

1. Open Agent mode at your target project → paste [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md) → get a structured analysis (no files written)
2. Same conversation → paste [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md) → answer a few team decisions → generates `AGENTS.md` + `docs/README.md`
3. Run a real small task to verify the Agent follows your architecture constraints

> **GitHub Copilot users**: Copilot does not auto-read `AGENTS.md` by default. Use `@AGENTS.md` reference or create `.github/copilot-instructions.md`. See [DAILY-USAGE Section 2.2](DAILY-USAGE.md#22-coexistence-of-copilot-instructionsmd-and-agentsmd).

---

## Prerequisites

**Target Project**
- [ ] Cloned locally: `git clone <your-repo-url>`
- [ ] Opened at the **project root** in your IDE

> ZeroSpec lives separately — **it does NOT go into your target repo.**
> After bootstrap, your repo gains only `AGENTS.md` and `docs/README.md`.

**AI Agent** (pick one — must have repo read/write capability)

| Tool                     | Activation                                           |
| ------------------------ | ---------------------------------------------------- |
| GitHub Copilot (VS Code) | Switch to **Agent mode** (confirm `#codebase` works) |
| Cursor                   | Use **Composer — Agent** (not Chat mode)             |
| Claude Code              | Read/write enabled by default                        |
| Windsurf                 | Use **Cascade mode**                                 |
| JetBrains AI Assistant   | Enable **Attach project files**                      |

> Not supported: ChatGPT / Claude.ai web (cannot access local repos).
>
> For steps that write files, avoid pure Plan mode. Analysis-only steps like `INIT-SCAN` can use Plan mode where supported.

**Recommended LLM Models** (series names only — pick your plan's version)

| Task Type                                 | Recommended Series               | Notes                                 |
| ----------------------------------------- | -------------------------------- | ------------------------------------- |
| Daily coding (CRUD, refactor, bug fix)    | Claude Sonnet / GPT / Gemini Pro | Speed–quality balance, daily default  |
| Architecture analysis (INIT-SCAN / SA)    | Claude Opus / o-series           | Long context deep reasoning           |
| Heavy code generation (INIT-BUILD / SPEC) | Claude Sonnet / GPT-Codex        | Code-output oriented, repo read/write |
| Quick lookup, lightweight tasks           | Gemini Flash                     | Low latency, fast response            |

> Choose models with long context windows and repo read/write support.

---

## Getting Started (Under 30 Minutes)

### Step 1: Analyze Current State (INIT-SCAN)

1. Open [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md), copy the Prompt
2. Switch IDE to **target project root**, open **Agent mode**
3. Paste Prompt → AI scans repo → produces structured analysis (no files written)
4. Confirm results, answer 2–3 clarification questions (~5–10 min)

### Step 2: Build Documents (INIT-BUILD)

1. Open [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md), copy the Prompt
2. Paste in the same conversation → AI asks team decision questions (with suggested defaults)
3. Answer or confirm → AI generates `AGENTS.md` + `docs/README.md`
4. Review AI-drafted domain-to-code map and naming conventions → confirm write
5. AI provides a **status assessment** (scan summary + recommended first SPEC + next steps)

### Step 3: Verify

Run a real small task (e.g. add an API) with the new `AGENTS.md`. Confirm the Agent uses correct Namespace/Package and follows architecture constraints.

> **Brownfield projects** (large existing API surface): Before Step 4, run **SA Prompt** for a system architecture snapshot, then prioritize recently-changed APIs for the first SPEC.
> Full backfill strategy (priority tiers + As-Is principle) in [GUIDE.md Section 7](GUIDE.md#7-adoption-and-continuous-operation).

### Step 4: Create First SPEC

Based on AI's Step 2 recommendations, open [`prompts/SPEC.md`](prompts/SPEC.md) to create your first SPEC.
This bridges the gap from "one-time output" to **continuous SDD operation**.

### After Adoption

| Trigger Event              | Prompt Pack                              |
| -------------------------- | ---------------------------------------- |
| API added/changed          | [`prompts/SPEC.md`](prompts/SPEC.md)     |
| Architecture decision      | [`prompts/ADR.md`](prompts/ADR.md)       |
| System snapshot needed     | [`prompts/SA.md`](prompts/SA.md)         |
| Project evolved, sync docs | [`prompts/UPDATE.md`](prompts/UPDATE.md) |
| None of the above          | **Create nothing**                       |

Monthly quick review + quarterly full review recommended. Details in [GUIDE.md Section 7](GUIDE.md#7-adoption-and-continuous-operation).

### Verification

ZeroSpec includes cross-platform verification scripts that check:

- Core Prompt files exist (INIT-SCAN / INIT-BUILD / UPDATE)
- SPEC/ADR/SA contain prerequisites
- Templates and Day-1 examples are present

Run:

- macOS / Linux: `bash scripts/verify-zerospec.sh`
- Windows (PowerShell): `powershell -ExecutionPolicy Bypass -File .\scripts\verify-zerospec.ps1`

Scripts output PASS/FAIL summary. Any failure returns non-zero exit code — suitable for manual checks or CI.

Minimal CI template (GitHub Actions): `.github/workflows/verify-zerospec.yml`

---

## Repo Structure

```
zerospec/
├── .github/
│   ├── pull_request_template.md  ← PR description template
│   └── workflows/
│       └── verify-zerospec.yml   ← PR / push auto-verify (minimal CI)
├── CONTRIBUTING.md              ← Contribution guide
├── README.md                    ← You are reading this
├── GUIDE.md                     ← Full methodology (design, drift prevention, operations, evidence)
├── DAILY-USAGE.md               ← Day-2+ user guide (daily ops, IDE config, scenarios)
├── prompts/
│   ├── INIT-SCAN.md             ← Bootstrap step 1: analyze (no files written)
│   ├── INIT-BUILD.md            ← Bootstrap step 2: generate AGENTS.md + docs/README.md
│   ├── SPEC.md                  ← Trigger: API change → produce SPEC
│   ├── ADR.md                   ← Trigger: architecture decision → produce ADR
│   ├── SA.md                    ← Trigger: system snapshot → produce SA
│   ├── AUDIT.md                 ← Trigger: audit AGENTS.md quality (no files written)
│   └── UPDATE.md                ← Ongoing: update AGENTS.md + docs/README.md
├── templates/
│   ├── ADR-TEMPLATE.md          ← Ready-to-use ADR template
│   ├── SPEC-TEMPLATE.md         ← Ready-to-use SPEC template
│   ├── SA-TEMPLATE.md           ← Ready-to-use SA template
│   └── DOCS-README-TEMPLATE.md  ← docs/README.md governance template
├── scripts/
│   ├── verify-zerospec.sh       ← macOS/Linux verification script
│   └── verify-zerospec.ps1      ← Windows PowerShell verification script
├── examples/
│   ├── minimal-day1/            ← Day-1 minimal output (starting point)
│   ├── dotnet-dual-api/         ← .NET dual API Host example
│   ├── java-library/            ← Java Library example
│   ├── python-package/          ← Python Package example
│   └── react-nx-monorepo/       ← React + Nx Monorepo frontend example
├── anti-patterns.md             ← Anti-pattern catalog
├── CHANGELOG.md
└── LICENSE
```

---

## Acceptance Metrics

| Metric                               | Target   |
| ------------------------------------ | -------- |
| Day-1 human effort                   | ≤ 30 min |
| Human-written content share (Tier C) | ≤ 20%    |
| First-round merge rate               | ≥ 70%    |
| Hard rule violation rate             | ≤ 10%    |
| SPEC draft coverage after API change | ≥ 90%    |

---

## Roadmap

- Improve compatibility and Prompt stability across mainstream GenAI Agents
- Strengthen cross-project consistency, docs governance, and navigation readability
- Gradually add CI, acceptance, and measurement templates based on real usage

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Further Reading

- [GUIDE.md](GUIDE.md) — Full methodology (design principles, drift prevention, continuous operation, industry evidence)
- [DAILY-USAGE.md](DAILY-USAGE.md) — Day-2+ user guide (daily ops, IDE config, scenario playbooks)
- [anti-patterns.md](anti-patterns.md) — Common mistakes and fixes

---

## License

MIT License — see [LICENSE](LICENSE)
