# sync-skills.ps1 — Sync ZeroSpec prompt packs into skills/ and optionally install to ~/.claude/skills/
#
# Usage:
#   pwsh -File scripts/sync-skills.ps1            # Sync skills/ directory only
#   pwsh -File scripts/sync-skills.ps1 -Install   # Sync AND install to ~/.claude/skills/zerospec/
#   pwsh -File scripts/sync-skills.ps1 -Check     # Check whether skills/ is up to date (exit 1 if drift)

param(
    [switch]$Install,
    [switch]$Check,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Show-Usage {
    Write-Host 'Usage: pwsh -File scripts/sync-skills.ps1 [-Install|-Check]'
}

if ($Help) {
    Show-Usage
    exit 0
}

if ($Install -and $Check) {
    Show-Usage
    exit 2
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
$srcDir = Join-Path $repoRoot 'prompts'
$destDir = Join-Path $repoRoot 'skills/zerospec/prompts'
$installDir = Join-Path $HOME '.claude/skills/zerospec'

function Get-MarkdownFiles($directory) {
    if (-not (Test-Path -Path $directory -PathType Container)) {
        return @()
    }
    return @(Get-ChildItem -Path $directory -Filter '*.md' -File)
}

function Test-FilesEqual($expectedPath, $actualPath) {
    if (-not (Test-Path -Path $expectedPath -PathType Leaf) -or -not (Test-Path -Path $actualPath -PathType Leaf)) {
        return $false
    }

    $expectedHash = (Get-FileHash -Path $expectedPath -Algorithm SHA256).Hash
    $actualHash = (Get-FileHash -Path $actualPath -Algorithm SHA256).Hash
    return $expectedHash -eq $actualHash
}

if ($Check) {
    $drift = $false

    foreach ($file in Get-MarkdownFiles $srcDir) {
        $dest = Join-Path $destDir $file.Name
        if (-not (Test-Path -Path $dest -PathType Leaf)) {
            Write-Host "MISSING  $($file.Name) in skills/zerospec/prompts/"
            $drift = $true
        }
        elseif (-not (Test-FilesEqual $file.FullName $dest)) {
            Write-Host "OUTDATED $($file.Name)"
            $drift = $true
        }
    }

    foreach ($file in Get-MarkdownFiles $destDir) {
        $src = Join-Path $srcDir $file.Name
        if (-not (Test-Path -Path $src -PathType Leaf)) {
            Write-Host "EXTRA    $($file.Name) in skills/zerospec/prompts/"
            $drift = $true
        }
    }

    if ($drift) {
        Write-Host ''
        Write-Host "Run 'pwsh -File scripts/sync-skills.ps1' to update."
        exit 1
    }

    Write-Host 'OK  skills/zerospec/prompts/ is in sync with prompts/'
    exit 0
}

Write-Host 'Syncing prompts/ -> skills/zerospec/prompts/ ...'
New-Item -ItemType Directory -Path $destDir -Force | Out-Null

foreach ($file in Get-MarkdownFiles $srcDir) {
    $dest = Join-Path $destDir $file.Name
    if (-not (Test-FilesEqual $file.FullName $dest)) {
        Copy-Item -Path $file.FullName -Destination $dest -Force
        Write-Host "  updated: $($file.Name)"
    }
}

foreach ($file in Get-MarkdownFiles $destDir) {
    $src = Join-Path $srcDir $file.Name
    if (-not (Test-Path -Path $src -PathType Leaf)) {
        Remove-Item -Path $file.FullName -Force
        Write-Host "  removed: $($file.Name)"
    }
}

Write-Host 'Done.'

if ($Install) {
    Write-Host ''
    Write-Host "Installing to $installDir ..."
    New-Item -ItemType Directory -Path (Join-Path $installDir 'prompts') -Force | Out-Null
    Copy-Item -Path (Join-Path $repoRoot 'skills/zerospec/SKILL.md') -Destination (Join-Path $installDir 'SKILL.md') -Force
    Copy-Item -Path (Join-Path $destDir '*.md') -Destination (Join-Path $installDir 'prompts') -Force
    Write-Host "Installed: $installDir"
    Write-Host ''
    Write-Host 'Verify installation:'
    Write-Host "  Get-ChildItem $installDir"
    Write-Host "  Get-ChildItem $(Join-Path $installDir 'prompts')"
}
