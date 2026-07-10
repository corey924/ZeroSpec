<!-- ZeroSpec downstream PR template — copy to .github/pull_request_template.md in your project -->
<!-- Adjust section names and links to match your project conventions -->

## Background / Problem
-

## Changes
-

## Docs Sync Checklist

<!-- SPEC impact: mandatory for an existing SPEC scope change or a high-risk interface change; state why if no narrative SPEC is needed -->
- [ ] **SPEC** — Contract Ownership assessed; existing SPEC scope or high-risk behavior updated + Changelog added, or reason recorded for machine-contract-only / no narrative update
- [ ] **ADR** — If this PR involves a cross-module either/or architectural decision → ADR created or updated
- [ ] **AGENTS.md** — If this PR changes module structure, routing conventions, or team hard rules → AGENTS.md updated (use ZeroSpec UPDATE prompt if needed)
- [ ] **No docs update needed** — state reason: `{reason}`

> If any SPEC was updated, paste the `### Docs Impact` block from the Agent's response here.

## Verification
- [ ] Build passes (`{build command}`)
- [ ] Tests pass (`{test command}`)
- [ ] If SPEC updated, the SPEC Changelog entry matches the code change

## Additional Notes
-
