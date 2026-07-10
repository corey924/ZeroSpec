# Changelog

This file tracks the version history of the ZeroSpec framework.

---

## v0.5.3 — 2026-07-10

### Changed

- **Layer 0 boundary**: clarified that ZeroSpec provides context readiness and documentation governance, not code-execution orchestration or workflow gates. The former `IMPL.md` execution bridge moved to `examples/optional-bridges/` and is no longer routed by the core skill.
- **Contract Ownership**: replaced the blanket "every API change needs a Markdown SPEC" rule with a project-declared ownership model. Machine-verifiable artifacts such as OpenAPI, schemas, generated clients, or code own paths and field/type details; narrative SPECs own behavior, rules, permissions, compatibility, and consumer impact. New SPECs are risk-based.
- **Policy propagation**: aligned generated AGENTS templates, examples, PR checklist, pointer fallbacks, SPEC index guidance, and maintenance prompts with the same risk-based rule; agents now state why a machine contract or no narrative update is sufficient when applicable.
- **Prompt safety**: added evidence-versus-instruction boundaries to repository-scanning prompts to reduce indirect prompt-injection risk.
- **Platform guidance**: updated VS Code/Copilot, Cursor, Devin Desktop/Windsurf, JetBrains, and Prompt File guidance for current instruction discovery and adapter metadata. Prompt Files now use `agent:` metadata and relative Markdown links; their optional target-root `prompts/` prerequisite is explicit.
- **Guidance hygiene**: removed stale model-family routing, universal context-window budgets, and fixed conversation-round thresholds. Retained symptom-based re-anchoring and concise-rule guidance.
- **Language isolation**: removed zh-TW prose from English Prompt Packs, templates, pointers, and user-facing docs. Cross-platform verification now rejects Han characters in any non-zh-TW Markdown file.

### Verification

- Updated shell and PowerShell verification to cover the eight core Prompt Packs, Contract Ownership, and current Prompt File metadata while removing retired IMPL assertions.

## v0.5.2 — 2026-05-24

### Added

- `prompts:` `prompts/IMPL.md` — new Layer 2 Prompt Pack for complex multi-module coding tasks (3+ Controllers/handlers or 2+ SPECs affected). Requires affected SPEC planning before coding and a `### Docs Impact` block after code-changing responses.
- `templates:` `templates/pull_request_template.md` — downstream PR template with Docs Sync Checklist and `### Docs Impact` paste slot.
- `docs:` `AGENTS.md` — added ZeroSpec's own Code-to-Docs Map, fixed first Quick Constraints item for SPEC impact assessment, and Post-Edit Self-Check so the framework dogfoods the drift-prevention rule it recommends.
- `docs:` All 5 example AGENTS.md files (EN + zh-TW) — added compact Post-Edit Self-Check sections with project-specific verification commands.
- `docs:` `anti-patterns.md` and `anti-patterns.zh-TW.md` — added #25 `Code-without-SPEC-assessment`.

### Changed

- `prompts:` `prompts/INIT-BUILD.md` — Quick Constraints item 1 in the AGENTS.md template now covers two lifecycle checkpoints: at task start, assess scope and suggest IMPL Prompt Pack if 3+ Controllers/handlers or 2+ SPECs; at task end, assess document impact through a `### Docs Impact` Forcing Function that references the `docs/README.md` AI Auto-Trigger Heuristics matrix.
- `templates:` `templates/DOCS-README-TEMPLATE.md` — added SA Trigger Conditions and AI Auto-Trigger Heuristics (Zero-Dependency) with Best Route / Fallback Route guidance, helping mainstream LLMs (Claude, GPT, Gemini) decide when to grow SPEC, ADR, SA, or INFRA without manually invoking each Prompt Pack.
- `prompts:` `prompts/UPDATE.md` — added Step 3.7 Code-to-Docs Map Check and Step 3.8 Post-Edit Self-Check Audit so periodic updates verify both mapping and final-response forcing behavior.
- `prompts:` `prompts/SPEC.md` — added a Quick Self-Assessment section outside the prompt block to help users decide whether SPEC is the right prompt.
- `templates:` pointer templates (`copilot-instructions.md`, `CLAUDE.md`, `.cursorrules`, `.windsurfrules`) now include short self-contained Spec-Aware Coding Discipline fallback rules, with a conditional IMPL Prompt Pack routing hint for 3+ Controllers/handlers or 2+ SPEC tasks.
- `docs:` `GUIDE.md`, `GUIDE.zh-TW.md`, `DAILY-USAGE.md`, and `DAILY-USAGE.zh-TW.md` now clarify the roles of always-on AGENTS.md checks, IMPL.md for large coding tasks, and DRIFT.md for periodic audits.
- `skills:` `skills/zerospec/SKILL.md` now routes `impl` and lists 9 options; `skills/zerospec/prompts/` includes an IMPL copy kept in sync with `prompts/IMPL.md`.
- `ci:` `scripts/verify-zerospec.sh` and `scripts/verify-zerospec.ps1` now assert IMPL Prompt Pack structure, prompt-copy parity, PR template presence, and AGENTS.md dogfood markers.
- `docs:` `README.md` and `README.zh-TW.md` — bumped version headers to v0.5.2; added an IMPL Prompt Pack row to both language variants of the After Adoption table so human users can discover the prompt directly without relying on AI auto-suggestion.

