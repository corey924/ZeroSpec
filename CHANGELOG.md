# Changelog

This file tracks the version history of the ZeroSpec framework.

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
- `docs:` `CONTRIBUTING.md` + `CONTRIBUTING.zh-TW.md` — renamed misleadingly-titled `## Code of Conduct` / `## 行為準則` section to `## Discussion Norms` / `## 討論規範` (content is project-specific discussion norms, not the formal community code of conduct); added cross-reference to `CODE_OF_CONDUCT.md`
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
- **Cross-reference anchors changed**: English versions use English heading anchors (e.g. `#34-guardrails-against-instruction-overload` instead of `#34-指令過載防護guardrails`).

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
