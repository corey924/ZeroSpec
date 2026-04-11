#!/usr/bin/env bash

set -euo pipefail

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
    pass "檔案存在：$file"
  else
    fail "檔案不存在：$file"
  fi
}

assert_grep() {
  local pattern="$1"
  local file="$2"
  if grep -Eq "$pattern" "$file"; then
    pass "符合規則：$file / $pattern"
  else
    fail "未符合規則：$file / $pattern"
  fi
}

assert_no_grep() {
  local pattern="$1"
  local file="$2"
  if grep -Eq "$pattern" "$file"; then
    fail "不應出現但找到：$file / $pattern"
  else
    pass "未發現禁用內容：$file / $pattern"
  fi
}

assert_first_line_starts_with_header() {
  local file="$1"
  local first_line
  first_line="$(head -n 1 "$file" || true)"
  if [[ "$first_line" == \#* ]]; then
    pass "首行為標題：$file"
  else
    fail "首行不是標題（可能有外層 code fence）：$file"
  fi
}

assert_count_eq() {
  local pattern="$1"
  local file="$2"
  local expected="$3"
  local actual
  actual="$(grep -Ec "$pattern" "$file" || true)"
  if [[ "$actual" == "$expected" ]]; then
    pass "數量符合：$file / $pattern = $expected"
  else
    fail "數量不符：$file / $pattern，預期 $expected，實際 $actual"
  fi
}

echo "=== ZeroSpec 驗收開始（macOS/Linux） ==="

assert_file_exists "prompts/INIT-SCAN.md"
assert_file_exists "prompts/INIT-BUILD.md"
assert_file_exists "prompts/UPDATE.md"
assert_file_exists "prompts/SPEC.md"
assert_file_exists "prompts/ADR.md"
assert_file_exists "prompts/SA.md"

assert_file_exists "templates/DOCS-README-TEMPLATE.md"
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
assert_first_line_starts_with_header "templates/DOCS-README-TEMPLATE.md"
assert_first_line_starts_with_header "templates/SA-TEMPLATE.md"
assert_first_line_starts_with_header "examples/minimal-day1/AGENTS.md"
assert_first_line_starts_with_header "examples/minimal-day1/docs/README.md"

assert_grep "## 前置條件" "prompts/SPEC.md"
assert_grep "## 前置條件" "prompts/ADR.md"
assert_grep "## 前置條件" "prompts/SA.md"

assert_grep "docs/README\.md" "prompts/SPEC.md"
assert_grep "docs/README\.md" "prompts/ADR.md"
assert_grep "docs/README\.md" "prompts/SA.md"
assert_grep "讀取既有文件（若為更新）" "prompts/SPEC.md"
assert_grep "Plan 模式可讀取 codebase" "prompts/INIT-SCAN.md"

assert_grep "DAILY-USAGE\.md" "README.md"
assert_grep "DAILY-USAGE\.md" "GUIDE.md"

assert_file_exists "examples/dotnet-dual-api/docs/README.md"
assert_file_exists "examples/java-library/docs/README.md"
assert_file_exists "examples/python-package/docs/README.md"
assert_file_exists "examples/react-nx-monorepo/docs/README.md"

assert_grep "booking-backend" "examples/dotnet-dual-api/docs/README.md"
assert_grep "edge-comm-core" "examples/java-library/docs/README.md"
assert_grep "etl-pipeline-core" "examples/python-package/docs/README.md"
assert_grep "inventory-frontend" "examples/react-nx-monorepo/docs/README.md"

assert_no_grep "就就位" "GUIDE.md"

assert_grep "跨模組共用元件的設計決策" "prompts/INIT-BUILD.md"
assert_grep "長度指引" "prompts/INIT-BUILD.md"

assert_count_eq "^---BEGIN PROMPT---$" "prompts/INIT-SCAN.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/INIT-BUILD.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/UPDATE.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/SPEC.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/ADR.md" 1
assert_count_eq "^---BEGIN PROMPT---$" "prompts/SA.md" 1

assert_count_eq "^---END PROMPT---$" "prompts/INIT-SCAN.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/INIT-BUILD.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/UPDATE.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/SPEC.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/ADR.md" 1
assert_count_eq "^---END PROMPT---$" "prompts/SA.md" 1

assert_count_eq "^\`\`\`\`$" "prompts/INIT-SCAN.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/INIT-BUILD.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/UPDATE.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/SPEC.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/ADR.md" 2
assert_count_eq "^\`\`\`\`$" "prompts/SA.md" 2

assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/SPEC.md"
assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/ADR.md"
assert_no_grep "templates/DOCS-README-TEMPLATE\\.md" "prompts/SA.md"

echo "=== 驗收摘要 ==="
echo "PASS: $pass_count"
echo "FAIL: $fail_count"

if [[ $fail_count -gt 0 ]]; then
  exit 1
fi

echo "結果：全部檢查通過"
