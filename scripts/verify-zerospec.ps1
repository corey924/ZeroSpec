$ErrorActionPreference = 'Stop'

$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $Root

$script:PassCount = 0
$script:FailCount = 0

function Pass([string]$Message) {
    Write-Host "PASS: $Message"
    $script:PassCount++
}

function Fail([string]$Message) {
    Write-Host "FAIL: $Message"
    $script:FailCount++
}

function Assert-FileExists([string]$Path) {
    if (Test-Path -Path $Path -PathType Leaf) {
        Pass "File exists: $Path"
    }
    else {
        Fail "File not found: $Path"
    }
}

function Assert-Contains([string]$Path, [string]$Pattern) {
    if (Select-String -Path $Path -Pattern $Pattern -Quiet) {
        Pass "Rule matched: $Path / $Pattern"
    }
    else {
        Fail "Rule not matched: $Path / $Pattern"
    }
}

function Assert-NotContains([string]$Path, [string]$Pattern) {
    if (Select-String -Path $Path -Pattern $Pattern -Quiet) {
        Fail "Forbidden content found: $Path / $Pattern"
    }
    else {
        Pass "No forbidden content: $Path / $Pattern"
    }
}

function Assert-FirstLineStartsWithHeader([string]$Path) {
    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        Fail "File not found (skipping header check): $Path"
        return
    }
    $firstLine = Get-Content -Path $Path -TotalCount 1
    if ($null -ne $firstLine -and $firstLine.StartsWith('#')) {
        Pass "First line is header: $Path"
    }
    else {
        Fail "First line is not a header (possible outer code fence): $Path"
    }
}

function Assert-MatchCount([string]$Path, [string]$Pattern, [int]$ExpectedCount) {
    $matches = Select-String -Path $Path -Pattern $Pattern -AllMatches
    $actualCount = if ($null -eq $matches) { 0 } else { @($matches).Count }
    if ($actualCount -eq $ExpectedCount) {
        Pass "Count matched: $Path / $Pattern = $ExpectedCount"
    }
    else {
        Fail "Count mismatch: $Path / $Pattern, expected $ExpectedCount, actual $actualCount"
    }
}

function Assert-LineOrder([string]$Path, [string]$FirstPattern, [string]$SecondPattern, [string]$RuleName) {
    $firstMatch = Select-String -Path $Path -Pattern $FirstPattern | Select-Object -First 1
    $secondMatch = Select-String -Path $Path -Pattern $SecondPattern | Select-Object -First 1

    if ($null -eq $firstMatch -or $null -eq $secondMatch) {
        Fail "Order check failed (missing match): $RuleName"
        return
    }

    if ($firstMatch.LineNumber -lt $secondMatch.LineNumber) {
        Pass "Order matched: $RuleName"
    }
    else {
        Fail "Order mismatch: $RuleName"
    }
}

Write-Host "=== ZeroSpec Verification Started (Windows PowerShell) ==="

Assert-FileExists 'prompts/INIT-SCAN.md'
Assert-FileExists 'prompts/INIT-BUILD.md'
Assert-FileExists 'prompts/UPDATE.md'
Assert-FileExists 'prompts/SPEC.md'
Assert-FileExists 'prompts/ADR.md'
Assert-FileExists 'prompts/SA.md'
Assert-FileExists 'prompts/AUDIT.md'

Assert-FileExists 'templates/DOCS-README-TEMPLATE.md'
Assert-FileExists 'templates/SPEC-TEMPLATE.md'
Assert-FileExists 'templates/ADR-TEMPLATE.md'
Assert-FileExists 'templates/SA-TEMPLATE.md'
Assert-FileExists 'DAILY-USAGE.md'

Assert-FileExists 'examples/minimal-day1/AGENTS.md'
Assert-FileExists 'examples/minimal-day1/docs/README.md'

