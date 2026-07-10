#!/usr/bin/env bash

set -euo pipefail

# Keep a predictable PATH in restricted CI shells.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:${PATH:-}"

for required_cmd in dirname grep cut head cmp; do
  if ! command -v "$required_cmd" >/dev/null 2>&1; then
    echo "FAIL: Required command not found in PATH: $required_cmd"
    exit 1
  fi
done

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

pass_count=0
fail_count=0

pass() {
  echo "PASS: $1"
  pass_count=$((pass_count + 1))
}

fail() {
  echo "FAIL: $1"
  fail_count=$((fail_count + 1))
}

assert_file_exists() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "File exists: $file"
  else
    fail "File not found: $file"
  fi
}

assert_grep() {
  local pattern="$1"
  local file="$2"
  if grep -Eq "$pattern" "$file"; then
    pass "Rule matched: $file / $pattern"
  else
    fail "Rule not matched: $file / $pattern"
  fi
}

assert_no_grep() {
  local pattern="$1"
  local file="$2"
  if grep -Eq "$pattern" "$file"; then
    fail "Forbidden content found: $file / $pattern"
  else
    pass "No forbidden content: $file / $pattern"
  fi
}

assert_first_line_starts_with_header() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    fail "File not found (skipping header check): $file"
    return
  fi
  local first_line
  first_line="$(head -n 1 "$file" || true)"
  if [[ "$first_line" == \#* ]]; then
    pass "First line is header: $file"
  else
    fail "First line is not a header (possible outer code fence): $file"
  fi
}

assert_count_eq() {
  local pattern="$1"
  local file="$2"
  local expected="$3"
  local actual
  actual="$(grep -Ec "$pattern" "$file" || true)"
  if [[ "$actual" == "$expected" ]]; then
    pass "Count matched: $file / $pattern = $expected"
  else
    fail "Count mismatch: $file / $pattern, expected $expected, actual $actual"
  fi
}

assert_files_equal() {
  local expected="$1"
  local actual="$2"
  if [[ ! -f "$expected" || ! -f "$actual" ]]; then
    fail "Cannot compare missing files: $expected / $actual"
    return
  fi
  if cmp -s "$expected" "$actual"; then
    pass "Files match: $expected == $actual"
  else
    fail "Files differ: $expected != $actual"
  fi
}

assert_order() {
  local first_pattern="$1"
  local second_pattern="$2"
  local file="$3"
  local rule_name="$4"
  local first_line
  local second_line

  first_line="$(grep -nEm1 "$first_pattern" "$file" | cut -d: -f1 || true)"
  second_line="$(grep -nEm1 "$second_pattern" "$file" | cut -d: -f1 || true)"

  if [[ -z "$first_line" || -z "$second_line" ]]; then
    fail "Order check failed (missing match): $rule_name"
    return
  fi

  if (( first_line < second_line )); then
    pass "Order matched: $rule_name"
  else
    fail "Order mismatch: $rule_name"
  fi
}

echo "=== ZeroSpec Verification Started (macOS/Linux) ==="

assert_file_exists "prompts/INIT-SCAN.md"
assert_file_exists "prompts/INIT-BUILD.md"
assert_file_exists "prompts/UPDATE.md"
assert_file_exists "prompts/SPEC.md"
assert_file_exists "prompts/ADR.md"
assert_file_exists "prompts/SA.md"
assert_file_exists "prompts/AUDIT.md"
assert_file_exists "prompts/DRIFT.md"
assert_file_exists ".github/pull_request_template.md"
assert_file_exists ".github/ISSUE_TEMPLATE/config.yml"
assert_file_exists ".github/ISSUE_TEMPLATE/bug-report.md"
assert_file_exists ".github/ISSUE_TEMPLATE/docs-or-wording.md"
assert_file_exists ".github/ISSUE_TEMPLATE/feature-request.md"
assert_file_exists "CODE_OF_CONDUCT.md"
assert_file_exists "CODE_OF_CONDUCT.zh-TW.md"
assert_file_exists "SECURITY.md"
assert_file_exists "SECURITY.zh-TW.md"
assert_file_exists "SUPPORT.md"
assert_file_exists "SUPPORT.zh-TW.md"

assert_file_exists "templates/DOCS-README-TEMPLATE.md"
assert_file_exists "templates/SPEC-INDEX-TEMPLATE.md"
assert_file_exists "templates/SPEC-TEMPLATE.md"
assert_file_exists "templates/ADR-TEMPLATE.md"
assert_file_exists "templates/SA-TEMPLATE.md"
assert_file_exists "DAILY-USAGE.md"

assert_file_exists "examples/minimal-day1/AGENTS.md"
assert_file_exists "examples/minimal-day1/docs/README.md"

assert_first_line_starts_with_header "prompts/INIT-SCAN.md"
assert_first_line_starts_with_header "prompts/INIT-BUILD.md"
assert_first_line_starts_with_header "prompts/UPDATE.md"
assert_first_line_starts_with_header "prompts/SPEC.md"
assert_first_line_starts_with_header "prompts/ADR.md"
assert_first_line_starts_with_header "prompts/SA.md"
assert_first_line_starts_with_header "prompts/AUDIT.md"
assert_first_line_starts_with_header "prompts/DRIFT.md"
assert_first_line_starts_with_header "templates/DOCS-README-TEMPLATE.md"
assert_first_line_starts_with_header "templates/SA-TEMPLATE.md"
assert_first_line_starts_with_header "examples/minimal-day1/AGENTS.md"
assert_first_line_starts_with_header "examples/minimal-day1/docs/README.md"

assert_grep "## Prerequisites" "prompts/SPEC.md"
assert_grep "## Prerequisites" "prompts/ADR.md"
assert_grep "## Prerequisites" "prompts/SA.md"
assert_grep "^## Limitations$" "prompts/AUDIT.md"
assert_no_grep "^## 限制$" "prompts/AUDIT.md"
assert_grep "### 8\. Domain-to-Code Map" "prompts/AUDIT.md"
assert_grep "### 9\." "prompts/AUDIT.md"
assert_grep "Actionable Fix List" "prompts/AUDIT.md"

# English Markdown must not contain Han characters. Localized content belongs only
# in explicitly named language variants such as *.zh-TW.md.
while IFS= read -r english_asset; do
  assert_no_grep "[一-龥]" "$english_asset"
done < <(find . -type f -name '*.md' ! -name '*zh-TW.md' ! -path './.git/*' -print)

assert_grep "^## Background / Problem$" ".github/pull_request_template.md"
assert_grep "^## SDD Sync Checklist$" ".github/pull_request_template.md"
assert_no_grep "背景 / 問題|SDD 同步檢查項|驗證方式|額外說明" ".github/pull_request_template.md"
assert_grep "^This file tracks the version history of the ZeroSpec framework\\.$" "CHANGELOG.md"

assert_grep "docs/README\.md" "prompts/SPEC.md"
assert_grep "docs/README\.md" "prompts/ADR.md"
assert_grep "docs/README\.md" "prompts/SA.md"
assert_grep "Read existing document" "prompts/SPEC.md"
assert_grep "Plan mode can read the codebase" "prompts/INIT-SCAN.md"

assert_grep "DAILY-USAGE\.md" "README.md"
assert_grep "DAILY-USAGE\.md" "GUIDE.md"
assert_grep "DAILY-USAGE\.md#22-coexistence-of-copilot-instructionsmd-and-agentsmd" "README.md"
assert_grep "GUIDE\.md#7-adoption-and-continuous-operation" "README.md"
assert_grep "#getting-started-under-30-minutes" "README.md"
assert_grep "^## Getting Started \(Under 30 Minutes\)" "README.md"
assert_grep "GUIDE\.md#34-guardrails-against-instruction-overload" "anti-patterns.md"
assert_grep "DAILY-USAGE\.md#56-ai-repeatedly-violates-the-same-agentsmd-rule" "anti-patterns.md"
assert_grep '^### 2\.2 Coexistence of .*copilot-instructions\.md.*AGENTS\.md' "DAILY-USAGE.md"
assert_grep "^### 5\.6 AI Repeatedly Violates the Same AGENTS\.md Rule" "DAILY-USAGE.md"
assert_grep "^### 3\.4 Guardrails Against Instruction Overload" "GUIDE.md"
assert_grep "^## 7\. Adoption and Continuous Operation" "GUIDE.md"

assert_grep "## Quick Constraints" "README.md"
assert_grep "orchestration.*validation.*transaction logic.*Service" "README.md"
assert_grep "all data access.*Repository/Service abstraction" "README.md"
assert_grep "avoid verb-based paths.*multi-version mixing" "README.md"

assert_grep "Responsibility definition" "GUIDE.md"
assert_grep "decision source is C3 \(human decision\)" "GUIDE.md"

assert_grep "Contract Ownership" "GUIDE.md"
assert_grep "Contract Ownership" "templates/DOCS-README-TEMPLATE.md"

assert_grep "Quick Constraints as a pinned projection of C3 decisions" "prompts/UPDATE.md"
assert_grep "write only after user confirmation" "prompts/UPDATE.md"
assert_grep "Code-to-Docs Map" "prompts/UPDATE.md"
assert_grep "mandatory post-edit checklist" "prompts/UPDATE.md"
assert_grep "^## Code-to-Docs Map$" "AGENTS.md"
assert_grep "^## Post-Edit Self-Check$" "AGENTS.md"

assert_order "^## Quick Constraints$" "^## Domain-to-Code Map$" "prompts/INIT-BUILD.md" "INIT-BUILD: Quick Constraints before Domain-to-Code Map"
assert_order "^## Domain-to-Code Map$" "^## GenAI Docs Navigation$" "prompts/INIT-BUILD.md" "INIT-BUILD: Domain-to-Code Map before GenAI Docs Navigation"

assert_file_exists "examples/dotnet-dual-api/docs/README.md"
assert_file_exists "examples/java-library/docs/README.md"
assert_file_exists "examples/python-package/docs/README.md"
assert_file_exists "examples/react-nx-monorepo/docs/README.md"

# examples: docs instance files (v0.4.1)
assert_file_exists "examples/dotnet-dual-api/docs/analysis/SA-001_system-overview.md"
assert_file_exists "examples/dotnet-dual-api/docs/spec/SPEC-001_api-auth-and-rbac.md"
assert_file_exists "examples/dotnet-dual-api/docs/adr/ADR-001_dual-host-api-architecture.md"
assert_file_exists "examples/java-library/docs/spec/SPEC-001_communication-core-service-interface.md"

assert_grep "booking-backend" "examples/dotnet-dual-api/docs/README.md"
assert_grep "edge-comm-core" "examples/java-library/docs/README.md"
assert_grep "etl-pipeline-core" "examples/python-package/docs/README.md"
assert_grep "inventory-frontend" "examples/react-nx-monorepo/docs/README.md"

# examples i18n: English primary + zh-TW copies (v0.4.1)
assert_file_exists "examples/minimal-day1/AGENTS.zh-TW.md"
assert_file_exists "examples/minimal-day1/README.zh-TW.md"
assert_file_exists "examples/minimal-day1/docs/README.zh-TW.md"
assert_file_exists "examples/dotnet-dual-api/AGENTS.zh-TW.md"
assert_file_exists "examples/dotnet-dual-api/docs/README.zh-TW.md"
assert_file_exists "examples/java-library/AGENTS.zh-TW.md"
assert_file_exists "examples/java-library/docs/README.zh-TW.md"
assert_file_exists "examples/python-package/AGENTS.zh-TW.md"
assert_file_exists "examples/python-package/docs/README.zh-TW.md"
assert_file_exists "examples/react-nx-monorepo/AGENTS.zh-TW.md"
assert_file_exists "examples/react-nx-monorepo/docs/README.zh-TW.md"

# examples zh-TW docs index sync (projects with instantiated docs)
assert_grep "SA-001_system-overview\\.md" "examples/dotnet-dual-api/docs/README.zh-TW.md"
assert_grep "SPEC-001_api-auth-and-rbac\\.md" "examples/dotnet-dual-api/docs/README.zh-TW.md"
assert_grep "ADR-001_dual-host-api-architecture\\.md" "examples/dotnet-dual-api/docs/README.zh-TW.md"
assert_no_grep "尚無文件" "examples/dotnet-dual-api/docs/README.zh-TW.md"

assert_grep "SPEC-001_communication-core-service-interface\\.md" "examples/java-library/docs/README.zh-TW.md"
assert_no_grep "尚無文件" "examples/java-library/docs/README.zh-TW.md"

# examples zh-TW docs index keeps Day-1 placeholders
assert_grep "尚無文件" "examples/minimal-day1/docs/README.zh-TW.md"
assert_grep "尚無文件" "examples/python-package/docs/README.zh-TW.md"
assert_grep "尚無文件" "examples/react-nx-monorepo/docs/README.zh-TW.md"

# examples: Quick Constraints present in all AGENTS.md
assert_grep "## Quick Constraints" "examples/minimal-day1/AGENTS.md"
assert_grep "## Quick Constraints" "examples/dotnet-dual-api/AGENTS.md"
assert_grep "## Quick Constraints" "examples/java-library/AGENTS.md"
assert_grep "## Quick Constraints" "examples/python-package/AGENTS.md"
assert_grep "## Quick Constraints" "examples/react-nx-monorepo/AGENTS.md"

assert_no_grep "就就位" "GUIDE.md"

# Sub-index localization rules (v0.4.3)
assert_grep "Language rule" "GUIDE.md"
assert_grep "語言規則" "GUIDE.zh-TW.md"
assert_grep "localize human-facing prose" "templates/SPEC-INDEX-TEMPLATE.md"
assert_grep "Localize human-facing README content" "prompts/UPDATE.md"
assert_grep "existing locale" "prompts/SPEC.md"
assert_grep "Sub-index threshold reached" "prompts/SPEC.md"

assert_grep "design decisions for cross-module shared components" "prompts/INIT-BUILD.md"
assert_grep "Length guideline" "prompts/INIT-BUILD.md"

assert_count_eq "^---BEGIN PROMPT---$" "prompts/INIT-SCAN.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/INIT-BUILD.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/UPDATE.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/SPEC.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/ADR.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/SA.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/DRIFT.md" 1

assert_count_eq "^---END PROMPT---$" "prompts/INIT-SCAN.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/INIT-BUILD.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/UPDATE.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/SPEC.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/ADR.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/SA.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/DRIFT.md" 1

assert_count_eq "^\`\`\`\`$" "prompts/INIT-SCAN.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/INIT-BUILD.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/UPDATE.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/SPEC.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/ADR.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/SA.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/DRIFT.md" 2

# DRIFT.md required sections
assert_grep "^## Trigger Conditions$" "prompts/DRIFT.md"
assert_grep "^## Prerequisites$" "prompts/DRIFT.md"
assert_grep "^## Relationship to Other Prompts$" "prompts/DRIFT.md"

assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/SPEC.md"
assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/ADR.md"
assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/SA.md"

# Greenfield / Brownfield adoption path (v0.3)
assert_grep "Step 3\\.5" "GUIDE.md"
assert_grep "Greenfield" "GUIDE.md"
assert_grep "Brownfield" "GUIDE.md"
assert_grep "As-Is" "GUIDE.md"
assert_grep "Brownfield" "README.md"
assert_grep "Scenario F" "DAILY-USAGE.md"
assert_grep "Greenfield|Brownfield" "prompts/INIT-BUILD.md"
assert_grep "Backfill all existing APIs.*once" "anti-patterns.md"

# i18n: zh-TW variants exist (v0.4)
assert_file_exists "README.zh-TW.md"
assert_file_exists "GUIDE.zh-TW.md"
assert_file_exists "DAILY-USAGE.zh-TW.md"
assert_file_exists "anti-patterns.zh-TW.md"
assert_file_exists "CONTRIBUTING.zh-TW.md"

# Skill-style adapter assets (v0.5.1)
assert_file_exists "skills/zerospec/SKILL.md"
assert_file_exists "skills/README.md"
assert_file_exists "scripts/sync-skills.sh"
assert_file_exists "scripts/sync-skills.ps1"
assert_file_exists "skills/zerospec/prompts/INIT-SCAN.md"
assert_file_exists "skills/zerospec/prompts/INIT-BUILD.md"
assert_file_exists "skills/zerospec/prompts/UPDATE.md"
assert_file_exists "skills/zerospec/prompts/AUDIT.md"
assert_file_exists "skills/zerospec/prompts/DRIFT.md"
assert_file_exists "skills/zerospec/prompts/SPEC.md"
assert_file_exists "skills/zerospec/prompts/ADR.md"
assert_file_exists "skills/zerospec/prompts/SA.md"
assert_grep "^name: zerospec$" "skills/zerospec/SKILL.md"
assert_grep "Route Table" "skills/zerospec/SKILL.md"
assert_grep "Self-Review" "skills/zerospec/SKILL.md"
assert_grep "prompts/AUDIT\.md" "skills/zerospec/SKILL.md"
assert_grep "sync-skills" "skills/README.md"
assert_grep "sync-skills\.sh --install" "skills/README.md"
assert_grep "sync-skills\.ps1 -Install" "skills/README.md"
for prompt_file in INIT-SCAN.md INIT-BUILD.md UPDATE.md AUDIT.md DRIFT.md SPEC.md ADR.md SA.md; do
  assert_files_equal "prompts/$prompt_file" "skills/zerospec/prompts/$prompt_file"
done
assert_grep "exclude-path skills/zerospec/prompts" ".github/workflows/verify-zerospec.yml"

# Risk-based contract discipline
assert_grep "Contract Ownership" "prompts/INIT-BUILD.md"
assert_grep "high-risk interface" "prompts/INIT-BUILD.md"
assert_grep "documented contract" "AGENTS.md"
assert_no_grep "prompts/IMPL\.md" "skills/zerospec/SKILL.md"
assert_file_exists "examples/optional-bridges/IMPL.md"
assert_no_grep "If interface, schema, permission, or business rules changed, update the relevant SPEC\." "prompts/INIT-BUILD.md"
assert_no_grep "If interface, schema, permission, or business rules changed, update the relevant SPEC\." "prompts/UPDATE.md"
for adapter_file in templates/prompts/*.prompt.md; do
  assert_no_grep "^mode:" "$adapter_file"
  assert_grep "^agent:" "$adapter_file"
  assert_grep "\]\(\.\./\.\./prompts/" "$adapter_file"
done

# PR template (v0.5.2)
assert_file_exists "templates/pull_request_template.md"
assert_grep "Docs Sync Checklist" "templates/pull_request_template.md"

# Post-Edit Self-Check in examples (v0.5.2 — warn only, does not affect PASS/FAIL)
echo "=== Post-Edit Self-Check presence in examples (warning only) ==="
for example_agents in examples/minimal-day1/AGENTS.md examples/minimal-day1/AGENTS.zh-TW.md \
                      examples/dotnet-dual-api/AGENTS.md examples/dotnet-dual-api/AGENTS.zh-TW.md \
                      examples/java-library/AGENTS.md examples/java-library/AGENTS.zh-TW.md \
                      examples/python-package/AGENTS.md examples/python-package/AGENTS.zh-TW.md \
                      examples/react-nx-monorepo/AGENTS.md examples/react-nx-monorepo/AGENTS.zh-TW.md; do
  if [[ -f "$example_agents" ]]; then
    if ! grep -Eq "## (Post-Edit Self-Check|完成前自我檢查)" "$example_agents"; then
      echo "WARNING: '$example_agents' is missing Post-Edit Self-Check section."
    fi
    if ! grep -Fq "Contract Ownership" "$example_agents"; then
      echo "WARNING: '$example_agents' is missing Contract Ownership guidance."
    fi
  fi
done

# === Bloat Check (warning only — does not affect PASS/FAIL) ===
echo "=== Bloat Check (warning only) ==="
for agents_file in examples/*/AGENTS.md; do
  if [[ -f "$agents_file" ]]; then
    read -r lines words < <(awk '{ w += NF } END { print NR, w }' "$agents_file")
    tokens=$(( words * 4 / 3 ))
    if [[ $lines -gt 300 || $tokens -gt 4000 ]]; then
      echo "WARNING: $agents_file may exceed GUIDE §3.4 limits (lines: $lines, est. tokens: ~$tokens). Review and trim."
    fi
  fi
done

echo "=== Verification Summary ==="
echo "PASS: $pass_count"
echo "FAIL: $fail_count"

if [[ $fail_count -gt 0 ]]; then
  exit 1
fi

echo "Result: All checks passed"
