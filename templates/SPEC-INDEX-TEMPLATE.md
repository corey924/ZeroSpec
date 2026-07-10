# docs/spec/ — Interface Specification Index

> Copy this template to `docs/spec/README.md` when the directory contains ≥ 8 SPEC files.
> When instantiating this template, localize human-facing prose and table labels to the repository language or explicit `Respond in {locale}` override.
> Keep file paths, code identifiers, SPEC filenames, commands, and links literal.
> This file is a **navigation layer only** — do NOT duplicate contract details from individual SPECs.
> Each SPEC remains the narrative source of truth for its owned behavior. Link to any machine-verifiable contract instead of duplicating it.

## Purpose

`docs/spec/` holds all interface contracts for this project. This index provides situational lookup, maintenance rule mapping, and status overview. For individual endpoint definitions, DTO schemas, and business rules, read the corresponding SPEC directly.

## Document Index

> Update this table whenever a SPEC is added, renamed, or removed.

| SPEC | Subject | Scope | Primary Audience | Status |
| ---- | ------- | ----- | ---------------- | ------ |
| —    | —       | —     | —                | —      |

## How to Choose a SPEC

> Map common task scenarios to the right SPEC. This helps both AI agents and human developers quickly locate the relevant contract.

| Scenario / Task | Read |
| --------------- | ---- |
| —               | —    |

## Maintenance Rules

> Map code change types to the SPECs that may own their narrative behavior.

- Apply `docs/README.md` Contract Ownership before updating a SPEC. Update an in-scope narrative SPEC; otherwise record why the machine contract or no narrative update is sufficient.
- Each SPEC update modifies only affected sections + appends one Changelog row
- Do NOT rewrite unchanged contract content

## Status Guide

| Status                | Meaning                                                                    |
| --------------------- | -------------------------------------------------------------------------- |
| Active                | Serving as current integration or implementation reference                 |
| Draft                 | Inventoried from current code; pending human review of boundary conditions |
| Draft (Internal Only) | For local/dev/internal testing only; not a formal external contract        |
| Planned               | Future design; does not represent currently callable API                   |
