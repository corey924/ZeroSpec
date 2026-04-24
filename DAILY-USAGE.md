# ZeroSpec Day-2+ User Guide

> This guide describes how engineers integrate ZeroSpec's SDD practices into daily development after Day-1 initialization.
> For teams that have completed INIT-SCAN + INIT-BUILD and have `AGENTS.md` + `docs/README.md` in place.

> Derived from: [DAILY-USAGE.zh-TW.md](DAILY-USAGE.zh-TW.md) @ commit 96d51d5 | Last sync: 2026-04-23

> **🌐 [台灣正體中文版](DAILY-USAGE.zh-TW.md)**

**Version**: v0.4 — 2026-04-23
**Audience**: Individual developers or small teams that have adopted ZeroSpec

---

## Table of Contents

1. [Three Daily Operation Modes](#1-three-daily-operation-modes)
2. [IDE and Agent Platform Configuration](#2-ide-and-agent-platform-configuration)
3. [ZeroSpec Itself: Reference, Not Resident](#3-zerospec-itself-reference-not-resident)
4. [Scenario Playbooks](#4-scenario-playbooks)
5. [Real Problems in Long-Term Maintenance](#5-real-problems-in-long-term-maintenance)
6. [Monthly / Quarterly Review Process](#6-monthly--quarterly-review-process)
7. [Scaling from Individual to Team](#7-scaling-from-individual-to-team)

---

## 1. Three Daily Operation Modes

After ZeroSpec adoption, daily work usually means Agent mode with your project's `AGENTS.md` in place. When properly configured, many AI Agents read `AGENTS.md` at startup or early in the task. In many day-to-day tasks, you will not need to open ZeroSpec's Prompt Packs.

### Mode A: Pure Coding (90% of the time)

Write code normally in Agent mode. In a well-configured setup, the Agent starts from `AGENTS.md` and uses it as the project constraint baseline.

**In many tasks, no explicit ZeroSpec step is required.**

> The intended outcome is that, after Day-1, ZeroSpec fades into the normal development workflow rather than becoming another checklist to manage.

### Mode B: Event-Triggered Doc Updates (~8%)

When a PR involves API additions, architecture decisions, or major changes, switch to "docs mode":

1. Open a new tab or conversation
2. Copy the relevant Prompt Pack from ZeroSpec (SPEC / ADR / SA)
3. Paste into Agent → draft generated → review → merge into PR

**Recommendation**: Treat doc updates as part of the PR scope, not as a separate follow-up task. Once the habit is in place, this often takes ~5–10 minutes.

### Mode C: Periodic Review (~2%)

Monthly or quarterly, run an UPDATE Prompt for a health check. See [Section 6](#6-monthly--quarterly-review-process).

---

## 2. IDE and Agent Platform Configuration

### Multi-Agent Entry File Quick Reference

Different AI platforms read different guidance files at startup or task start. The core principle: **prefer platform-specific entry files that import or reference `AGENTS.md`** rather than duplicating its content. Duplicated rules can create competing instruction sets and consume the agent's limited attention budget.

| Platform                     | Primary Entry File                              | Auto-Read                                                            | Pointer Strategy                                                    |
| ---------------------------- | ----------------------------------------------- | -------------------------------------------------------------------- | ------------------------------------------------------------------- |
| **GitHub Copilot (VS Code)** | `.github/copilot-instructions.md` + `AGENTS.md` | copilot-instructions ✅ / AGENTS.md ❌ (requires `@AGENTS.md` mention) | Add `@AGENTS.md` reference inside copilot-instructions              |
| **Cursor**                   | `AGENTS.md` / `.cursorrules`                    | ✅                                                                    | Keep AGENTS.md as source of truth; other entry files import from it |
| **Claude Code**              | `CLAUDE.md`                                     | ✅                                                                    | `@AGENTS.md` at top of CLAUDE.md (Claude Code import syntax)        |
| **Windsurf**                 | `AGENTS.md`                                     | ✅                                                                    | Use directly                                                        |
| **JetBrains AI Assistant**   | `AGENTS.md`                                     | ✅ (requires Attach project files enabled)                            | Use directly                                                        |

> Each platform is covered in detail in §2.2 (Copilot / Claude Code) and §2.4 (multi-root). This table is the at-a-glance reference.

### 2.1 ZeroSpec Repo Does NOT Need to Stay Open

ZeroSpec itself (`prompts/`, `templates/`, `GUIDE.md`) is a "toolbox," not a workspace dependency.

**Recommended approaches**:

| Approach       | Description                                                                   | Best For                                     |
| -------------- | ----------------------------------------------------------------------------- | -------------------------------------------- |
| **Bookmark**   | Bookmark ZeroSpec folder in browser or IDE; open and copy when needed         | Individual developers                        |
| **Snippet**      | Save frequently used Prompt Packs as IDE User Snippets or Text Expander                                                                              | Power users                                  |
| **Prompt Files** | Copy `templates/prompts/*.prompt.md` to your project's `.github/prompts/`; invoke the same Prompt Packs from supported VS Code prompt UIs             | VS Code users (optional adapter)             |
| **Pointers**     | Copy the matching file from `templates/pointers/` to your project; connects `AGENTS.md` to your AI platform without duplication                      | All platforms (Day-1 setup)                  |
| **Symlink**      | Create a `.zerospec/` symlink in target project pointing to ZeroSpec prompts/                                                                        | Multi-project ecosystems                     |
| **Copy-paste**   | Simplest — open ZeroSpec README, follow the link, copy the Prompt                                                                                   | Everyone (recommended Day-1 starting method) |

> **Do not** add the entire ZeroSpec folder to your target project's workspace. This causes the Agent to read irrelevant Markdown and wastes context.

> **Prompt Files setup**: These files rely on `#file:prompts/XXX.md`. Keep ZeroSpec in the same workspace (multi-root) or use a `.zerospec/` symlink so paths resolve. Pick one setup only.

### 2.2 Coexistence of `copilot-instructions.md` and `AGENTS.md`

GitHub Copilot supports both guidance files:

| File                              | Typical Read Timing                        | Best Content                                                    |
| --------------------------------- | ------------------------------------------ | --------------------------------------------------------------- |
| `.github/copilot-instructions.md` | Auto-read for each Copilot conversation    | Personal preferences, language, response format (cross-project) |
| `AGENTS.md`                       | Task start when supported, or by reference | Project-specific constraints (architecture, naming, tech stack) |

**Best practice**:

- `.github/copilot-instructions.md` → "who you are, how to respond" (personal profile sync)
- `AGENTS.md` → "how to write code in this project" (ZeroSpec output)
- They complement each other; no need to merge

#### Claude Code Compatibility (`CLAUDE.md` + `@AGENTS.md`)

Claude Code reads `CLAUDE.md` by default, not `AGENTS.md`. To reuse ZeroSpec's AGENTS.md output with zero duplication, create this `CLAUDE.md` at the repo root:

```markdown
@AGENTS.md

## Claude Code Specific Notes

(Leave empty if no special requirements)
```

- `@AGENTS.md` is Claude Code's import syntax — expanded at startup
- No copy needed → avoids dual-maintenance drift
- Other Agents (Copilot / Cursor / Codex / Windsurf) continue reading AGENTS.md
- Put Claude Code–only rules (e.g. Plan mode triggers) after the import

### 2.3 Plan Mode vs Agent Mode

| Scenario                       | Recommended Mode | Reason                                          |
| ------------------------------ | ---------------- | ----------------------------------------------- |
| **INIT-SCAN (analysis)**       | Either           | SCAN writes no files; Plan mode works fine      |
| **INIT-BUILD (build)**         | Agent            | Needs to write `AGENTS.md` and `docs/README.md` |
| **SPEC / ADR / SA generation** | Agent            | Needs to read code + write files                |
| **UPDATE review**              | Plan → Agent     | Plan to review diff report; Agent to write      |
| **Daily coding**               | Agent            | Needs read/write access                         |
| **Pre-PR doc check**           | Plan             | Only needs to judge "is a SPEC update needed?"  |
| **Architecture research**      | Plan / Chat      | Information gathering only; no file changes     |

**Practical tip**: UPDATE Prompt works best in two stages — Plan mode first to see the diff report, then Agent mode to apply changes.

### 2.4 Multi-Root Workspace Notes

When your IDE has multiple projects open (e.g. my-backend + my-frontend + shared-lib), the Agent sees all `AGENTS.md` files.

#### Core Problem: How does the Agent know which project your instruction targets?

IDE Agents typically use the **workspace folder of the currently active file** as primary context. Leverage this, plus a project-name prefix, to reliably lock the target.

#### Four Approaches Compared

| Approach                             | How                                                                   | Best For                            | Trade-offs                                         |
| ------------------------------------ | --------------------------------------------------------------------- | ----------------------------------- | -------------------------------------------------- |
| **Active File anchor** (recommended) | Before pasting the Prompt, click any file in the target project       | All IDE Agents                      | Zero cost; Agent infers from active context        |
| **Project name prefix**              | Start the Prompt with "Target project: {project name from AGENTS.md}" | Task-oriented conversations         | Clear and concise; name must match AGENTS.md title |
| **Explicit AGENTS.md reference**     | "Read `my-backend/AGENTS.md` as constraints for this task"            | When cross-project confusion occurs | Strongest anchor but verbose                       |
| **Full path**                        | Paste `/Users/xxx/Projects/my-project` in the Prompt                  | Ambiguous project names             | Precise but long; not portable across environments |

> **Recommended combo**: Active File anchor + project name prefix. Active File alone covers 90% of daily scenarios.

#### Platform Behavior Summary

| Platform                 | Primary Signal                            | Notes                                                      |
| ------------------------ | ----------------------------------------- | ---------------------------------------------------------- |
| GitHub Copilot (VS Code) | Active editor's workspace folder          | Multi-root: all folders visible; active file sets priority |
| Cursor                   | Composer Agent uses active file's project | Use `@file` to further specify                             |
| Claude Code              | `cwd` is context starting point           | `cd` to target project before launching                    |
| Windsurf                 | Cascade infers from active file           | Behavior similar to Copilot                                |

#### Example Naming in Open-Source Docs

To avoid leaking internal information, use generic names in public examples: `my-*`, `sample-*`, `shared-*`. Do not use real project names, personal paths, or identifiable details.

### 2.5 Long-Conversation Re-Anchor Strategy

AI Agents in long conversations (~15–20 rounds) may gradually drift from AGENTS.md constraints. The main cause is NOT that AGENTS.md is too long — it is that accumulated conversation history and tool outputs dilute the guidance file's attention weight. That said, keeping the file concise still improves re-anchor efficiency.

#### When to Re-Anchor

- Agent starts violating architecture rules (e.g. business logic in Controller)
- Conversation exceeds 15 rounds and next tasks involve core constraints
- Switching to a different business module

#### How to Re-Anchor

**Lightweight** (recommended for most scenarios):

```
Please re-read AGENTS.md and confirm all architecture constraints are followed going forward.
```

**Precise** (when you know which rule was violated):

```
You just wrote business logic in the Controller, violating AGENTS.md architecture constraints.
Re-read the "Quick Constraints" section of AGENTS.md, then fix.
```

**Full reset** (when conversation has drifted severely — start a new conversation):

```
This conversation's context is too bloated. Start a new conversation so the Agent reloads AGENTS.md fresh.
```

#### Re-Anchor Frequency Guide

| Conversation Rounds | Recommended Action                                     |
| ------------------- | ------------------------------------------------------ |
| 1–15 rounds         | Normal operation, no re-anchor needed                  |
| 15–25 rounds        | Lightweight re-anchor for architecture-sensitive tasks |
| 25+ rounds          | Start a new conversation                               |

> Thresholds assume 128K–200K context models. Smaller context windows may enter the dilution zone at 10–15 rounds — re-anchor sooner.

> **Why no automated mechanism?** ZeroSpec is a Layer 0 framework with no CLI or runtime dependency. Re-anchoring requires only a one-line reminder at the right moment.

#### Context Hygiene (Clear Before Implementation)

Beyond re-anchoring, context hygiene is key to maintaining Agent quality:

- **Clear irrelevant context before implementation**: Reviewing SPECs / discussing architecture → actually writing code are two different tasks. Use separate sessions. If the previous round was a long discussion, start a new conversation for implementation.
- **One task, one session**: Bugfix / new feature / refactor in separate conversations. Previous task's tool output interferes with the next task's judgment.
- **Export summary before switching sessions**: If continuity is needed across sessions, ask the AI to produce a ~150-word summary. Paste it as the starting point of the next session — do not carry full history.

> Reference: OpenSpec official usage notes explicitly recommend "clear your context before starting implementation." ZeroSpec has no automatic clearing mechanism at the Prompt layer, but these three principles achieve the same effect.

---

## 3. ZeroSpec Itself: Reference, Not Resident

### When You Need ZeroSpec Open

| Moment                                   | What You Need              | Time Cost     |
| ---------------------------------------- | -------------------------- | ------------- |
| PR involves API changes                  | `prompts/SPEC.md` Prompt   | 10 sec copy   |
| Cross-module technical decision          | `prompts/ADR.md` Prompt    | 10 sec copy   |
| Monthly review                           | `prompts/UPDATE.md` Prompt | 10 sec copy   |
| Forgot what a template looks like        | `templates/` directory     | 30 sec browse |
| Looking up an anti-pattern fix           | `anti-patterns.md`         | 1 min browse  |
| New team member learning the methodology | `GUIDE.md`                 | 15 min read   |

### When You Do NOT Need ZeroSpec Open

- Daily coding (Agent auto-reads `AGENTS.md`)
- Commit / Push / PR Review (only check project's SPEC and AGENTS.md)
- Debug / testing (unrelated to docs governance)

---

## 4. Scenario Playbooks

### Scenario A: Adding a New REST API

```
Timeline:
  1. Start writing the new API → Agent auto-reads AGENTS.md → generates code following rules
  2. After writing → you recall "AGENTS.md says API changes require SPEC update"
  3. Open ZeroSpec → copy SPEC Prompt → paste into Agent
  4. Agent reads existing SPEC → generates update draft → you review → include in PR
  5. Extra time: ~8 minutes
```

> For multi-file refactors or multiple new resources, follow Scenario G (Explore → Plan → Implement) for better Agent quality.

### Scenario B: Upgrading Spring Boot 3.5 → 4.0

```
Timeline:
  1. Complete framework upgrade + code adjustments
  2. Open ZeroSpec → copy UPDATE Prompt → paste into Agent (Plan mode)
  3. Agent detects build.gradle version change → lists AGENTS.md diffs
  4. Confirm → switch to Agent mode → write updates
  5. If upgrade involves architecture decisions (e.g. enabling Virtual Threads) → copy ADR Prompt next
  6. Extra time: ~15 minutes
```

### Scenario C: New Team Member Joins

```
Timeline:
  1. New member clones repo → opens IDE → Agent auto-reads AGENTS.md
  2. Asks "What's this project's architecture?" → Agent answers precisely from AGENTS.md
  3. Gets assigned a task → Agent-generated code automatically follows conventions
  4. For deeper understanding → AGENTS.md navigation table points to SA / SPEC / ADR
  5. New member does NOT need to know about ZeroSpec — just the project's AGENTS.md
```

### Scenario D: Monthly Review

```
Timeline:
  1. End of month → spend 2 minutes scanning GUIDE.md Section 7 quick review checklist
  2. Discover 3 new Services added last month but not in the domain-to-code map
  3. Copy UPDATE Prompt → Agent auto-detects diffs → suggests updates
  4. Confirm → write → commit
  5. Total time: ~15 minutes
```

### Scenario E: Judging SPEC Need During PR Review

```
Timeline:
  1. Reviewing someone's PR → see Controller with 2 new APIs
  2. Open AGENTS.md → docs sync triggers say "API changes require SPEC update"
  3. Comment on PR: "This change needs a SPEC draft via the SPEC Prompt"
  4. You don't do it yourself — just flag it
```

### Scenario F: First Month After Brownfield Adoption

```
Context: Your project has moderate-to-large API surface. INIT-BUILD just completed.
         AGENTS.md and docs/README.md are in place.

Week 1: Build Global Understanding
  1. Run SA Prompt → Agent produces system architecture snapshot (docs/analysis/SA-001.md)
  2. Identify APIs with code changes in the last 30 days → this is your Tier 1 backfill list
     (Full priority: recent changes > cross-system dependencies > complex logic — see GUIDE.md Section 7 Step 3.5)
  3. Run SPEC Prompt on the most important Tier 1 API → first SPEC created
  4. Commit SA + SPEC together → ZeroSpec officially launched

Week 2–4: Two Parallel Tracks
  Development track: All new/changed APIs → trigger SPEC normally (mandatory)
  Backfill track: Pick 1–2 Tier 1 APIs per week for SPEC (maintain pace; do not rush)

  As-Is principle for backfill SPECs:
  - Describe current code behavior, not ideal architecture
  - Record discovered issues in SPEC's TODO section; do not mix To-Be into As-Is

End-of-Month Review:
  - Count backfilled SPECs → check Tier 1 coverage
  - Any Dead Zone APIs (long idle, no consumers)? → mark "no backfill needed"
  - Is the development track running smoothly? → any API changes missing SPEC?

Extra time: Week 1 ~45–60 min (SA + first SPEC); Weeks 2–4 ~10–20 min/week
```

### Scenario G: Explore → Plan → Implement Rhythm (Recommended for Medium+ Tasks)

Most Agent platforms (Claude Code Plan mode, Copilot Chat, Cursor Composer) support "analyze first, implement later." For multi-file tasks, staged execution often yields better quality:

```
Task: Add OAuth login flow to my-backend (spans AuthController, SecurityConfig, User entity)

Step 1 — Explore (Plan mode)
  Paste: "Read src/auth/ for current session management, read SecurityConfig for filter chain. Write nothing."
  Output: Structured summary + impact scope list

Step 2 — Plan (same Plan mode)
  Paste: "Based on the above, propose an implementation plan for Google OAuth. List changes per file."
  Output: File-level change plan
  → Human reviews; edit or reject

Step 3 — Implement (switch to Agent mode / new conversation)
  Paste: "Implement per the plan above. Run make test to verify."
  → Agent writes code + runs verification

Step 4 — Commit & SPEC (same conversation)
  Paste: "This change affects Auth API. Generate SPEC via SPEC Prompt, then commit together."
```

**When to skip this rhythm**: Single-file typos, single-line log additions, simple renames — "diffs describable in one sentence." The planning overhead only pays off for complex tasks.

**Why it matters**: AGENTS.md provides structural constraints but cannot replace task-level planning. The Explore phase helps the Agent understand the task boundary before acting, which is a practical guard against "plausible-looking code that misses edge cases."

---

## 5. Real Problems in Long-Term Maintenance

### 5.1 "I Forgot to Update the SPEC"

**Root cause**: Event triggers depend on human discipline; no automatic reminders.

**Mitigation strategies**:
- **Lowest cost**: Add a checklist line to PR template: `- [ ] If API changed, did you run the SPEC Prompt?`
- **Medium cost**: During PR Review, build the habit — see Controller changes → ask "SPEC updated?"
- **Higher cost**: CI script detects Controller file changes without corresponding `docs/spec/` modifications; emits a warning

### 5.2 "Domain-to-Code Map Is Getting Stale"

**Root cause**: New modules added without updating the map; UPDATE Prompt is not auto-run.

**Mitigation strategies**:
- Set a monthly 15-minute "SDD Quick Review" calendar event
- UPDATE Prompt's diff report auto-detects added/removed Controllers and Services
- If the map lags by 3+ modules, Agent-generated code is often still usable — architecture rules (Tier C) usually matter more for correctness than the map itself. The map is primarily a navigation aid that helps the Agent find the right file faster.

### 5.3 "Team Members Don't Buy In"

**Root cause**: SDD gives immediate payoff to individuals (better Agent code quality), but team value requires accumulation.

**Gradual adoption strategy**: See [Section 7](#7-scaling-from-individual-to-team).

### 5.4 "I Want to Customize Prompt Packs"

**Perfectly normal and encouraged.** ZeroSpec is a starting point, not an endpoint.

**Customizable directions**:
- Add project-specific DTO naming conventions to SPEC Prompt
- Add team-required evaluation dimensions (cost, compliance) to ADR Prompt
- Add extra checks (e.g. i18n key sync) to UPDATE Prompt

**Customization principle**: Modify your project's Prompt copy, not ZeroSpec itself. This avoids conflicts when upgrading ZeroSpec.

#### Recommended Convention

```
<your-repo>/
├── AGENTS.md
├── docs/
└── .zerospec/
    └── prompts/
        ├── SPEC-custom.md      ← Your customized copy; -custom suffix signals modification
        ├── ADR-custom.md
        └── UPDATE-custom.md
```

- **Naming**: Original filename + `-custom` suffix; no suffix = unmodified, skip during diff
- **Location**: `.zerospec/prompts/` (or `docs/prompts/`); tracked by git
- **Upgrade comparison**: After upgrading ZeroSpec:
  ```
  diff <new-version>/prompts/SPEC.md .zerospec/prompts/SPEC-custom.md
  ```
  Review new sections in the official version → manually port them to the `-custom` copy.

#### When to Contribute Upstream

- Customization is used across multiple projects → consider PRing to ZeroSpec (make it officially supported)
- Single-project convention only → keep in the `-custom` copy; no need to contribute back

### 5.5 "docs/ Directory Keeps Growing — Should I Stop?"

**Decision criterion**: Does the document have a clear consumer?

| Consumer         | Doc Type | Keep Producing                                      |
| ---------------- | -------- | --------------------------------------------------- |
| AI Agent         | SPEC     | ✅ Update on every API change (Source of Truth)      |
| New members / AI | SA       | ⚠️ Only at milestones or when system snapshot needed |
| Team decisions   | ADR      | ⚠️ Only for either/or architectural decisions        |
| DevOps / AI      | INFRA    | ⚠️ Only on deployment changes                        |

If a document has never been referenced since creation, it probably should not exist.

### 5.6 AI Repeatedly Violates the Same AGENTS.md Rule

**Suggested investigation order**:

1. **AGENTS.md too long / core rules buried in noise**: File is noticeably long with generic knowledge the AI already has → core rules fall into the attention dilution zone
2. **Rule description is ambiguous**: Same rule described inconsistently in two places, or wording too abstract to verify (e.g. "write clean code")
3. **Conversation too long / context diluted**: Beyond 15–20 rounds, AGENTS.md attention weight is diluted by subsequent conversation output

**Diagnostic flow**:

```
1. Count AGENTS.md lines
   wc -l AGENTS.md
   → If noticeably long: apply GUIDE Section 3.4 per-line self-check; remove generic knowledge AI doesn't need reminding of

2. Inspect the violated rule's text
   → Is the same rule duplicated with inconsistent wording?
   → Is the rule verifiable (e.g. "Controller MUST NOT access DbContext") or abstract ("keep code clean")?
   → Make it specific or unify wording, then observe

3. If rule is already specific and AGENTS.md is not long, check conversation length
   → If > 15 rounds: use lightweight re-anchor (see Section 2.5)
   → If > 25 rounds: start a new conversation

4. Last resort: prefix the rule with IMPORTANT: or YOU MUST
   → But note: if every rule has emphasis, none does
```

**Do NOT**: Add a new rule "don't violate rule X." This only makes AGENTS.md longer and the problem worse (see [anti-patterns #22](anti-patterns.md)).

### 5.7 "Quick Validation That AGENTS.md Actually Works"

After writing or major updates to AGENTS.md, **run a quick test in a new conversation** (a few minutes) — more revealing than reading the whole file:

| Test Type       | Example Question                                                  | Expected Signal                                                       |
| --------------- | ----------------------------------------------------------------- | --------------------------------------------------------------------- |
| Navigation      | "Where is auth logic in this project?"                            | Points to actual paths from domain-to-code map, not generic guesses   |
| Rules           | "What are the path format and layer requirements for a new API?"  | Cites Quick Constraints or Code Generation Rules                      |
| Counter-example | Paste code with "DbContext in Controller" and ask "what's wrong?" | Accurately names the violated hard rule and suggests correct location |

**Interpreting results**:

- **Most correct**: AGENTS.md is healthy; proceed normally
- **Few wrong**: Strengthen navigation or rules for that specific domain
- **Mostly wrong**: Run [AUDIT Prompt](prompts/AUDIT.md) for a full audit

> Run this test after every major AGENTS.md change (e.g. after UPDATE Prompt writes, after Brownfield SPEC backfill).

### 5.8 Specifying Output Language (e.g. zh-TW)

All ZeroSpec Prompt Packs include this language rule:

> **Language**: Detect the repository's primary language from README, docs, and code comments. Respond in that language. Default to English if ambiguous.

This means the **prompt itself is always English** (instruction format), but the **generated output** (`AGENTS.md`, SPECs, ADRs) will usually match your project's detected language. In many repos, no manual action is needed.

**When auto-detection may fall short**: If your project's README is in English but you want `AGENTS.md` and `docs/` in a different language (e.g. zh-TW), the Agent may default to English. Use one of these overrides:

| Scope             | How                                                                                                       | When                          |
| ----------------- | --------------------------------------------------------------------------------------------------------- | ----------------------------- |
| **One-time**      | Prepend to the prompt: `Respond in zh-TW for all generated files.`                                        | Ad-hoc tasks or testing       |
| **Project-level** | Add to `AGENTS.md` header or `.github/copilot-instructions.md`: `All generated docs should be in zh-TW.`  | Team-wide consistency         |
| **Personal**      | Add to your IDE global instructions (e.g. `~/.copilot/instructions/`): `Prefer zh-TW for generated docs.` | Personal long-term preference |

**Recommendation**: For teams where everyone shares the same locale, use project-level. For mixed-language teams, let auto-detection work and use one-time override when needed.

---

## 6. Monthly / Quarterly Review Process

### Monthly Quick Review (15 minutes)

```
Steps:
1. Terminal → `git log --since="1 month ago" --oneline -- '*.java' '*.ts' '*.cs' | wc -l`
   → Sense this month's change volume

2. Open AGENTS.md → scan domain-to-code map
   → Any new Controllers / Services not listed?

3. Open docs/README.md → check document inventory
   → Any new files in docs/ not cataloged?

4. If gaps found → copy UPDATE Prompt → paste into Agent → get diff report
5. Confirm → write → commit → done
```

### Quarterly Full Review (30 minutes)

All monthly steps, plus:

```
Additional steps:
6. Review this quarter's Agent-generated PRs → repeated violations of the same rule?
   → If yes, improve that rule's clarity in AGENTS.md

7. Check AGENTS.md line count → noticeably long?
   → If yes, move low-frequency sections to docs/ sub-files

8. Confirm with team: are hard rules still valid?
   → Any rules "everyone silently violates but nobody updates the doc?"

9. If major architecture changes this quarter → consider running SA Prompt for a new system snapshot
```

---

## 7. Scaling from Individual to Team

### Phase 1: Individual Pioneer (Week 1–4)

- Run INIT-SCAN + INIT-BUILD yourself
- Use the generated `AGENTS.md` for development; feel the Agent quality improvement
- Quietly include SPEC updates in your PRs — let teammates see docs appearing naturally

### Phase 2: Passive Adoption (Month 2–3)

- Team members using Agent mode automatically benefit from `AGENTS.md` rules
- They don't need to know ZeroSpec exists — they just notice "the Agent understands our architecture now"
- Occasionally remind during PR Review: "API changes need a SPEC"

### Phase 3: Active Introduction (Quarter 2)

Once the team is used to AGENTS.md:

- Brief intro of SPEC Prompt + UPDATE Prompt in a team meeting (5 minutes)
- Add SDD Checklist to PR template
- Designate an "SDD gatekeeper" (not necessarily you) for monthly reviews

### Phase 4: Self-Sustaining (Quarter 3+)

- Everyone knows API changes require SPEC Prompt
- Monthly review becomes routine
- You only intervene at quarterly reviews

---

## Appendix: Common Questions

### Q: Do I need to keep ZeroSpec's README open all the time?

**No.** ZeroSpec's README is a "user manual," not a runtime dependency. Like React docs — you learn it, then look things up when needed.

### Q: Should ZeroSpec be added to `.github/copilot-instructions.md`?

**No.** `copilot-instructions.md` is for personal preferences (language, format, role). Project-level constraints belong in `AGENTS.md`. Separate responsibilities.

You CAN add a one-line reminder to `copilot-instructions.md`:

```markdown
## ⚡ Protocol: SDD
When handling PRs with API additions or behavior changes, proactively ask if SPEC needs updating.
```

### Q: Can I have the Agent auto-read ZeroSpec at every conversation start?

**Not recommended.** ZeroSpec itself (prompts/ + templates/ + GUIDE.md) totals thousands of lines and would significantly consume context window. The Agent only needs your project's concise `AGENTS.md`.

### Q: In a multi-person team, who runs the UPDATE Prompt?

**The person most familiar with the project architecture** — usually the Tech Lead or primary maintainer. Monthly reviews can rotate, but results need someone with architecture judgment to approve.

### Q: Documents keep growing — won't we end up with "too many docs nobody reads"?

ZeroSpec's design explicitly combats this:
- **Lazy Evaluation**: No pre-created empty shells; create on trigger only
- **SPEC is the only mandatory document**: Others are "nice to have," not required
- **Every document has a consumer**: SA for new members and Agents, ADR for future decision-makers, SPEC for daily Agent use
- If a document goes unreferenced for 3 months, consider archiving it

---

*This guide ships with ZeroSpec. Read it after one month of adoption — not needed on Day-1.*
