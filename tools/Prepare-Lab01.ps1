[CmdletBinding()]
param([string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent))

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
$mapping = @(
    @('templates/primitives/workshop-project.instructions.md.example', '.github/instructions/workshop-project.instructions.md'),
    @('packages/october-workshop-primitives/.apm/instructions/workshop-al.instructions.md', '.github/instructions/workshop-al.instructions.md'),
    @('templates/primitives/review-followup.prompt.md.example', '.github/prompts/review-followup.prompt.md'),
    @('templates/primitives/followup-reviewer.agent.md.example', '.github/agents/followup-reviewer.agent.md'),
    @('templates/plugin/skills/review-date-rules/SKILL.md.example', '.github/skills/review-date-rules/SKILL.md'),
    @('templates/plugin/skills/review-date-rules/boundary-cases.md', '.github/skills/review-date-rules/boundary-cases.md')
)
# Validate every source and destination before copying anything.
foreach ($entry in $mapping) {
    $source = Join-Path $ProjectRoot $entry[0]
    $target = Join-Path $ProjectRoot $entry[1]
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) { throw "Missing source: $source" }
    if (Test-Path -LiteralPath $target) {
        if (-not (Test-Path -LiteralPath $target -PathType Leaf)) { throw "Destination is not a file: $target" }
        if ((Get-FileHash -LiteralPath $source).Hash -ne (Get-FileHash -LiteralPath $target).Hash) {
            throw "Destination has different content; inspect before continuing: $target"
        }
    }
}
foreach ($entry in $mapping) {
    $source = Join-Path $ProjectRoot $entry[0]
    $target = Join-Path $ProjectRoot $entry[1]
    if (-not (Test-Path -LiteralPath $target)) {
        New-Item -ItemType Directory -Path (Split-Path $target -Parent) -Force | Out-Null
        Copy-Item -LiteralPath $source -Destination $target
    }
    Write-Host "Ready: $target"
}
Write-Host 'ALDC copilot-instructions.md and AL source files were not modified.'