---

## v0.5.1 — 2026-05-16

### Added

- `skills:` New `skills/zerospec/` skill-style Router — the first optional Platform Adapter implementation, while `prompts/*.md` remains the canonical cross-tool interface. Packages all 8 Prompt Packs for tools that support `SKILL.md`-style loading; verified with Claude Code. Includes a built-in Self-Review Matrix that runs silently before each output.
- `skills:` `skills/zerospec/prompts/` — 8 prompt sub-files, kept in sync with `prompts/` via the new sync script
- `skills:` `skills/README.md` — install guide + Phase 0 verification checklist (3 tests to validate sub-file reading, trigger accuracy, Self-Review follow-through)
- `scripts:` `scripts/sync-skills.sh` and `scripts/sync-skills.ps1` — cross-platform sync scripts: default (sync only), install (sync + install to `~/.claude/skills/`), check (drift detection, exit 1 on drift). Unknown arguments fail fast; stale prompt sub-files are removed during sync.

### Changed

- `docs:` `README.md` and `README.zh-TW.md` — Added Codex CLI / Generic CLI entry, OS-specific skill sync commands, and `skills/` + sync scripts to Repo Structure
- `docs:` `DAILY-USAGE.md` and `DAILY-USAGE.zh-TW.md` — Added Codex CLI / Generic CLI guidance, Fastest First Run matrix, Prompt Files path prerequisite, and Optional Tool Adapters subsection under §2.2
- `docs:` Clarified Day-2 guide version source, first-run Claude Code path (`init-scan` before `audit`), and README Prompt Files adapter tree
- `docs:` `AGENTS.md` — Domain-to-Code Map: added skill-style adapter row; Code Generation Rules: added `skills/zerospec/prompts/` sync rule; Common Commands: added macOS/Linux and Windows sync commands; Docs Maintenance: prompt-pack PR now includes sync step
- `ci:` `scripts/verify-zerospec.sh` and `scripts/verify-zerospec.ps1` — Added checks for `skills/` structure and prompt-copy parity between `prompts/` and `skills/zerospec/prompts/`
- `ci:` Lychee link check now excludes generated `skills/zerospec/prompts/` copies while continuing to validate canonical `prompts/*.md`; verification scripts assert the exclusion remains in place

---

## v0.5.0 — 2026-05-16

### Added

- `prompts:` Added `prompts/DRIFT.md` — new Prompt Pack to detect drift between existing SPEC documents and current code. Produces a structured drift report with BREAKING / DRIFT / STALE severity levels. Read-only; does not write any files.
- `templates:` Added `templates/prompts/zerospec-drift.prompt.md` — VS Code adapter for DRIFT Prompt Pack

### Changed

