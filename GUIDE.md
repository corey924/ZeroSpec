# ZeroSpec Methodology Guide

> **Zero-dependency Markdown baseline for AI-readable repositories.**
> Give AI coding agents a clear pre-coding brief: where code lives, which rules matter, and which files are source of truth.

> Derived from: [GUIDE.zh-TW.md](GUIDE.zh-TW.md) @ commit 96d51d5 | Last sync: 2026-04-23

> **🌐 [台灣正體中文版](GUIDE.zh-TW.md)**

**Version**: v0.4 — 2026-04-23
**Audience**: Engineering teams using GenAI Agents (GitHub Copilot / Codex / Claude / Gemini / Cursor)
**Validation**: Verified across backend (.NET C# / Python), frontend (React + TypeScript), and shared library ecosystems

---

## Who Should Read This Guide?

- Read this guide if you are maintaining `AGENTS.md`, designing team conventions, or deciding how ZeroSpec fits your engineering workflow.
- If you are new to ZeroSpec, start with [README.md](README.md) first, then return here for methodology and long-term operating guidance.
- If you mainly want day-to-day usage patterns, prefer [DAILY-USAGE.md](DAILY-USAGE.md).

---

## Table of Contents

0. [What is ZeroSpec](#0-what-is-zerospec)
1. [Why ZeroSpec](#1-why-zerospec)
2. [Core Architecture: Dual-File Entry Model](#2-core-architecture-dual-file-entry-model)
3. [AGENTS.md Design Principles](#3-agentsmd-design-principles)
4. [Document Layers and Event Triggers](#4-document-layers-and-event-triggers)
5. [Drift Prevention](#5-drift-prevention)
6. [Anti-Patterns](#6-anti-patterns)
7. [Adoption and Continuous Operation](#7-adoption-and-continuous-operation)
8. [Cross-Project Consistency](#8-cross-project-consistency)
9. [Industry Evidence and References](#9-industry-evidence-and-references)

---

## 0. What is ZeroSpec

ZeroSpec is a zero-dependency, pure-Markdown AI readability framework. It operates as **Layer 0 (Context Readiness)**.

Think of ZeroSpec as the project's pre-coding brief for AI agents: not a workflow engine, but the minimum context handoff before implementation starts.

### Layer 0 vs Layer 1

| Layer       | Responsibility                                                | Representative Tools |
| ----------- | ------------------------------------------------------------- | -------------------- |
| **Layer 0** | Make the project "AI-readable" — constraints, navigation, SoT | **ZeroSpec**         |
| **Layer 1** | Make AI "execute by process" — workflows, phase gates         | OpenSpec, Spec Kit   |

ZeroSpec is not bound to any IDE, agent platform, or language. Its sole function: **ensure AI has precise project context before starting any task.**

From an SDD workflow perspective, ZeroSpec is a lightweight Layer 0 baseline: API changes trigger SPEC updates, architecture decisions trigger ADRs, and system snapshots trigger SA updates.

### How ZeroSpec Relates to SDD

- **SDD-like**: ZeroSpec keeps SPEC / ADR / SA alive through event triggers.
- **Not full workflow SDD**: ZeroSpec does not enforce phase gates, approvals, or execution states.
- **Practical shorthand**: ZeroSpec is an **SDD-ready Layer 0 baseline**. Add Layer 1 tooling when you need strict process orchestration.

#### Long-Term Integration with Layer 1

ZeroSpec works standalone or integrates with Layer 1 tools as the team matures:

| Stage                      | Timeline  | Approach                                                                           | Layer 1 Tool        |
| -------------------------- | --------- | ---------------------------------------------------------------------------------- | ------------------- |
| **Stage 1: Build habits**  | Month 1–3 | AGENTS.md + event-triggered SPEC updates (human review at PR time)                 | Not needed          |
| **Stage 2: Add CI gates**  | Month 3–6 | PR template with SPEC Checklist; simple CI warns when Controller changes lack SPEC | Not needed          |
| **Stage 3: Layer 1 merge** | 6+ months | ZeroSpec SPEC as Layer 1 input; Layer 1 adds execution phases and approval gates   | OpenSpec / Spec Kit |

**Stage 3 trigger signals**: cross-team spec approval flows, mandatory phase gates, or automated acceptance conditions. Most small-to-mid teams stay at Stage 2.

**Responsibility definition**: ZeroSpec SPEC (`docs/spec/SPEC-xxx.md`) = interface contracts & business context (for Agent reading). Layer 1 spec = execution flow specs (driving workflow engines). Both coexist without merging.

### Content Generation: Three-Tier Model

ZeroSpec's core innovation: separate **who writes** from **whether to write**.

| Tier                             | Owner                      | Content Examples                                          | Human Effort           |
| -------------------------------- | -------------------------- | --------------------------------------------------------- | ---------------------- |
| **(A) AI auto-generated**        | AI scans repo              | Tech stack, version SoT, directory structure, build cmds  | Zero                   |
| **(B) AI drafts, human reviews** | AI infers + human confirms | Domain-to-code map, layer rules, naming conventions       | ~5 min review          |
| **(C) Human must provide**       | Cannot infer from code     | Project summary, hard rules, deploy strategy, auth format | Answer a few questions |

Only Tier C requires human authoring (~5–8 team decisions). Everything else is AI-generated or AI-drafted for review.

### When NOT to Use ZeroSpec

| Scenario                                                        | Reason                                                                                                              | Alternative                                          |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------- |
| Throwaway scripts / POC / demo repos                            | No long-term maintenance; AGENTS.md overhead > benefit                                                              | README summary + inline comments                     |
| Research / notebook repos                                       | No stable "hard rules" to write; Tier C fields mostly bend                                                          | README + notebook-level summaries                    |
| Architecture in major flux                                      | Agent following outdated rules causes more harm; AGENTS.md value depends on rule stability                          | Stabilize architecture first; use PR review as guard |
| Already using Layer 1 SDD with context injection                | ZeroSpec's core value is "Agent auto-reads guidance file"; if already solved, adding ZeroSpec increases maintenance | Evaluate Layer 1 tool's context injection coverage   |
| Solo short-term project where AI accuracy is already sufficient | Marginal quality improvement < setup time                                                                           | Monitor; adopt when Agent starts making mistakes     |

**One-line test**: If you cannot write at least 3 stable rules that "would cause PR rejection if violated," the resulting AGENTS.md will be an empty shell — wait for architecture maturity.

#### Quick Decision Flow

1. **Does your team use AI coding agents?** → No → skip ZeroSpec for now; revisit later.
2. **Can you write at least 3 rules that would cause PR rejection if violated?** → No → stabilize architecture first; ZeroSpec shell with no real rules adds no value.
3. **Is this an existing project with a large API surface?** → Yes → **Brownfield path**: run INIT-SCAN + INIT-BUILD, then SA Prompt, then backfill priority SPECs gradually (see [Step 3.5](#step-35-choose-next-step-by-project-type)).
4. **Is this a new or small project?** → Yes → **Greenfield path**: run INIT-SCAN + INIT-BUILD, then let the first real API trigger the first SPEC naturally.
5. **Still unsure?** → Start with the [30-Second Path in README.md](README.md#30-second-path). If the generated `AGENTS.md` feels useful after one real task, you're on the right track.

---

## 1. Why ZeroSpec

When properly configured, AI Coding Agents often read guidance files (e.g. `AGENTS.md`, `.cursor/rules`) at the project root before generating code. If these files are unstructured, outdated, or lack critical rules, agents commonly show behaviors that reduce output quality:

- **Inefficient search**: Spend extra tokens finding base packages or path aliases
- **Architectural violations**: Put business logic in Controllers or use the wrong state management approach
- **Reference errors**: Cite outdated versions or nonexistent APIs
- **Context dilution**: Spend attention on long human onboarding tutorials and future roadmaps

These patterns are not inevitable, but they happen often enough in real projects that structured guidance is usually worth maintaining.

ZeroSpec's goal: **deliver project-specific constraints in a format that agents can follow more reliably, while still leaving review and judgment to humans.**

---

## 2. Core Architecture: Dual-File Entry Model

```
project-root/
├── AGENTS.md          ← AI's "first file": project summary + navigation + code generation rules
├── docs/
│   └── README.md      ← Docs governance center (created when 2nd doc appears)
├── *.csproj / package.json / build.gradle  ← Version source of truth
└── src/               ← Actual source code
```

| File             | Read Timing                 | Content Scope                                                                      |
| ---------------- | --------------------------- | ---------------------------------------------------------------------------------- |
| `AGENTS.md`      | **Before every task**       | "How to write code" — tech stack, constraints, conventions, domain-to-code map     |
| `docs/README.md` | **When handling doc tasks** | "How to manage docs" — layer rules, SoT definitions, ADR triggers, naming patterns |

This separation ensures AI does not load docs governance rules during daily coding, saving context.

> **ZeroSpec principle**: Create both `AGENTS.md` and `docs/README.md` on Day-1.

### 2.1 Scope and Environment Differences

The same document strategy may have minor differences across agent environments (IDE-embedded, Cloud Agent, CLI Agent):

- Guidance file read priority (`AGENTS.md`, `.github/copilot-instructions.md`, platform equivalents)
- Whether the agent can auto-read cross-folder or cross-repo documents
- Available tool set (terminal, testing, web queries)

Keep a "minimum viable spec" in every project: architecture constraints, build/test commands, docs sync triggers. This ensures consistent delivery quality regardless of agent platform.

### Optional Note: Model Selection

Model choice can matter, but it is separate from ZeroSpec adoption. If you are also choosing models for specific tasks, these broad tendencies can help. For more day-to-day usage patterns, see [DAILY-USAGE.md](DAILY-USAGE.md).

| Task Type                                 | Recommended Series               | Rationale                                                     |
| ----------------------------------------- | -------------------------------- | ------------------------------------------------------------- |
| Daily coding (CRUD, refactor, bug fix)    | Claude Sonnet / GPT / Gemini Pro | Speed–quality balance, manageable token cost                  |
| Architecture analysis (INIT-SCAN / SA)    | Claude Opus / o-series           | Long context + deep reasoning for global analysis             |
| Heavy code generation (INIT-BUILD / SPEC) | Claude Sonnet / GPT-Codex        | Code-output oriented, repo read/write, cross-file consistency |
| Quick lookup, lightweight tasks           | Gemini Flash                     | Low latency, fast response                                    |

**Switching strategy**: Start with fast models for exploration; switch to high-reasoning models when facing ambiguous requirements, multi-module changes, or CI-breaking refactors.

---

## 3. AGENTS.md Design Principles

### 3.1 Required Sections and Generation Tiers

| Section                   | Purpose                                     | Tier         | Design Notes                                                    |
| ------------------------- | ------------------------------------------- | ------------ | --------------------------------------------------------------- |
| **Project Summary**       | One-line project description                | C — Human    | Include tech stack, architecture pattern, deployment            |
| **Anchor Information**    | Base Package / Alias / Version SoT          | A — AI auto  | Eliminate blind search; force config file tracing               |
| **Quick Constraints**     | Top-pinned critical hard rules              | C — Human    | Extracted from Code Generation Rules; survives context dilution |
| **Domain-to-Code Map**    | Business ↔ code mapping                     | B — AI draft | Lets AI quickly locate the right module                         |
| **Code Generation Rules** | Layer rules, naming, prohibitions           | C — Human    | Use explicit Do / Don't format                                  |
| **GenAI Docs Navigation** | Intent-based "what do you want to do" table | B — AI draft | Markdown table — highest AI parse efficiency                    |
| **Common Commands**       | build / test / serve                        | A — AI auto  | Simple table is sufficient                                      |
| **Related Projects**      | Cross-repo navigation                       | B — AI draft | Include relative paths and brief relationship notes             |
| **Docs Sync Triggers**    | PR trigger conditions                       | C — Human    | Makes AI proactively sync docs after code changes               |

> Sections ordered by "impact when violated" — descending. See Section 3.5.

### 3.2 Anchor Information Examples

```markdown
## Project Summary
- **Tech Stack**: .NET 10 (C#) + ASP.NET Core + EF Core + PostgreSQL 16
- **Base Namespace**: `MyApp.Api`, `MyApp.Service` (follow Solution structure)
- **Version source of truth**: .NET SDK per `global.json`; packages per `.csproj`
```

```markdown
## Project Summary
- **Tech Stack**: React 19 + TypeScript 5.8 + Nx 19 Monorepo
- **Alias Mapping**: `@frontend/*` maps to `libs/frontend/*/src/` (per `tsconfig.base.json`)
- **Version source of truth**: package versions per `package.json`
```

### 3.3 Navigation Table Pattern

Use **intent-driven** (not file-driven) tables:

```markdown
| What you want to do                   | Read this first                          |
| ------------------------------------- | ---------------------------------------- |
| Understand system overview & modules  | docs/analysis/SA-001                     |
| Look up an architecture decision      | docs/adr/                                |
| Understand dev flow & Git conventions | CONTRIBUTING.md (read only for PR tasks) |
```

**Key**: Left column uses natural language intent for better AI intent-matching. For rarely-used docs, add read preconditions to save tokens.

#### Navigation in the Semantic Search Era

When the Agent has full-text indexing / semantic search (Copilot `#codebase`, Cursor indexing, Claude Code native search), "finding a file" is no longer the table's core value. Shift focus to:

- **Stable business-intent ↔ code mappings**: Clarify ambiguities like "does 'Warehouse' mean ERP inventory or physical warehouse?" — search indexes cannot resolve this
- **Cross-module derived relationships**: Domain-to-code maps show "Product Management" spans `WarehouseProductController` + `StoreProductController` + `ImportTemplateController` — hard for semantic search to associate
- **"Nonexistent options"**: Search only finds written code; maps can note "this domain has no Controller" — very useful for Agents

**Practical advice**: With semantic search, trim the map to 8–12 key domains. Invest the saved space in Quick Constraints and "Don't" counterexamples — these are restrictive knowledge that search indexes can never replace.

### 3.4 Guardrails Against Instruction Overload

`AGENTS.md` is NOT an onboarding manual. Excessive content causes AI to lose focus.

**Why length backfires**: The longer AGENTS.md gets, the more core rules get buried in noise. If AI repeatedly violates a rule that IS in AGENTS.md, suspect "this file is too long or noisy" before adding another rule.

Guidelines:

- **Recommended length**: Keep concise; 150–300 lines ≈ 2,000–4,000 tokens, which fits comfortably within mainstream LLM system prompt budgets (typically 4K–16K tokens) while leaving room for task-specific context. Exceeding this range risks crowding out conversation context and degrades response quality. Move overflowing sections to `docs/` sub-files and reference them via the navigation table.
- **Required fields**: Project summary, anchor info, navigation table, code generation rules, verification commands, docs sync triggers
- **Remove candidates**: Long background stories, beginner setup tutorials, unimplemented future roadmap details

#### Write vs Don't Write

| Write (AI cannot infer)                        | Don't Write (AI already knows or can infer)       |
| ---------------------------------------------- | ------------------------------------------------- |
| Code style rules that differ from defaults     | Language universal conventions                    |
| Build / test / lint commands                   | Detailed API documentation (use links instead)    |
| Hard rules and layer boundaries                | File-by-file description lists                    |
| Team-specific paths, env vars, special gotchas | "Write clean code" — correct but useless          |
| PR / branch naming conventions                 | Frequently changing info (version numbers, names) |
| Dev environment requirements (env, secrets)    | Long tutorials or background stories              |

#### Per-Line Self-Check

Review each line of AGENTS.md with one question:

> **"Would removing this line cause AI to make an error on its next task?" If not, remove it or move to docs/ sub-files.**

This principle comes from Anthropic's official guidance for CLAUDE.md. Treat AGENTS.md like code: review regularly, trim, and validate changes by observing Agent behavior.

**Emphasis syntax**: When a rule is repeatedly ignored by AI, prefix it with `IMPORTANT:` or `YOU MUST` to increase compliance. This is a **last resort** — if every rule has emphasis, none does.

#### HTML Comments as Human-Only Notes

Wrap maintainer-only notes in block HTML comments to avoid consuming AI context tokens:

```markdown
<!--
Maintainer note: This naming convention was decided in 2024-Q3 cross-team meeting. Check with @tech-lead before changing.
-->
```

### 3.5 Section Order and Attention Weight

Earlier sections are more likely to survive context compression in long conversations. In long conversations, chat history dilutes guidance file influence — front-section content has the highest survival rate.

Order AGENTS.md sections by "impact when violated" — descending:

| Priority | Section                  | Rationale                                                    |
| -------- | ------------------------ | ------------------------------------------------------------ |
| 1        | Project Summary + Anchor | Foundation for AI's project understanding                    |
| 2        | Quick Constraints        | Hard rules — violations cause PR rejection                   |
| 3        | Domain-to-Code Map       | Core navigation for correct file targeting                   |
| 4        | Code Generation Rules    | Detailed rules; Quick Constraints covers the critical subset |
| 5        | GenAI Docs Navigation    | Reference as needed, not every task                          |
| 6        | Common Commands          | AI can usually infer these                                   |
| 7        | Related Projects         | Only for cross-project tasks                                 |
| 8        | Docs Sync Triggers       | Only needed at PR time                                       |

**Quick Constraints design**: Extract the most critical hard rules from Code Generation Rules (violations cause PR rejection or system errors). Place after Project Summary. Even when later sections are diluted by conversation history, core constraints survive in the front section.

**Responsibility definition**: Quick Constraints' decision source is C3 (human decision). Their wording is a pinned projection extracted from Code Generation Rules. They MUST only be rebuilt after user confirmation.

**Emphasis syntax note**: Quick Constraints are already top-positioned by design — semantically the "5–8 most important rules." DO NOT prefix every rule with `IMPORTANT:` or `YOU MUST`. Only add emphasis on a specific rule after Context Hygiene, per-line self-check, and disambiguation have all failed — and AI still repeatedly violates it. See [DAILY-USAGE Section 5.6](DAILY-USAGE.md#56-ai-repeatedly-violates-the-same-agentsmd-rule) for the diagnostic flow.

### 3.6 Nested AGENTS.md (Monorepo / Large Projects)

Large monorepos can place additional AGENTS.md files in subdirectories for layered navigation.

#### Compaction Survival Strategy

In long conversations, agent platforms trigger summary/compression (Claude Code `/compact`, Copilot summary insertion). Per Claude Code official docs:

- **Root CLAUDE.md is auto-re-injected after compaction**; other agents behave similarly though not guaranteed
- **Subdirectory nested AGENTS.md is NOT auto-re-injected** — only reloaded when the Agent reads that directory again

| Location | Suitable Content                                                  | Compaction Survival                  |
| -------- | ----------------------------------------------------------------- | ------------------------------------ |
| Root     | Quick Constraints, project summary, anchor info, SPEC triggers    | High                                 |
| Sub      | Package-specific: DTO naming, routing conventions, special builds | Low (persisted on disk, re-readable) |

Principle: **"Rules that must survive even after memory loss" go in Root; "details needed only when deep in that module" go in Sub.**

- **Behavior**: AGENTS.md standard specifies — the agent reads the **nearest AGENTS.md** to the currently edited file; deepest match wins
- **When needed**: Nx / Turborepo / Lerna monorepo; multi-endpoint Web + Mobile dual-channel; sub-packages with independent architecture rules
- **Design**: Root AGENTS.md holds project-wide rules only (tech stack, version SoT, CI entry). Sub AGENTS.md holds module-specific rules. Sub does not repeat Root content but may link back with `../AGENTS.md`
- **Reference**: [AGENTS.md official standard](https://agents.md/), OpenAI main repo (88 AGENTS.md files), Apache Airflow, Temporal Java SDK

---

## 4. Document Layers and Event Triggers

### 4.1 Standard Four-Layer Classification

| Layer                                  | Prefix      | Responsibility                                        | Trigger                                     |
| -------------------------------------- | ----------- | ----------------------------------------------------- | ------------------------------------------- |
| **SA** (System Analysis)               | `SA-xxx`    | Milestone system snapshots                            | Architecture or core dependency change      |
| **ADR** (Architecture Decision Record) | `ADR-xxx`   | Single decision permanent record (append-only)        | Cross-phase either/or choice                |
| **SPEC** (Interface Specification)     | `SPEC-xxx`  | Interface contracts + Changelog (**Source of Truth**) | **Mandatory**: PR modifies public interface |
| **INFRA** (Infrastructure)             | `INFRA-xxx` | Infrastructure selection and topology                 | Deploy/CI config change                     |

**Flexible extension**: Library projects may use **INTEGRATION** instead of INFRA. Frontend projects may add **Components** (component index).

> **ZeroSpec principle**: No trigger → no document. All docs AI-drafted via Prompt Packs; humans review only.

### 4.2 SPEC is Source of Truth

The most important covenant in this methodology:

> SPEC usually serves as a primary reference for development and GenAI work. Interface additions or behavior changes should typically update the SPEC directly, with changes tracked in its Changelog.

**Minimum maintenance rule**: For any PR involving interface or behavior changes, use the [SPEC Prompt Pack](prompts/SPEC.md) to let AI generate/update a SPEC draft. Human reviews and merges.

### 4.3 ADR Trigger Examples

```markdown
- ✅ Needs ADR: Clean Architecture layer strategy, JWT dual-token design, Kafka vs Event Hubs
- ❌ No ADR needed: Adding a CRUD API, changing Redis TTL default
```

### 4.4 Demand-Driven Expansion (Lazy Evaluation)

Do not pre-create empty files. Instead, declare trigger conditions in `AGENTS.md`:

```markdown
| Candidate Document            | Trigger                                   |
| ----------------------------- | ----------------------------------------- |
| ADR-001_clean-architecture.md | When layer restructuring is discussed     |
| SPEC-001_auth-and-rbac.md     | When auth interface needs formal contract |
```

### 4.5 Naming Convention

```
^(SA|ADR|SPEC|INFRA)-\d{3}_[a-z0-9-]+\.md$
```

### 4.6 Per-Directory Sub-Index (Threshold-Triggered)

When a document category reaches the file-count threshold defined below, add a **thin sub-index** inside that category's directory to enable intent-driven navigation.

#### Trigger Condition

Create `docs/spec/README.md` when the directory contains **≥ 8** files matching `SPEC-*.md`.

This threshold is a deterministic check (count files in directory) — not a subjective judgment. AI agents can evaluate it by listing the directory.

#### Scope

Currently defined for **SPEC only**. Other document categories do not have sub-index rules unless explicitly added later.

#### What the Sub-Index Contains

Use [`templates/SPEC-INDEX-TEMPLATE.md`](templates/SPEC-INDEX-TEMPLATE.md) as the skeleton. Required sections:

1. **Purpose** — scope declaration + SoT reminder
2. **Document Index** — table of all SPECs (name, subject, scope, audience, status)
3. **How to Choose** — scenario-to-SPEC mapping (intent-driven, not filename-driven)
4. **Maintenance Rules** — maps code change types to SPEC update obligations
5. **Status Guide** — defines status labels used in the index

**Prohibited content**: endpoint tables, DTO schemas, business rules, or any contract detail that belongs in individual SPECs. The sub-index is navigation, not specification.

**Language rule**: localize human-facing README content (headings, explanatory prose, table labels, scenario descriptions, maintenance rule descriptions, and status meanings) to the repository's detected documentation language or explicit `Respond in {locale}` override. Keep file paths, code identifiers, SPEC filenames, commands, and links literal.

#### Relationship with `docs/README.md`

- `docs/README.md` **retains its flat SPEC list** (name + path + status) — this ensures backward compatibility and provides a single-glance overview.
- `docs/README.md` **additionally links** to `docs/spec/README.md` for situational lookup.
- Two layers serve different functions: top-level = quick positional lookup; sub-index = intent-driven navigation + maintenance mapping. This is not SoT duplication.

#### Maintenance Responsibilities

| Action                                       | Responsible Prompt                                                         |
| -------------------------------------------- | -------------------------------------------------------------------------- |
| **Create** the sub-index (first time)        | `UPDATE.md` — during periodic review, when threshold is met                |
| **Add or update** a row when a SPEC changes  | `SPEC.md` — in Post-Output Verification (only if sub-index already exists) |
| **Update** How to Choose / Maintenance Rules | `UPDATE.md` — during periodic review (holistic cross-SPEC perspective)     |

`SPEC.md` never creates the sub-index structure. It only adds or updates rows in an existing one.

#### Irreversibility

Once created, the sub-index is not removed even if SPEC count later drops below the threshold. A short index causes no harm; removing it risks breaking existing navigation links.

---

## 5. Drift Prevention

Documents' greatest enemy is change — code changes but docs don't follow.

### 5.1 Avoid Exact Counts

**Wrong**: "This project has 19 Controllers and 43 shared components"
**Right**: "This project provides Web and Mobile dual-channel APIs, sharing the Service layer"

Count descriptions are the most stale-prone information. AI needs **structural patterns**, not exact counts.

### 5.2 Single Source of Truth Declaration

After declaring "version source of truth" in AGENTS.md, version numbers in the document are only **hints**. AI reads config files for precise versions:

```markdown
- **Version source of truth**: package versions per `.csproj`; .NET SDK per `global.json`
```

### 5.3 Deduplication Rule

Same information appears in one place only. If a second mention is necessary, use a "see X" reference:

```markdown
- Use TypeScript strict mode (version per tech stack declaration)
- Use AutoMapper (version per `.csproj`)
```

### 5.4 Read Scope Restriction

For large but rarely-needed docs, use preconditions to limit AI's read behavior:

```markdown
| Understand Git collaboration rules | CONTRIBUTING.md (read only for Git/PR tasks; prioritize PR flow and quick checklist) |
```

### 5.5 Version Precision Standard

| Item          | Precision        | Example                                         | Rationale                                       |
| ------------- | ---------------- | ----------------------------------------------- | ----------------------------------------------- |
| Language      | Major            | C# (see `.csproj` `LangVersion` or SDK mapping) | Language version determines syntax availability |
| SDK           | Major            | .NET SDK 10                                     | SDK affects compiler and toolchain              |
| Framework     | Major.Minor      | ASP.NET Core 10.0                               | Minor version determines API availability       |
| Tools         | Major.Minor      | TypeScript 5.8                                  | Minor version affects build behavior            |
| Patch version | **Do not write** | —                                               | Most stale-prone; force AI to read config files |

---

## 6. Anti-Patterns

Full catalog: [anti-patterns.md](anti-patterns.md). Most common items:

| Anti-Pattern              | Problem                                  | Fix                                    |
| ------------------------- | ---------------------------------------- | -------------------------------------- |
| Hardcoded patch version   | `ASP.NET Core 10.0.5` stale on upgrade   | Major.Minor only + point to config     |
| Exact file counts         | "43 components" — one addition breaks it | Describe structural patterns           |
| Duplicate version numbers | One updated, one forgotten               | Second occurrence uses "see X" ref     |
| Long onboarding tutorials | brew/git basics consuming AI context     | Move to human README or restrict scope |
| Filename-based navigation | AI cannot intent-match                   | Left column: natural language intent   |

---

## 7. Adoption and Continuous Operation

ZeroSpec adoption: **Analyze → Build → Verify → Event-Triggered → Periodic Review**. First three stages complete on Day-1.

### Step 1: Analyze Current State (INIT-SCAN)

1. Copy the Prompt from [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md), paste into any AI Agent
2. Agent auto-scans the repo, produces structured analysis (no files written)
3. Confirm results, answer 2–3 clarification questions (~5–10 min)

### Step 2: Build Documents (INIT-BUILD)

1. Copy the Prompt from [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md), paste in the same conversation
2. Agent asks Tier C questions (project summary, hard rules, deploy strategy)
3. Agent generates `AGENTS.md` + `docs/README.md`
4. Review Tier B drafts (domain-to-code map, naming conventions), adjust, save
5. AI provides assessment: scan summary, recommended first SPEC, suggested minimal doc set, next steps

### Step 3: Verify

1. Run a real small task (e.g. add an API) using the new `AGENTS.md`
2. Confirm Agent follows architecture layers, uses correct Base Package, runs build/test
3. If deviations occur, adjust the corresponding hard rule in `AGENTS.md`

### Step 3.5: Choose Next Step by Project Type

ZeroSpec's Day-1 experience diverges by project type:

#### 🌱 Greenfield (New project, few or no APIs)

After INIT-BUILD, **proceed directly to Step 4's event-driven mode**. Each new API triggers a SPEC. No historical docs to backfill.

> Create the first SPEC alongside the first real API endpoint — don't wait until several accumulate.

#### 🏗️ Brownfield (Existing project, moderate-to-large API surface)

After INIT-BUILD, run two parallel tracks:

| Track                   | Work                                   | Priority Principle              |
| ----------------------- | -------------------------------------- | ------------------------------- |
| **Development** (daily) | New/changed APIs trigger SPEC normally | All new changes need SPEC       |
| **Backfill** (gradual)  | Existing APIs get SPECs over time      | By priority — not 100% required |

**Backfill priority** (high → low):

1. APIs with recent code changes (highest churn = highest risk = most need for SPEC)
2. Cross-system / cross-team dependency APIs (existing consumers)
3. APIs with complex business logic (validation, calculations, multi-step flows)
4. Long-idle APIs — **defer or skip** (Dead Zone; low backfill ROI)

**As-Is principle**: Backfill SPECs describe **current code behavior**, not ideal architecture. If you find issues, record them in SPEC's TODO section — do not mix To-Be into As-Is SPECs.

**SDD minimum bar** (first month target):

- `AGENTS.md` + `docs/README.md` ✅ (Day-1 complete)
- At least one high-priority API SPEC ✅
- All new changes have corresponding SPECs ✅ (development track operating)

> Not all APIs ultimately need SPECs. Dead Zone APIs with no consumers and no changes can permanently skip SPEC. Documents exist only when there are consumers.

**Brownfield recommended first steps**:

1. Run **SA Prompt** → produce system architecture snapshot (full-picture understanding)
2. Backfill first **SPEC** based on priority (start with most frequently changed API)
3. Enter development track — new changes trigger SPEC normally

### Step 4: Event-Triggered Expansion

| Trigger Event                   | Prompt Pack                                      | Output                                 |
| ------------------------------- | ------------------------------------------------ | -------------------------------------- |
| Day-1 init (analyze)            | [`prompts/INIT-SCAN.md`](prompts/INIT-SCAN.md)   | Analysis report (no files written)     |
| Day-1 init (build)              | [`prompts/INIT-BUILD.md`](prompts/INIT-BUILD.md) | `AGENTS.md` + `docs/README.md`         |
| API added/changed               | [`prompts/SPEC.md`](prompts/SPEC.md)             | `docs/spec/SPEC-xxx.md`                |
| Cross-module technical decision | [`prompts/ADR.md`](prompts/ADR.md)               | `docs/adr/ADR-xxx.md`                  |
| System snapshot needed          | [`prompts/SA.md`](prompts/SA.md)                 | `docs/analysis/SA-xxx.md`              |
| Project evolved, sync docs      | [`prompts/UPDATE.md`](prompts/UPDATE.md)         | Updates `AGENTS.md` + `docs/README.md` |
| **None of the above**           | —                                                | **Create nothing**                     |

### Step 5: Periodic Review

#### Quick Review (monthly, ~15 min)

- [ ] Does the domain-to-code map match current code?
- [ ] Are version source of truth config files still correct?
- [ ] Does SPEC Changelog keep up with recent code changes?
- [ ] Any new modules not covered by the map?
- [ ] Any low-value rules that can be removed?

> Use [`prompts/UPDATE.md`](prompts/UPDATE.md) for post-review updates.

#### Full Review (quarterly)

All quick review items, plus:

- [ ] Do hard rules still reflect team consensus? (Confirm with team members)
- [ ] Does the Agent frequently violate a specific rule? (If so, improve that rule's clarity first)
- [ ] Do event trigger Prompt Packs still match the team's workflow?
- [ ] Are reference links still valid?

### Acceptance Metrics

Use these as directional targets for projects with reasonably stable architecture and team agreement on conventions. They are useful review goals, not guarantees.

| Metric                               | Target   |
| ------------------------------------ | -------- |
| Day-1 human effort                   | ≤ 30 min |
| Human-written content share (Tier C) | ≤ 20%    |
| First-round merge rate               | ≥ 70%    |
| Hard rule violation rate             | ≤ 10%    |
| SPEC draft coverage after API change | ≥ 90%    |

> **Day-2+ usage**: daily operation modes, IDE configuration, Plan vs Agent selection, scenario playbooks → see [DAILY-USAGE.md](DAILY-USAGE.md).

#### Retirement Rule

Any optional add-on (e.g., IDE Prompt File templates, adapter snippets) should justify its place over time:

- If a new addition is **not referenced in any PR or raised in any Issue within 30 days**, downgrade it to `examples/` or remove it at the next quarterly review.
- Measurement: `git log --all --oneline --grep="templates/prompts"` to check reference frequency.
- Principle: maintenance cost compounds. Remove before adding.

---

## 8. Cross-Project Consistency

> This section applies to multi-project ecosystems. Skip for single-project adoption.

When an ecosystem has multiple related projects, AI's cognitive switching cost is the biggest performance bottleneck.

### 8.1 Shared Conventions Section

Each project's `docs/README.md` includes a cross-system conventions section:

```markdown
## Cross-System Conventions
| Project     | Docs Path                        |
| ----------- | -------------------------------- |
| my-backend  | ../../my-backend/docs/README.md  |
| my-frontend | ../../my-frontend/docs/README.md |
```

### 8.2 Consistency Checklist

Items that should stay semantically aligned across projects:

- [ ] Navigation table ADR row descriptions use identical wording
- [ ] SPEC Source of Truth definition is identical
- [ ] ADR trigger conditions description is identical
- [ ] Naming conventions (regex) are identical

### 8.3 Cross-Agent Consistency Check

When landing across platforms, test with at least two agents on the same small task (e.g. "add an API and produce a SPEC"). Compare:

- Did both read the same core rules (constraints, SoT, ADR triggers)?
- Did both execute the same verification flow (build/test/lint)?
- Did both prompt for docs sync at PR time?

If one platform repeatedly misses a rule, adjust that rule's visibility and clarity in `AGENTS.md`.

---

## 9. Industry Evidence and References

### 9.0 Evidence Levels

| Level                        | Definition                           | Usage                                 |
| ---------------------------- | ------------------------------------ | ------------------------------------- |
| **A: Official docs**         | Product/platform official docs       | Establish actionable rules            |
| **B: Methodology/community** | ADR orgs, engineering practice sites | Design context and template selection |
| **C: Experience**            | Team adoption cases                  | Landing strategies and anti-patterns  |

### 9.1 AGENTS.md — AI Agent Project Entry Convention

> *"Codex reads the AGENTS.md file at the root of each repository to understand project conventions, build commands, and code style preferences."*
> — [OpenAI Codex Documentation](https://openai.com/index/introducing-codex/) (2025)

**Level A references**:
- [GitHub Copilot Instructions / AGENTS.md](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [Cursor Docs](https://cursor.com/docs)
- [OpenAI Prompt Engineering](https://developers.openai.com/api/docs/guides/prompt-engineering)

### 9.2 ADR — Architecture Decision Records

> *"An architecture decision record is a short text file describing a single architecture decision."*
> — Michael Nygard, [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) (2011)

**Level B**: [ADR GitHub Organization](https://adr.github.io/) · [Thoughtworks Tech Radar](https://www.thoughtworks.com/radar/techniques/lightweight-architecture-decision-records) — rated **Adopt**

### 9.3 Structured Markdown = Most Efficient LLM Input

**Level A**: [OpenAI Prompt Engineering](https://developers.openai.com/api/docs/guides/prompt-engineering) · [Google Gemini Prompting Strategies](https://ai.google.dev/gemini-api/docs/prompting-strategies) · Anthropic Prompt Engineering (use latest official page)

### 9.4 Source of Truth and Drift Prevention

[OpenSpec](https://github.com/Fission-AI/OpenSpec) — AI-native spec management tool · [Spec Kit](https://github.com/github/spec-kit) — Spec-Driven Development CLI · [API-First Development](https://swagger.io/resources/articles/adopting-an-api-first-approach/) — Swagger/OpenAPI methodology

### 9.5 Context Window Optimization

> *"The key insight is treating context as a scarce resource — every token spent on irrelevant information is a token not available for the actual task."*
> — Simon Willison, [Prompt Engineering Lessons](https://simonwillison.net/tags/prompt-engineering/)

### 9.6 Usage Notes

- This guide is an engineering practice framework, not a formal academic proof.
- All rules should be continuously adjusted through your project KPIs and review cycles.
- When tool platforms update (models, IDEs, agent capabilities), review references and recommendations quarterly.

---

## Appendix: Common Adoption Questions

| #   | Problem                            | Symptom                                               | Fix                                                   |
| --- | ---------------------------------- | ----------------------------------------------------- | ----------------------------------------------------- |
| 1   | **Inconsistent version precision** | Project A writes `10.0.5`, B writes `10.x`            | Standardize on Major.Minor; Patch via config          |
| 2   | **Document count drift**           | "43 components" but actually 42                       | Remove all exact counts; use structural descriptions  |
| 3   | **Overlapping navigation rows**    | Similar descriptions pointing to different files      | Use clearly distinct natural language per row         |
| 4   | **Duplicate version declarations** | Version in tech stack AND in rules section            | Second occurrence uses "see tech stack" reference     |
| 5   | **Mixed writing systems**          | Main text Traditional Chinese, one section Simplified | Unify to a single writing system                      |
| 6   | **Future plans overweight**        | Unimplemented roadmap takes 30% of file               | Compress to trigger conditions + skeleton (~10 lines) |

---

*This guide ships with ZeroSpec. Adapt to your project's needs.*
