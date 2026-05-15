# ZeroSpec

> **ZeroSpec is a zero-dependency Markdown baseline that gives AI coding agents the project context they need — architecture rules, module navigation, and source of truth — before they start editing files.**

> **🌐 [台灣正體中文版](README.zh-TW.md)**

**Version**: v0.5.0
**Status**: Active

---

## What Problem Does ZeroSpec Solve?

If you've shipped features with Copilot, Cursor, Claude Code, or similar tools on a real codebase, these situations are familiar:

- The agent edits the wrong module because navigation docs have drifted from the actual structure
- The code lands in the right file but quietly breaks architecture rules scattered across several documents
- The response references a deprecated API, an old version, or an interface that is no longer the source of truth
- You're maintaining separate guidance for each tool, and they are slowly diverging

In many teams, these are less pure model failures and more context gaps — the project knowledge agents need is not in places they can reliably find.

ZeroSpec puts that context in a predictable set of files before the agent starts working. Plain Markdown, no new runtime, no platform lock-in.

## Why This Matters

These are not edge cases.

- In the [Stack Overflow Developer Survey 2025](https://survey.stackoverflow.co/2025/ai/), 66% said a major frustration is getting answers that are almost right, but not quite, and 45.2% said debugging AI-generated code is more time-consuming.
- In METR's [2025 randomized controlled trial](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/) of experienced open-source developers, participants completed tasks 19% slower when AI tools were allowed in that specific setting.
- [AGENTS.md](https://agents.md/) has become a common open guidance-file convention across AI-assisted development workflows, which suggests the ecosystem is converging on predictable context files rather than tool-specific magic.

Those sources do not prove that every team needs ZeroSpec. They do support a simpler point: context quality is a practical part of AI-assisted development, not just a prompting preference.

As Simon Willison notes in [Hallucinations in code are the least dangerous form of LLM mistakes](https://simonwillison.net/2025/Mar/2/hallucinations-in-code/), giving models better context is often more useful than treating every failure as a model-selection problem.

Anthropic's engineering team frames this broadly as [Context Engineering](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents) — the discipline of curating the smallest set of high-signal tokens that lets an agent work reliably. ZeroSpec is one practical implementation of that principle at the repo level.

## What ZeroSpec Does

ZeroSpec standardizes the minimum repo context agents usually need before they start coding:

Think of it as a pre-coding brief for AI agents: not a workflow engine, but a concise map of where things are and which rules are non-negotiable.

- Project summary and architecture boundaries
- Version source of truth
- Domain-to-code navigation
- Documentation governance rules

It builds on the open [AGENTS.md](https://agents.md/) format instead of inventing a proprietary one, and keeps everything in plain Markdown so teams can review and update it with normal code review practices.

From an SDD workflow perspective, ZeroSpec is a lightweight Layer 0 baseline: API changes trigger SPEC updates, architecture decisions trigger ADRs, and system snapshots trigger SA updates.

## When to Use ZeroSpec

| Use ZeroSpec when                                                      | Skip ZeroSpec when                                                            |
| ---------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| You need a stable, low-maintenance agent guidance baseline             | The repo is throwaway (POC, tutorial, one-off script)                         |
| You want zero dependency and no platform lock-in                       | The project is content-first (notes/notebooks) with no long-lived codebase    |
| Your team wants docs that evolve with delivery, not one-time artifacts | Architecture and team rules are still too unstable to define hard constraints |
| You need Layer 0 context readiness before Layer 1 workflow tools       | A Layer 1 tool already provides sufficient context injection for your team    |

## Layer 0 Positioning

ZeroSpec is **Layer 0 (Context Readiness)**, not an execution engine:

| Layer       | Responsibility                                                | Representative Tools |
| ----------- | ------------------------------------------------------------- | -------------------- |
| **Layer 0** | Make the project "AI-readable" — constraints, navigation, SoT | **ZeroSpec**         |
| **Layer 1** | Make AI "execute by process" — workflows, phase gates         | OpenSpec, Spec Kit   |

ZeroSpec artifacts are optimized for pre-task understanding. Layer 1 specs are optimized for workflow execution. They solve different problems and can coexist.

### How ZeroSpec Relates to SDD

- **SDD-like**: ZeroSpec keeps SPEC / ADR / SA alive through event triggers.
- **Not full workflow SDD**: ZeroSpec does not enforce phase gates, approvals, or execution states.
- **Practical shorthand**: ZeroSpec is an **SDD-ready Layer 0 baseline**. Add Layer 1 tooling when you need strict process orchestration.

### Good Fit for Light SDD

- Start here if you want SDD-style guardrails without adopting a full workflow engine on day 1.
- ZeroSpec gives you the lightweight baseline first: `AGENTS.md`, `docs/README.md`, and event-triggered SPEC / ADR / SA updates.
- If later you need stricter workflows, approvals, or phase gates, keep ZeroSpec as Layer 0 and run OpenSpec or Spec Kit alongside it as Layer 1.

## Content Model

ZeroSpec separates ownership between AI and humans. See [GUIDE.md Section 0](GUIDE.md#0-what-is-zerospec).

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

## Quick Start

### Before You Begin

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

> **GitHub Copilot users**: Copilot may not auto-read `AGENTS.md` by default. Use `@AGENTS.md` reference or create `.github/copilot-instructions.md`. See [DAILY-USAGE Section 2.2](DAILY-USAGE.md#22-coexistence-of-copilot-instructionsmd-and-agentsmd).

> **Non-English projects**: Prompt Packs are in English, but output language auto-detects from your project. If your repo is English-first yet you want zh-TW (or another locale) output, see [DAILY-USAGE Section 5.8](DAILY-USAGE.md#58-specifying-output-language-eg-zh-tw).

### Quick Path

For the full walkthrough, jump to [Getting Started](#getting-started-under-30-minutes).

1. Open Agent mode in your target project and paste [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md).
2. In the same conversation, paste [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md).
3. Review the generated `AGENTS.md` and `docs/README.md`, then validate with one small real task.

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

| Trigger Event                                               | Prompt Pack / Method                                                                                                     |
| ----------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| API added/changed                                           | [`prompts/SPEC.md`](prompts/SPEC.md)                                                                                     |
| Architecture decision                                       | [`prompts/ADR.md`](prompts/ADR.md)                                                                                       |
| System snapshot needed                                      | [`prompts/SA.md`](prompts/SA.md)                                                                                         |
| Project evolved, sync docs                                  | [`prompts/UPDATE.md`](prompts/UPDATE.md)                                                                                 |
| Verify existing SPECs still match code                      | [`prompts/DRIFT.md`](prompts/DRIFT.md)                                                                                   |
| Need platform pointer setup (optional)                      | Use [`templates/pointers/`](templates/pointers/) for Copilot/Claude/Cursor/Windsurf; JetBrains uses `AGENTS.md` directly |
| Want one-click trigger shortcuts (optional VS Code adapter) | Copy [`templates/prompts/*.prompt.md`](templates/prompts/) to your project's `.github/prompts/`                          |
| None of the above                                           | **Create nothing**                                                                                                       |

> `templates/prompts/*.prompt.md` is an optional shortcut layer for VS Code prompt UIs. ZeroSpec core remains tool-agnostic: Cursor, Claude Code, Windsurf, and JetBrains users can use the same Prompt Packs via copy-paste/bookmark/symlink.

Monthly quick review + quarterly full review recommended. Details in [GUIDE.md Section 7](GUIDE.md#7-adoption-and-continuous-operation).

If you want model-selection notes, multilingual workflow tips, or day-to-day operating patterns, keep the README short and use [DAILY-USAGE.md](DAILY-USAGE.md).

### Verification

ZeroSpec includes cross-platform verification scripts.

These scripts verify the ZeroSpec repository itself. They do not validate the `AGENTS.md` or `docs/README.md` generated inside your target project.

The checks include:

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
│   ├── ISSUE_TEMPLATE/           ← Issue templates + chooser config
│   ├── pull_request_template.md  ← PR description template
│   └── workflows/
│       └── verify-zerospec.yml   ← PR / push auto-verify (minimal CI)
├── AGENTS.md                    ← AI Navigation Guide (for contributors working on ZeroSpec itself)
├── CONTRIBUTING.md              ← Contribution guide
├── CODE_OF_CONDUCT.md           ← Community behavior expectations
├── SECURITY.md                  ← Private vulnerability reporting policy
├── SUPPORT.md                   ← Where to ask questions, report bugs, and request changes
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
│   ├── DRIFT.md                 ← Trigger: verify existing SPECs still match code (no files written)
│   └── UPDATE.md                ← Ongoing: update AGENTS.md + docs/README.md
├── templates/
│   ├── ADR-TEMPLATE.md          ← Ready-to-use ADR template
│   ├── SPEC-TEMPLATE.md         ← Ready-to-use SPEC template
│   ├── SA-TEMPLATE.md           ← Ready-to-use SA template
│   ├── DOCS-README-TEMPLATE.md  ← docs/README.md governance template
│   ├── SPEC-INDEX-TEMPLATE.md   ← docs/spec/README.md sub-index template (threshold-triggered)
│   ├── prompts/                 ← Optional: VS Code Prompt Files adapter (copy to .github/prompts/)
│   │   └── zerospec-drift.prompt.md ← DRIFT Prompt VS Code adapter
│   └── pointers/                ← Optional: platform pointer templates (Copilot / Claude Code / Cursor / Windsurf; JetBrains uses AGENTS.md directly)
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

## Suggested Adoption Metrics

These are practical observation targets, not guarantees or SLAs. Measure them over real adoption windows and adjust for repo size and team workflow.

| Metric                                 | Target   |
| -------------------------------------- | -------- |
| Day-1 human effort (small/medium repo) | ≤ 30 min |
| Human-written content share (Tier C)   | ≤ 20%    |
| First-round merge rate                 | ≥ 70%    |
| Hard rule violation rate               | ≤ 10%    |
| SPEC draft coverage after API change   | ≥ 90%    |

---

## Roadmap

- Improve compatibility and Prompt stability across mainstream GenAI agents
- Keep cross-project guidance, governance, and navigation patterns readable
- Add CI, acceptance, and measurement templates where real usage justifies them
- Clarify Layer 0 → Layer 1 integration guidance over time

## Contributing

PRs welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
Community expectations and reporting paths are documented in [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md), [SECURITY.md](SECURITY.md), and [SUPPORT.md](SUPPORT.md).

---

## Further Reading

- [GUIDE.md](GUIDE.md) — Detailed methodology, drift prevention, and continuous operating guidance
- [DAILY-USAGE.md](DAILY-USAGE.md) — Day-2+ user guide (daily ops, IDE config, scenario playbooks)
- [anti-patterns.md](anti-patterns.md) — Common mistakes and fixes
- [Why I Built ZeroSpec (Author's Blog, zh-TW)](https://coreynote.life/posts/2026/04/zerospec/) — Background story and motivation

---

## References

1. [Stack Overflow Developer Survey 2024: AI](https://survey.stackoverflow.co/2024/ai/)
2. [Stack Overflow Developer Survey 2025: AI](https://survey.stackoverflow.co/2025/ai/)
3. [METR: Measuring the Impact of Early-2025 AI on Experienced Open-Source Developer Productivity](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)
4. [AGENTS.md](https://agents.md/)
5. [Simon Willison: Hallucinations in code are the least dangerous form of LLM mistakes](https://simonwillison.net/2025/Mar/2/hallucinations-in-code/)
6. [Anthropic Engineering: Effective Context Engineering for AI Agents](https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents)
7. [GitHub Blog: 5 Tips for Writing Better Custom Instructions for Copilot](https://github.blog/ai-and-ml/github-copilot/5-tips-for-writing-better-custom-instructions-for-copilot/)

---

## License

MIT License — see [LICENSE](LICENSE)