- `prompts:` `prompts/AUDIT.md` — Added Dimension 8 (Domain-to-Code Map Health: spot-check Controller/Package entries still exist) and Dimension 9 (Path Link Health: verify internal and cross-repo path references). Added **Actionable Fix List** to output format. Updated `## Limitations` and `## Relationship to Other Prompts` sections.
- `docs:` `GUIDE.md` and `GUIDE.zh-TW.md` — Added SPEC / UPDATE / DRIFT lifecycle comparison table in §7 (event-trigger table includes DRIFT row)
- `docs:` `DAILY-USAGE.md` and `DAILY-USAGE.zh-TW.md` — Added Scenario H (DRIFT usage pattern) and DRIFT step to monthly quick review (§6); §5.6 diagnosis guidance now includes Domain-to-Code Map staleness as investigation step
- `docs:` `README.md` and `README.zh-TW.md` — Added DRIFT.md to Repo Structure and After Adoption trigger table
- `docs:` `AGENTS.md` — Continuous maintenance row in Domain-to-Code Map now includes `prompts/DRIFT.md`
- `docs:` `anti-patterns.md` and `anti-patterns.zh-TW.md` — Anti-pattern #16 "Build once, never update" now cross-references AUDIT Dimension 8-9 and DRIFT Prompt

---

## v0.4.3 — 2026-05-07

### New

- `templates:` Added `templates/SPEC-INDEX-TEMPLATE.md` — thin sub-index skeleton for `docs/spec/README.md` when SPEC count reaches threshold (≥ 8 files)
- `docs:` GUIDE §4.6 — Per-Directory Sub-Index: deterministic threshold trigger (≥ 8 SPEC files), maintenance responsibility split (UPDATE.md creates/reviews, SPEC.md adds or updates index rows), backward-compatible with existing flat list in `docs/README.md` (EN + zh-TW)
- `docs:` README Repo Structure — added `SPEC-INDEX-TEMPLATE.md` entry (EN + zh-TW)
- `prompts:` UPDATE.md Step 3.5 — Sub-Index Check: count SPEC files during periodic review, propose creation when threshold met, verify index completeness and navigation/maintenance mappings when sub-index exists
- `prompts:` SPEC.md Post-Output Verification step 4 — add/update row in sub-index Document Index table (if sub-index exists); never creates sub-index
- `prompts/templates:` Added localization guidance for human-facing `docs/spec/README.md` sub-index content while preserving file paths, code identifiers, SPEC filenames, commands, and links
- `templates:` DOCS-README-TEMPLATE.md — added HTML comment noting §4.6 sub-index trigger rule
- `docs:` anti-patterns #24 Document Scaling — warns against sub-index becoming thick specification (EN + zh-TW)

---

## v0.4.2 — 2026-04-24

### New

- `templates:` Added `templates/prompts/` with 7 VS Code Prompt Files (`*.prompt.md`) covering all Prompt Packs (INIT-SCAN, INIT-BUILD, SPEC, ADR, SA, AUDIT, UPDATE) — optional VS Code shortcut adapter (not required by ZeroSpec core); copy to `.github/prompts/` with ZeroSpec in workspace
- `templates:` Added `templates/pointers/` with platform pointer templates (`copilot-instructions.md`, `CLAUDE.md`, `.cursorrules`, `.windsurfrules`) to connect project `AGENTS.md` without duplication; Cursor/Windsurf/JetBrains can still use AGENTS.md natively
- `core:` Added root `AGENTS.md` for contributors working on ZeroSpec itself (dogfooding Layer 0 guidance on the framework repo)
- `community:` Added `CODE_OF_CONDUCT.md`, `SECURITY.md`, and `SUPPORT.md` (+ zh-TW companions) to establish OSS behavior, security reporting, and support boundaries
- `.github:` Added `.github/ISSUE_TEMPLATE/` with bug, docs/wording, and feature request templates plus basic chooser config
- `docs:` DAILY-USAGE §2.1 — added **Prompt Files** approach row + setup note for `#file:` path resolution (EN + zh-TW)
- `docs:` GUIDE §0 — added Quick Decision Flow (5-step numbered guide for Greenfield/Brownfield/unsure paths) (EN + zh-TW)
- `docs:` GUIDE §7 — added Retirement Rule subsection under Acceptance Metrics: 30-day adoption gate + git log measurement (EN + zh-TW)
- `docs:` README now positions ZeroSpec as a good starting point for light SDD-assisted development and explicitly notes coexistence with OpenSpec / Spec Kit
- `docs:` README Repo Structure — added `templates/prompts/`, `AGENTS.md`, `.github/ISSUE_TEMPLATE/`, and community health file entries with description
- `docs:` README After Adoption table — added optional Prompt Files row