Assert-FirstLineStartsWithHeader 'prompts/INIT-SCAN.md'
Assert-FirstLineStartsWithHeader 'prompts/INIT-BUILD.md'
Assert-FirstLineStartsWithHeader 'prompts/UPDATE.md'
Assert-FirstLineStartsWithHeader 'prompts/SPEC.md'
Assert-FirstLineStartsWithHeader 'prompts/ADR.md'
Assert-FirstLineStartsWithHeader 'prompts/SA.md'
Assert-FirstLineStartsWithHeader 'prompts/AUDIT.md'
Assert-FirstLineStartsWithHeader 'templates/DOCS-README-TEMPLATE.md'
Assert-FirstLineStartsWithHeader 'templates/SA-TEMPLATE.md'
Assert-FirstLineStartsWithHeader 'examples/minimal-day1/AGENTS.md'
Assert-FirstLineStartsWithHeader 'examples/minimal-day1/docs/README.md'

Assert-Contains 'prompts/SPEC.md' '## Prerequisites'
Assert-Contains 'prompts/ADR.md' '## Prerequisites'
Assert-Contains 'prompts/SA.md' '## Prerequisites'

Assert-Contains 'prompts/SPEC.md' 'docs/README\.md'
Assert-Contains 'prompts/ADR.md' 'docs/README\.md'
Assert-Contains 'prompts/SA.md' 'docs/README\.md'
Assert-Contains 'prompts/SPEC.md' 'Read existing document'
Assert-Contains 'prompts/INIT-SCAN.md' 'Plan mode can read the codebase'

Assert-Contains 'README.md' 'DAILY-USAGE\.md'
Assert-Contains 'GUIDE.md' 'DAILY-USAGE\.md'
Assert-Contains 'README.md' 'DAILY-USAGE\.md#22-coexistence-of-copilot-instructionsmd-and-agentsmd'
Assert-Contains 'README.md' 'GUIDE\.md#7-adoption-and-continuous-operation'
Assert-Contains 'README.md' '#getting-started-under-30-minutes'
Assert-Contains 'README.md' '^## Getting Started \(Under 30 Minutes\)'
Assert-Contains 'anti-patterns.md' 'GUIDE\.md#34-guardrails-against-instruction-overload'
Assert-Contains 'anti-patterns.md' 'DAILY-USAGE\.md#56-ai-repeatedly-violates-the-same-agentsmd-rule'
Assert-Contains 'DAILY-USAGE.md' '^### 2\.2 Coexistence of .*copilot-instructions\.md.*AGENTS\.md'
Assert-Contains 'DAILY-USAGE.md' '^### 5\.6 AI Repeatedly Violates the Same AGENTS\.md Rule'
Assert-Contains 'GUIDE.md' '^### 3\.4 Guardrails Against Instruction Overload'
Assert-Contains 'GUIDE.md' '^## 7\. Adoption and Continuous Operation'

Assert-Contains 'README.md' '## Quick Constraints'
Assert-Contains 'README.md' 'orchestration.*validation.*transaction logic.*Service'
Assert-Contains 'README.md' 'all data access.*Repository/Service abstraction'
Assert-Contains 'README.md' 'avoid verb-based paths.*multi-version mixing'

Assert-Contains 'GUIDE.md' 'Responsibility definition'
Assert-Contains 'GUIDE.md' 'decision source is C3 \(human decision\)'

Assert-Contains 'DAILY-USAGE.md' '128K[–-]200K context'
Assert-Contains 'DAILY-USAGE.md' '10[–-]15 rounds'

Assert-Contains 'prompts/UPDATE.md' 'Quick Constraints as a pinned projection of C3 decisions'
Assert-Contains 'prompts/UPDATE.md' 'write only after user confirmation'

Assert-LineOrder 'prompts/INIT-BUILD.md' '^## Quick Constraints$' '^## Domain-to-Code Map$' 'INIT-BUILD: Quick Constraints before Domain-to-Code Map'
Assert-LineOrder 'prompts/INIT-BUILD.md' '^## Domain-to-Code Map$' '^## GenAI Docs Navigation$' 'INIT-BUILD: Domain-to-Code Map before GenAI Docs Navigation'

