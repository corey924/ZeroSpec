# ZeroSpec Anti-Patterns

> Derived from: [anti-patterns.zh-TW.md](anti-patterns.zh-TW.md) @ commit 96d51d5 | Last sync: 2026-04-23

> **🌐 [台灣正體中文版](anti-patterns.zh-TW.md)**

Common mistakes discovered across multi-project ecosystems. Each entry includes the problem and its fix.

---

## Version & Data Drift

| #   | Anti-Pattern                       | Problem                                                              | Fix                                                        |
| --- | ---------------------------------- | -------------------------------------------------------------------- | ---------------------------------------------------------- |
| 1   | **Hardcoded patch-level version**  | `ASP.NET Core 10.0.5` becomes stale on next upgrade                  | Write Major.Minor only + point to config file              |
| 2   | **Exact file counts**              | "43 components" — one addition breaks accuracy                       | Describe structural patterns, not counts                   |
| 3   | **Duplicate version numbers**      | Updated in one place, forgotten in another                           | Second occurrence uses "see X declaration" reference       |
| 4   | **Inconsistent version precision** | Project A writes `10.0.5` (too precise), B writes `10.x` (too vague) | Standardize on Major.Minor (e.g. `10.0`); Patch via config |

## Content Bloat

| #   | Anti-Pattern                  | Problem                                             | Fix                                                              |
| --- | ----------------------------- | --------------------------------------------------- | ---------------------------------------------------------------- |
| 5   | **Long onboarding tutorials** | `brew install` / git basics consume AI context      | Move to human-only README or restrict read scope                 |
| 6   | **Future plans taking space** | Unimplemented roadmap items distract from daily use | Compress to trigger conditions + governance skeleton (~10 lines) |
| 7   | **Pre-created empty files**   | AI wastes tokens opening empty shells               | Use Lazy Evaluation — create only when triggered                 |

## Structure & Semantics

| #   | Anti-Pattern                         | Problem                                          | Fix                                                 |
| --- | ------------------------------------ | ------------------------------------------------ | --------------------------------------------------- |
| 8   | **Navigation by filename**           | AI cannot intent-match                           | Use natural language intent in left column          |
| 9   | **Overlapping navigation entries**   | Similar descriptions pointing to different files | Use clearly distinct natural language per row       |
| 10  | **Inconsistent cross-project terms** | AI spends extra tokens aligning semantics        | Use identical phrasing for the same rule everywhere |

## Writing Standards

| #   | Anti-Pattern                     | Problem                                                       | Fix                                                   |
| --- | -------------------------------- | ------------------------------------------------------------- | ----------------------------------------------------- |
| 11  | **Mixed writing systems**        | Simplified/Traditional Chinese mix causes tokenizer ambiguity | Unify to a single writing system                      |
| 12  | **Unstructured mixed languages** | AI cannot tell which terms are fixed English names            | Keep technical terms in English; unify prose language |

## Over-Governance

| #   | Anti-Pattern                                  | Problem                                                                                                                                                | Fix                                                                                                                                                                                                                                              |
| --- | --------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 13  | **Demanding full 4-layer docs on Day-1**      | Adoption cost too high — team gives up                                                                                                                 | Build only AGENTS.md + docs/README.md; rest is event-triggered                                                                                                                                                                                   |
| 14  | **Manual style guide writing**                | Subjective governance docs have no definitive answer — time-consuming and ineffective                                                                  | Let AI infer conventions from code; human reviews only                                                                                                                                                                                           |
| 15  | **Mandatory checklist without automation**    | Manual compliance rate decays over time                                                                                                                | Use Prompt Packs for AI-drafted output; human reviews                                                                                                                                                                                            |
| 16  | **Build once, never update**                  | Running INIT then never revisiting AGENTS.md — gradual staleness                                                                                       | Monthly quick review + UPDATE Prompt sync                                                                                                                                                                                                        |
| 17  | **Mixed governance**                          | Code rules and doc governance rules crammed into one file                                                                                              | AGENTS.md for code rules; docs/README.md for doc governance                                                                                                                                                                                      |
| 18  | **Real project names in examples**            | Exposes internal naming or personal paths                                                                                                              | Use `my-*` / `sample-*` / `shared-*` in examples; avoid real repo names and personal absolute paths                                                                                                                                              |
| 19  | **Backfill all existing APIs at once**        | Low ROI, drains development track energy; Dead Zone APIs (long-idle, no consumers) produce SPECs nobody reads                                          | Brownfield backfill by priority: recently changed > cross-system dependency > complex logic; Dead Zone APIs can permanently skip SPEC                                                                                                            |
| 20  | **Mixing To-Be into backfill SPECs**          | "Current code behavior" and "future ideal" in one SPEC — AI cannot tell which is the binding constraint                                                | As-Is principle: SPEC describes current behavior; improvements go in SPEC TODO section or a separate ADR                                                                                                                                         |
| 21  | **Bloated unfocused AGENTS.md**               | Clearly too long with generic advice AI already knows ("write clean code", language built-in conventions) — core rules diluted, AI violations increase | Apply the per-line self-check: "Would removing this line cause AI to make an error?" If not, remove it. Move low-frequency content to docs/ sub-files ([GUIDE Section 3.4](GUIDE.md#34-guardrails-against-instruction-overload))                 |
| 22  | **Adding more rules when AI keeps violating** | AI ignores an existing rule → add a similar rule → AGENTS.md grows → violations get worse — a vicious cycle                                            | First diagnose: is it a length problem or an ambiguity problem? After 2+ repeated violations, trim or rewrite the original rule instead of stacking ([DAILY-USAGE Section 5.6](DAILY-USAGE.md#56-ai-repeatedly-violates-the-same-agentsmd-rule)) |

---

*This list is updated as new patterns emerge. Contributions welcome.*