### Changed

- `.github:` PR template SDD Sync Checklist — added `AGENTS.md` rule admission check linking to GUIDE §3.4 per-line self-check
- `core:` `AGENTS.md` Quick Constraints / Domain-to-Code Map / maintenance reminders now explicitly cover GitHub community health files
- `scripts:` `verify-zerospec.sh` + `verify-zerospec.ps1` — added Bloat Check section (WARNING only, does not affect PASS/FAIL): alerts when any `examples/*/AGENTS.md` exceeds 300 lines or ~4K tokens (aligned with GUIDE §3.4); verification now also asserts OSS community health entry files exist
- `docs:` `CONTRIBUTING.md` + `CONTRIBUTING.zh-TW.md` — renamed the misleadingly titled discussion-norms section in both language variants (the content is project-specific discussion guidance, not the formal community code of conduct); added a cross-reference to `CODE_OF_CONDUCT.md`
- `docs:` zh-TW docs now link community entry points to zh-TW companion files (`CODE_OF_CONDUCT.zh-TW.md`, `SECURITY.zh-TW.md`, `SUPPORT.zh-TW.md`) for lower-friction local-language navigation while keeping canonical English files intact

---

## v0.4.1 — 2026-04-24

### New

- `examples:` English-first bilingual structure for all 5 example sets (minimal-day1, dotnet-dual-api, java-library, python-package, react-nx-monorepo) — English primary + zh-TW copies as `*.zh-TW.md`
- `examples:` Synced zh-TW Document Index entries with active docs in dotnet-dual-api and java-library examples
- `examples:` Added Quick Constraints section to all 5 AGENTS.md — extracted from Code Generation Rules, placed at Priority 2 per GUIDE §3.5
- `examples:` Corrected section order in all 5 AGENTS.md — Domain-to-Code Map now precedes GenAI Documentation Navigation per §3.5 impact ranking
- `examples:` dotnet-dual-api Anchor Info merged into Project Summary per GUIDE §3.1
- `examples:` react-nx-monorepo added business Domain-to-Code Map table (was missing)
- `.github:` Converted `pull_request_template.md` to English-first format for contributor-facing consistency
- `scripts:` verify-zerospec.sh + .ps1 now assert examples English primary, zh-TW copies, and Quick Constraints presence in all AGENTS.md
- `scripts:` Added guards for zh-TW Document Index sync and language consistency checks in AUDIT Prompt, PR template, and CHANGELOG opener
- `docs:` Added DAILY-USAGE §5.8 "Specifying Output Language" (EN + zh-TW) — explains auto-detect behavior and three-tier locale override (one-time / project / personal)
- `docs:` Added "Non-English projects" Tip block to README 30-Second Quick Start (EN + zh-TW)
- `prompts:` All 7 Prompt Packs (INIT-SCAN, INIT-BUILD, SPEC, ADR, SA, AUDIT, UPDATE) now include a one-line locale override hint below the Language rule
- `prompts:` AUDIT Prompt "Limitations" section standardized to English
- `examples:` Completed English translation of `python-package/AGENTS.md` (Domain-to-Code Map body, Code Generation Rules, Common Commands, Related Projects, Documentation Maintenance) — closes partial-translation gap from v0.4
- `docs:` De-identified GUIDE §3.4 HTML-comment example — replaced personal handle with generic `@tech-lead` (EN + zh-TW)
- `docs:` CHANGELOG v0.1–v0.3 historical entries translated to English for language-consistency with v0.4+

---

## v0.4 — 2026-04-23

> Phase 2 i18n: All user-facing docs rewritten to AI-Native English as default; zh-TW originals preserved as `*.zh-TW.md`.

### ⚠️ Breaking Changes

- **File renames**: `README.md`, `GUIDE.md`, `DAILY-USAGE.md`, `anti-patterns.md`, `CONTRIBUTING.md` renamed to `*.zh-TW.md` suffix. New English versions take the original filenames.
- **CI assertion updates**: Verification scripts now check English content strings. Projects using custom CI checks against these files MUST update assertions.
- **Cross-reference anchors changed**: English versions use English heading anchors (for example `#34-guardrails-against-instruction-overload`) instead of the former zh-TW anchors.