Assert-FileExists 'examples/dotnet-dual-api/docs/README.md'
Assert-FileExists 'examples/java-library/docs/README.md'
Assert-FileExists 'examples/python-package/docs/README.md'
Assert-FileExists 'examples/react-nx-monorepo/docs/README.md'

Assert-Contains 'examples/dotnet-dual-api/docs/README.md' 'booking-backend'
Assert-Contains 'examples/java-library/docs/README.md' 'edge-comm-core'
Assert-Contains 'examples/python-package/docs/README.md' 'etl-pipeline-core'
Assert-Contains 'examples/react-nx-monorepo/docs/README.md' 'inventory-frontend'

Assert-NotContains 'GUIDE.md' '就就位'

Assert-Contains 'prompts/INIT-BUILD.md' 'design decisions for cross-module shared components'
Assert-Contains 'prompts/INIT-BUILD.md' 'Length guideline'

Assert-MatchCount 'prompts/INIT-SCAN.md' '^---BEGIN PROMPT---$' 1
Assert-MatchCount 'prompts/INIT-BUILD.md' '^---BEGIN PROMPT---$' 1
Assert-MatchCount 'prompts/UPDATE.md' '^---BEGIN PROMPT---$' 1
Assert-MatchCount 'prompts/SPEC.md' '^---BEGIN PROMPT---$' 1
Assert-MatchCount 'prompts/ADR.md' '^---BEGIN PROMPT---$' 1
Assert-MatchCount 'prompts/SA.md' '^---BEGIN PROMPT---$' 1

Assert-MatchCount 'prompts/INIT-SCAN.md' '^---END PROMPT---$' 1
Assert-MatchCount 'prompts/INIT-BUILD.md' '^---END PROMPT---$' 1
Assert-MatchCount 'prompts/UPDATE.md' '^---END PROMPT---$' 1
Assert-MatchCount 'prompts/SPEC.md' '^---END PROMPT---$' 1
Assert-MatchCount 'prompts/ADR.md' '^---END PROMPT---$' 1
Assert-MatchCount 'prompts/SA.md' '^---END PROMPT---$' 1

Assert-MatchCount 'prompts/INIT-SCAN.md' '^````$' 2
Assert-MatchCount 'prompts/INIT-BUILD.md' '^````$' 2
Assert-MatchCount 'prompts/UPDATE.md' '^````$' 2
Assert-MatchCount 'prompts/SPEC.md' '^````$' 2
Assert-MatchCount 'prompts/ADR.md' '^````$' 2
Assert-MatchCount 'prompts/SA.md' '^````$' 2

Assert-NotContains 'prompts/SPEC.md' 'templates/DOCS-README-TEMPLATE\.md'
Assert-NotContains 'prompts/ADR.md' 'templates/DOCS-README-TEMPLATE\.md'
Assert-NotContains 'prompts/SA.md' 'templates/DOCS-README-TEMPLATE\.md'

# Greenfield / Brownfield adoption path (v0.3)
Assert-Contains 'GUIDE.md' 'Step 3\.5'
Assert-Contains 'GUIDE.md' 'Greenfield'
Assert-Contains 'GUIDE.md' 'Brownfield'
Assert-Contains 'GUIDE.md' 'As-Is'
Assert-Contains 'README.md' 'Brownfield'
Assert-Contains 'DAILY-USAGE.md' 'Scenario F'
Assert-Contains 'prompts/INIT-BUILD.md' 'Greenfield|Brownfield'
Assert-Contains 'anti-patterns.md' 'Backfill all existing APIs.*once'

# i18n: zh-TW variants exist (v0.4)
Assert-FileExists 'README.zh-TW.md'
Assert-FileExists 'GUIDE.zh-TW.md'
Assert-FileExists 'DAILY-USAGE.zh-TW.md'
Assert-FileExists 'anti-patterns.zh-TW.md'
Assert-FileExists 'CONTRIBUTING.zh-TW.md'

Write-Host "=== Verification Summary ==="
Write-Host "PASS: $script:PassCount"
Write-Host "FAIL: $script:FailCount"

if ($script:FailCount -gt 0) {
    exit 1
}

Write-Host 'Result: All checks passed'
