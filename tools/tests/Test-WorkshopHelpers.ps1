[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$sourceRoot = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$tempRoot = Join-Path ([IO.Path]::GetTempPath()) ('workshop test ' + [char]0x00F1 + ' ' + [guid]::NewGuid())
$project = Join-Path $tempRoot 'participant project'
function Assert([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
    Write-Host "PASS: $Message"
}
function MustFail([scriptblock]$Action, [string]$Message) {
    $failed = $false
    try { & $Action } catch { $failed = $true }
    Assert $failed $Message
}
function Snapshot([string]$Root) {
    return (@(Get-ChildItem -LiteralPath $Root -Recurse -Force -File |
        Where-Object { $_.FullName -notlike '*\.git\*' } |
        Sort-Object FullName | ForEach-Object {
            $_.FullName.Substring($Root.Length) + ':' + (Get-FileHash -LiteralPath $_.FullName).Hash
        }) -join "`n")
}
try {
    New-Item -ItemType Directory -Path $project -Force | Out-Null
    foreach ($name in @('tools','templates','packages','App','Test','contract.es.md','aldc-workshop-lab.code-workspace')) {
        Copy-Item -LiteralPath (Join-Path $sourceRoot $name) -Destination $project -Recurse
    }
    New-Item -ItemType Directory -Path (Join-Path $project '.github') -Force | Out-Null
    $aldc = Join-Path $project '.github/copilot-instructions.md'
    Set-Content -LiteralPath $aldc -Value 'ALDC sentinel'
    $aldcHash = (Get-FileHash -LiteralPath $aldc).Hash
    $prepare01 = Join-Path $project 'tools/Prepare-Lab01.ps1'
    $prepare02 = Join-Path $project 'tools/Prepare-Lab02.ps1'
    & $prepare01 -ProjectRoot $project
    $prepared = Snapshot $project
    & $prepare01 -ProjectRoot $project
    Assert ((Snapshot $project) -eq $prepared) 'Lab01 repeat is idempotent'
    Assert ((Get-FileHash -LiteralPath $aldc).Hash -eq $aldcHash) 'ALDC instructions preserved'
    $localPrompt = Join-Path $project '.github/prompts/review-followup.prompt.md'
    Add-Content -LiteralPath $localPrompt -Value 'Participant edit'
    $modified = Snapshot $project
    MustFail { & $prepare01 -ProjectRoot $project } 'Lab01 refuses a participant edit'
    Assert ((Snapshot $project) -eq $modified) 'Refusal leaves all files intact'
    $plugin = Join-Path $tempRoot 'plugin'
    $backup = Join-Path $tempRoot 'backup'
    & $prepare02 -ProjectRoot $project -PluginPath $plugin -BackupPath $backup
    Assert (Test-Path (Join-Path $plugin 'skills/review-date-rules/SKILL.md')) 'Plugin skill prepared'
    foreach ($name in @('plugin.json','mcp.json')) {
        Get-Content (Join-Path $plugin $name) -Raw | ConvertFrom-Json | Out-Null
    }
    Assert (@(Get-ChildItem $plugin -Recurse -Filter '*.example').Count -eq 0) 'Plugin suffixes removed'
    MustFail { & $prepare02 -ProjectRoot $project -PluginPath $plugin } 'Existing plugin refused'
    MustFail { & $prepare02 -ProjectRoot $project -PluginPath (Join-Path $project 'nested-plugin') } 'Nested plugin refused'
    & $prepare02 -Action DisableLocal -ProjectRoot $project -PluginPath $plugin -BackupPath $backup
    Assert (-not (Test-Path $localPrompt)) 'Local duplicate disabled'
    Assert ((Get-FileHash -LiteralPath $aldc).Hash -eq $aldcHash) 'ALDC survives disabling local primitives'
    & $prepare02 -Action RestoreLocal -ProjectRoot $project -PluginPath $plugin -BackupPath $backup
    Assert ((Snapshot $project) -eq $modified) 'Restore preserves participant changes'
    MustFail { & $prepare02 -Action DisableLocal -ProjectRoot $project -PluginPath $plugin -BackupPath $backup } 'Existing backup refused'
    $missingSource = Join-Path $project 'templates/plugin/skills/review-date-rules/boundary-cases.md'
    Remove-Item -LiteralPath $missingSource
    Remove-Item -LiteralPath $localPrompt
    $beforeMissing = Snapshot $project
    MustFail { & $prepare01 -ProjectRoot $project } 'Missing source detected before copying'
    Assert ((Snapshot $project) -eq $beforeMissing) 'Missing source causes no partial preparation'

    & git -C $project init --quiet
    if ($LASTEXITCODE -ne 0) { throw 'git init failed' }
    & git -C $project -c user.name=Test -c user.email=test@example.invalid commit --allow-empty --quiet -m fixture
    if ($LASTEXITCODE -ne 0) { throw 'fixture commit failed' }
    $sha = & git -C $project rev-parse HEAD
    # APM is stubbed: these helpers must only request version and command help.
    $global:workshopHelperApmCalls = New-Object 'System.Collections.Generic.List[string]'
    function global:apm {
        $global:workshopHelperApmCalls.Add(($args -join ' '))
        if (($args -join ' ') -notin @('--version','install --help','audit --help')) { throw 'Unexpected APM mutation' }
        $global:LASTEXITCODE = 0
        Write-Output 'APM fixture: version/help only'
    }
    $beforeChecks = Snapshot $tempRoot
    foreach ($lab in 1..8) {
        $helper = Join-Path $project ('tools/Test-Lab{0:00}.ps1' -f $lab)
        $report = (& $helper -ProjectRoot $project -PluginPath $plugin -BCQualityPath (Join-Path $tempRoot 'missing-bcquality') -PlansPath (Join-Path $tempRoot 'missing-plans') *>&1 | Out-String)
        Assert ($report -match '\[FIN\]') "Lab $lab completed with missing prerequisites"
        Assert ($report -match '\[MANUAL\]') "Lab $lab distinguishes manual checks"
    }
    & (Join-Path $project 'tools/Test-Lab06.ps1') -ProjectRoot $project -BaseCommit $sha -IncrementCommit $sha
    New-Item -ItemType Directory -Path (Join-Path $project 'apm-consumer') | Out-Null
    $report = (& (Join-Path $project 'tools/Test-Lab07.ps1') -ProjectRoot $project *>&1 | Out-String)
    Assert ($report -match 'apm-consumer ya existe') 'Existing consumer reported without overwrite'
    Assert ((Snapshot $tempRoot) -eq $beforeChecks) 'All prerequisite helpers leave file contents unchanged'
    Assert ($global:workshopHelperApmCalls.Count -eq 6) 'APM only received the six expected read-only requests'
    Write-Host "SUCCESS: helpers validated on $($PSVersionTable.PSVersion), Windows=$env:OS"
} finally {
    Remove-Item Function:\apm -ErrorAction SilentlyContinue
    Remove-Variable workshopHelperApmCalls -Scope Global -ErrorAction SilentlyContinue
    if (Test-Path $tempRoot) { Remove-Item -LiteralPath $tempRoot -Recurse -Force }
}
