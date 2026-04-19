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
        Pass "檔案存在：$Path"
    }
    else {
        Fail "檔案不存在：$Path"
    }
}

function Assert-Contains([string]$Path, [string]$Pattern) {
    if (Select-String -Path $Path -Pattern $Pattern -Quiet) {
        Pass "符合規則：$Path / $Pattern"
    }
    else {
        Fail "未符合規則：$Path / $Pattern"
    }
}

function Assert-NotContains([string]$Path, [string]$Pattern) {
    if (Select-String -Path $Path -Pattern $Pattern -Quiet) {
        Fail "不應出現但找到：$Path / $Pattern"
    }
    else {
        Pass "未發現禁用內容：$Path / $Pattern"
    }
}

function Assert-FirstLineStartsWithHeader([string]$Path) {
    if (-not (Test-Path -Path $Path -PathType Leaf)) {
        Fail "檔案不存在（跳過首行檢查）：$Path"
        return
    }
    $firstLine = Get-Content -Path $Path -TotalCount 1
    if ($null -ne $firstLine -and $firstLine.StartsWith('#')) {
        Pass "首行為標題：$Path"
    }
    else {
        Fail "首行不是標題（可能有外層 code fence）：$Path"
    }
}

function Assert-MatchCount([string]$Path, [string]$Pattern, [int]$ExpectedCount) {
    $matches = Select-String -Path $Path -Pattern $Pattern -AllMatches
    $actualCount = if ($null -eq $matches) { 0 } else { @($matches).Count }
    if ($actualCount -eq $ExpectedCount) {
        Pass "數量符合：$Path / $Pattern = $ExpectedCount"
    }
    else {
        Fail "數量不符：$Path / $Pattern，預期 $ExpectedCount，實際 $actualCount"
    }
}

function Assert-LineOrder([string]$Path, [string]$FirstPattern, [string]$SecondPattern, [string]$RuleName) {
    $firstMatch = Select-String -Path $Path -Pattern $FirstPattern | Select-Object -First 1
    $secondMatch = Select-String -Path $Path -Pattern $SecondPattern | Select-Object -First 1

    if ($null -eq $firstMatch -or $null -eq $secondMatch) {
        Fail "順序檢查失敗（缺少匹配）：$RuleName"
        return
    }

    if ($firstMatch.LineNumber -lt $secondMatch.LineNumber) {
        Pass "順序符合：$RuleName"
    }
    else {
        Fail "順序不符：$RuleName"
    }
}

Write-Host "=== ZeroSpec 驗收開始（Windows PowerShell） ==="

Assert-FileExists 'prompts/INIT-SCAN.md'
Assert-FileExists 'prompts/INIT-BUILD.md'
Assert-FileExists 'prompts/UPDATE.md'
Assert-FileExists 'prompts/SPEC.md'
Assert-FileExists 'prompts/ADR.md'
Assert-FileExists 'prompts/SA.md'

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
Assert-FirstLineStartsWithHeader 'templates/DOCS-README-TEMPLATE.md'
Assert-FirstLineStartsWithHeader 'templates/SA-TEMPLATE.md'
Assert-FirstLineStartsWithHeader 'examples/minimal-day1/AGENTS.md'
Assert-FirstLineStartsWithHeader 'examples/minimal-day1/docs/README.md'

Assert-Contains 'prompts/SPEC.md' '## 前置條件'
Assert-Contains 'prompts/ADR.md' '## 前置條件'
Assert-Contains 'prompts/SA.md' '## 前置條件'

Assert-Contains 'prompts/SPEC.md' 'docs/README\.md'
Assert-Contains 'prompts/ADR.md' 'docs/README\.md'
Assert-Contains 'prompts/SA.md' 'docs/README\.md'
Assert-Contains 'prompts/SPEC.md' '讀取既有文件（若為更新）'
Assert-Contains 'prompts/INIT-SCAN.md' 'Plan 模式可讀取 codebase'

Assert-Contains 'README.md' 'DAILY-USAGE\.md'
Assert-Contains 'GUIDE.md' 'DAILY-USAGE\.md'

Assert-Contains 'README.md' '## 關鍵約束（Quick Constraints）'
Assert-Contains 'README.md' '流程編排、驗證與交易邏輯放在 Service'
Assert-Contains 'README.md' '資料存取統一走 Repository/Service 抽象'
Assert-Contains 'README.md' '避免動詞式路徑與多版本混用'

Assert-Contains 'GUIDE.md' '責任定義'
Assert-Contains 'GUIDE.md' '決策來源屬於 C3（人決策）'

Assert-Contains 'DAILY-USAGE.md' '128K–200K context 模型為基準'
Assert-Contains 'DAILY-USAGE.md' '10–15 輪'

Assert-Contains 'prompts/UPDATE.md' 'Quick Constraints 視為 C3 決策的置頂投影'
Assert-Contains 'prompts/UPDATE.md' '僅在使用者確認後寫入'

Assert-LineOrder 'prompts/INIT-BUILD.md' '^## 關鍵約束（Quick Constraints）$' '^## 領域/模組 ↔ 程式碼對照表$' 'INIT-BUILD：Quick Constraints 置於對照表前'
Assert-LineOrder 'prompts/INIT-BUILD.md' '^## 領域/模組 ↔ 程式碼對照表$' '^## GenAI 文件導航$' 'INIT-BUILD：對照表置於導航前'

Assert-FileExists 'examples/dotnet-dual-api/docs/README.md'
Assert-FileExists 'examples/java-library/docs/README.md'
Assert-FileExists 'examples/python-package/docs/README.md'
Assert-FileExists 'examples/react-nx-monorepo/docs/README.md'

Assert-Contains 'examples/dotnet-dual-api/docs/README.md' 'booking-backend'
Assert-Contains 'examples/java-library/docs/README.md' 'edge-comm-core'
Assert-Contains 'examples/python-package/docs/README.md' 'etl-pipeline-core'
Assert-Contains 'examples/react-nx-monorepo/docs/README.md' 'inventory-frontend'

Assert-NotContains 'GUIDE.md' '就就位'

Assert-Contains 'prompts/INIT-BUILD.md' '跨模組共用元件的設計決策'
Assert-Contains 'prompts/INIT-BUILD.md' '長度指引'

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

Write-Host "=== 驗收摘要 ==="
Write-Host "PASS: $script:PassCount"
Write-Host "FAIL: $script:FailCount"

if ($script:FailCount -gt 0) {
    exit 1
}

Write-Host '結果：全部檢查通過'