### Migration Guide

1. If you link to ZeroSpec docs from external files, all primary filenames (e.g. `GUIDE.md`, `DAILY-USAGE.md`) remain the same — **no link changes needed**.
2. If you link to specific heading anchors in ZeroSpec docs, update to English anchors.
3. For zh-TW content, use the `*.zh-TW.md` variants (e.g. `GUIDE.zh-TW.md`).

### New

- `docs:` English AI-Native rewrites for README.md, GUIDE.md, DAILY-USAGE.md, anti-patterns.md, CONTRIBUTING.md
- `i18n:` Language switch links (`🌐`) added to both English and zh-TW versions
- `i18n:` Derived-from headers in English files track source zh-TW commit for sync
- `scripts:` Verification scripts updated for English content assertions
- `scripts:` Verification hardening — added anchor/link integrity checks for key cross-doc references, switched brittle full-sentence assertions to semantic regex patterns, and added minimal PATH/command preflight in `verify-zerospec.sh` for restricted CI shells
- `ci:` Workflow hardening — pinned `actions/checkout` SHA (v4.3.1), added `permissions: contents: read`, `timeout-minutes`, `concurrency` group, OS matrix (ubuntu + windows), ShellCheck lint job, and Lychee offline link/anchor checker job

### Design Notes

- English versions are **AI-Native rewrites** (not translations): imperative voice, 15–25% shorter, consistent terminology
- zh-TW originals preserved intact as `*.zh-TW.md` — no content changes
- Phase 1 (v0.3.1): Prompts, templates, and CI scripts already English (prior session)
- Phase 2 (v0.4): User-facing docs now English-first

---

## v0.3 — 2026-04-22

> Added separate Greenfield/Brownfield onboarding and a practical SPEC backfill model.

### New

- `docs:` GUIDE.md §7 adds Step 3.5 with two paths (Greenfield vs Brownfield), backfill priority, As-Is rule, and minimum SDD bar
- `docs:` README.md adds a Brownfield callout after Quick Start Step 3, linking to GUIDE.md §7
- `prompts:` INIT-BUILD.md Step 4 now detects Greenfield/Brownfield and suggests next steps
- `docs:` DAILY-USAGE.md §4 adds Scenario F for the first Brownfield month (Week 1 SA + first SPEC, Week 2-4 dual track, month-end review)
- `docs:` anti-patterns.md adds anti-pattern #19: "Backfill all legacy APIs at once"
- `scripts:` Verification scripts add checks for Greenfield/Brownfield content

### Design Notes

- **As-Is first**: Backfilled SPEC documents current behavior; keep To-Be ideas in TODO
- **Dead Zone policy**: APIs with no active consumers can remain without SPEC
- **Backfill order**: SA first, then high-priority SPECs, then normal dev flow

### References Adopted

- `prompts:` SPEC.md adds a Bugfix variant using Current / Expected / Unchanged
- `docs:` DAILY-USAGE.md §2.5 adds Context Hygiene guidance
- `docs:` GUIDE.md §3.6 adds nested AGENTS.md guidance for monorepos
- `docs:` README.md clarifies alignment with the open AGENTS.md format

### Claude Code Practices Applied

- `docs:` README.md fixes merged bullet formatting
- `docs:` GUIDE.md §3.4 tightens AGENTS.md length guidance (200-line main body, 300 hard cap) and adds clear write/skip guidance
- `docs:` anti-patterns.md adds #21 (bloated AGENTS.md) and #22 (rule inflation loop)
- `docs:` DAILY-USAGE.md §2.2 adds `CLAUDE.md` + `@AGENTS.md` import pattern
- `docs:` DAILY-USAGE.md §5.6 adds a checklist for repeated rule violations
- `docs:` DAILY-USAGE.md §4 adds Scenario G: Explore -> Plan -> Implement
- `prompts:` INIT-BUILD.md now requires build/test/lint/type-check commands

### Additional Improvements

