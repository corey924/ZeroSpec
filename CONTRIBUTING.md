# Contributing to ZeroSpec

> Derived from: [CONTRIBUTING.zh-TW.md](CONTRIBUTING.zh-TW.md) @ commit 96d51d5 | Last sync: 2026-04-25

> **🌐 [台灣正體中文版](CONTRIBUTING.zh-TW.md)**

Thank you for helping improve ZeroSpec.

This project has a clear goal: **provide AI-readable, maintainable project baselines at minimal cost.** All contributions should prioritize:

- Keep it simple — do not introduce heavy processes for completeness
- Prioritize readability, maintainability, and cross-agent stability
- Avoid unnecessary files, configs, or redundant explanations
- Docs, Prompts, templates, and CI assertions MUST stay consistent

## Welcome Contributions

- Fix Prompt ambiguities, contradictions, or misleading phrasing
- Improve consistency across README, GUIDE, DAILY-USAGE, and examples
- Strengthen CI scripts to catch errors earlier
- Improve cross-agent compatibility, Markdown stability, and token efficiency
- Add verified examples or real-world usage scenarios

## Not Recommended

- Expanding processes purely for completeness
- Introducing CLI tools, frameworks, or extra runtimes
- Pre-creating large numbers of unused empty files
- Making the project heavily dependent on a single AI platform

## Before Submitting a PR

1. Your change solves a clear problem or makes existing content clearer and more stable
2. If modifying `prompts/`, `templates/`, `scripts/`, or `examples/`, check whether `README.md`, `GUIDE.md`, `DAILY-USAGE.md`, `CHANGELOG.md` also need updates
3. If modifying CI assertions, run `bash scripts/verify-zerospec.sh` first
4. If introducing a new governance convention, document it — do not leave it only in PR comments
5. Keep PR scope focused — avoid mixing different types of changes in one PR

## PR Writing Tips

GitHub auto-populates the PR Template on submission — fill in each field.

## Suggested PR Types

- `docs:` Navigation, explanations, tutorials, naming adjustments
- `prompts:` Prompt structure, rules, semantic fixes
- `templates:` Template fields or format fixes
- `scripts:` CI scripts and verification improvements
- `examples:` Example content updates

## Review Preferences

- Small, focused PRs merge faster than large, sweeping ones
- For rule changes, explain **why** the new version is more stable
- For content removal, confirm the remaining content still covers what's needed

## Discussion Norms

Discuss professionally, respectfully, and collaboratively. When opinions differ, use verifiable cases, real-world experience, and maintenance cost as decision criteria.

For general community behavior expectations, see [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md).
