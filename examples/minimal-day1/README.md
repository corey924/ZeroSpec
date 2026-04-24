# minimal-day1 Example

This example shows a **Day-1 output immediately after running INIT-SCAN + INIT-BUILD**.

## Contents

- `AGENTS.md` — minimal AI navigation guide (~60 lines)
- `docs/README.md` — docs governance hub

## Design Intent

- **Essential sections only**: Project Summary, domain map (3 modules), core rules, common commands
- **No full docs navigation**: Day-1 has no `docs/` files yet to navigate to
- **Candidate documents ready**: `docs/README.md` Lazy Evaluation table lists the recommended first SPEC
- **Grows with the project**: add modules via UPDATE Prompt; formalize APIs via SPEC Prompt as they stabilize

## Day-1 vs. Mature Example Comparison

| Aspect                     | Day-1 (this example) | Mature (other examples)           |
| -------------------------- | -------------------- | --------------------------------- |
| Domain map entries         | 3                    | 8–12                              |
| Docs navigation table      | docs/README.md only  | Full SA / SPEC / ADR navigation   |
| Code generation rule count | 3–5                  | 10–15                             |
| Related Projects section   | Omitted              | Includes relative paths and notes |