- `docs:` GUIDE.md §3.5 adds emphasis-syntax usage notes
- `docs:` DAILY-USAGE.md Scenario A links to Scenario G
- `docs:` README.md adds "When ZeroSpec is not a fit"; GUIDE.md §0 adds matching comparison table
- `.github:` pull_request_template.md adds SDD Sync Checklist
- `prompts:` Adds `prompts/AUDIT.md` with a 7-dimension AGENTS.md self-audit
- `docs:` GUIDE.md §3.3 clarifies navigation table role in semantic-search environments
- `docs:` DAILY-USAGE.md §5.4 adds a concrete upgrade workflow for custom prompt packs
- `docs:` GUIDE.md §3.6 adds compaction survival strategy
- `scripts:` Adds existence + heading checks for `prompts/AUDIT.md`

### Wording and Release Polish

- `docs:` Syncs README.md and GUIDE.md version to v0.3 and fixes wording/spacing issues
- `docs:` README.md adds a 30-second quick start card and a Copilot compatibility note
- `docs:` DAILY-USAGE.md §5.7 adds Agent Bootstrap Test
- `prompts:` AUDIT.md adds "domain map necessity for small projects" and optional token-footprint observation
- `docs:` README.md / GUIDE.md / DAILY-USAGE.md / AUDIT.md replace brittle hard numbers with semantic wording

---

## v0.2 — 2026-04-19

> Model routing recommendations + Multi-root safeguards + Re-anchor stability reinforcement.

### New

- `docs:` README.md added "Scenario × Model recommendation table" — suggests suitable LLM model families per task type (not pinned to version numbers)
- `docs:` GUIDE.md §2.1 added "Model selection guidance" and "Model switching strategy" sections
- `prompts:` All 6 Prompt Packs (INIT-SCAN / INIT-BUILD / SPEC / ADR / SA / UPDATE) gained a unified Multi-root Workspace hint block, with copyable project-lock prefix example and safeguard phrasing
- `docs:` GUIDE.md §3.5 added "Section ordering and attention weight" — AGENTS.md section priority table and Quick Constraints design points
- `docs:` DAILY-USAGE.md §2.5 added "Long-conversation Re-anchor strategy" — three re-anchor examples and frequency recommendations
- `prompts:` INIT-BUILD prompt body added "Quick Constraints" block, placed after project summary and before navigation table
- `prompts:` UPDATE prompt added Quick Constraints diff & sync rule — prevents drift from detailed spec over long-term maintenance

---

## v0.1 — 2026-04-11

> Initial public release.

### New

- ZeroSpec core Prompt Packs: `INIT-SCAN`, `INIT-BUILD`, `SPEC`, `ADR`, `SA`, `UPDATE`
- Doc templates: `DOCS-README-TEMPLATE`, `SA-TEMPLATE`, plus existing `SPEC` / `ADR` templates
- Day-1 and mature-project examples: `.NET`, `Java Library`, `Python Package`, `React + Nx Monorepo`
- `DAILY-USAGE.md`: Day-2+ long-term user guide
- Verification scripts: `scripts/verify-zerospec.sh`, `scripts/verify-zerospec.ps1`
- Minimal CI template: `.github/workflows/verify-zerospec.yml`
- Open-source collaboration baseline: `CONTRIBUTING.md`, `.github/pull_request_template.md`

### Key Cleanups

- Prompt structure tuned for mainstream agent usage; avoids nested Markdown codeblock truncation
- `SPEC` / `ADR` / `SA` prompts removed incorrect upstream template-path dependencies, reducing cross-repo friction
- INIT-SCAN resolved semantic conflict between "Limitations" and "Anti-drift rules" — merged into unified "Rules" section
- INIT-BUILD / SPEC / UPDATE prompts compressed redundant instructions to lower token cost
- Verification script strengthened with SPEC/ADR/SA first-line heading checks and missing-template existence checks (60 → 65 assertions)
- README / GUIDE / DAILY-USAGE restructured into a directly-readable navigation for public release
- README opening English positioning tightened to map directly to the GitHub Description
- LICENSE is MIT; attribution set to project maintainers and contributors

### Verification

- `bash scripts/verify-zerospec.sh`: 65 PASS / 0 FAIL
