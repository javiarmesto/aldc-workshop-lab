[CmdletBinding()]
param(
    [ValidateSet('Prepare', 'DisableLocal', 'RestoreLocal')]
    [string]$Action = 'Prepare',
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$PluginPath,
    [string]$BackupPath
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not (Test-Path -LiteralPath (Join-Path $ProjectRoot 'aldc-workshop-lab.code-workspace'))) {
    throw "Not a workshop project root: $ProjectRoot"
}
$parent = Split-Path $ProjectRoot -Parent
if (-not $PluginPath) { $PluginPath = Join-Path $parent 'review-dates-lab' }
if (-not $BackupPath) { $BackupPath = Join-Path $parent 'lab01-primitivas-reserva' }
$PluginPath = [IO.Path]::GetFullPath($PluginPath)
$BackupPath = [IO.Path]::GetFullPath($BackupPath)
$rootPrefix = $ProjectRoot.TrimEnd('\', '/') + [IO.Path]::DirectorySeparatorChar
foreach ($destination in @($PluginPath, $BackupPath)) {
    if ($destination.Equals($ProjectRoot, [StringComparison]::OrdinalIgnoreCase) -or
        $destination.StartsWith($rootPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Use a destination outside the workshop workspace: $destination"
    }
}

if ($Action -eq 'Prepare') {
    $source = Join-Path $ProjectRoot 'templates/plugin'
    if (-not (Test-Path -LiteralPath (Join-Path $source 'plugin.json.example'))) {
        throw "Missing plugin template: $source"
    }
    if (Test-Path -LiteralPath $PluginPath) {
        throw "Plugin directory already exists. Inspect and reuse it if already prepared: $PluginPath"
    }
    Copy-Item -LiteralPath $source -Destination $PluginPath -Recurse
    Get-ChildItem -LiteralPath $PluginPath -Recurse -File -Filter '*.example' |
        Rename-Item -NewName { $_.Name -replace '\.example$', '' }
    foreach ($name in @('plugin.json', 'mcp.json')) {
        Get-Content -LiteralPath (Join-Path $PluginPath $name) -Raw | ConvertFrom-Json | Out-Null
    }
    if (-not (Test-Path -LiteralPath (Join-Path $PluginPath 'skills/review-date-rules/SKILL.md'))) {
        throw 'Missing prepared skill.'
    }
    Write-Host "Prepared package: $PluginPath"
    Write-Host 'Next: Chat customization > Plugins > Install from Source; select this exact folder.'
    return
}

$mapping = @(
    @('.github/skills/review-date-rules', 'review-date-rules'),
    @('.github/agents/followup-reviewer.agent.md', 'followup-reviewer.agent.md'),
    @('.github/prompts/review-followup.prompt.md', 'review-followup.prompt.md')
)
if ($Action -eq 'DisableLocal' -and (Test-Path -LiteralPath $BackupPath)) {
    throw "Backup already exists. Check whether the local copies were already moved: $BackupPath"
}
# Preflight all moves. Never overwrite an existing component.
foreach ($entry in $mapping) {
    if ($Action -eq 'DisableLocal') {
        $source = Join-Path $ProjectRoot $entry[0]
        $target = Join-Path $BackupPath $entry[1]
    } else {
        $source = Join-Path $BackupPath $entry[1]
        $target = Join-Path $ProjectRoot $entry[0]
    }
    if (-not (Test-Path -LiteralPath $source)) { throw "Missing source: $source" }
    if (Test-Path -LiteralPath $target) { throw "Destination already exists: $target" }
}
foreach ($entry in $mapping) {
    if ($Action -eq 'DisableLocal') {
        $source = Join-Path $ProjectRoot $entry[0]
        $target = Join-Path $BackupPath $entry[1]
    } else {
        $source = Join-Path $BackupPath $entry[1]
        $target = Join-Path $ProjectRoot $entry[0]
    }
    New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
    Move-Item -LiteralPath $source -Destination $target
    Write-Host "Moved: $source -> $target"
}
Write-Host 'Project instructions and ALDC components were not changed.'
if ($Action -eq 'RestoreLocal') {
    Write-Host 'Disable the plugin in VS Code before using the restored local components.'
    Write-Host "The backup directory remains in place: $BackupPath"
}

