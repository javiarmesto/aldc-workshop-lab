[CmdletBinding()]
param()
$ErrorActionPreference = 'Stop'
$root = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$temporary = Join-Path ([IO.Path]::GetTempPath()) ('followup requirements ' + [guid]::NewGuid().ToString('N'))
$target = Join-Path $temporary 'reto con espacios'
function Assert([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
    Write-Host "PASS: $Message"
}
try {
    New-Item -ItemType Directory -Path $temporary | Out-Null
    & (Join-Path $root 'tools/Prepare-RequirementsChallenge.ps1') -ProjectRoot $root -Destination $target
    $app = Get-Content -LiteralPath (Join-Path $target 'App/app.json') -Raw | ConvertFrom-Json
    $test = Get-Content -LiteralPath (Join-Path $target 'Test/app.json') -Raw | ConvertFrom-Json
    Assert ($test.dependencies[0].id -eq $app.id) 'Test depende de la nueva App'
    Assert ($app.idRanges[0].from -eq 71400 -and $test.idRanges[0].from -eq 71500) 'Rangos distintos'
    Assert (@(Get-ChildItem -LiteralPath (Join-Path $target 'App/src') -File).Count -eq 0) 'App sin solucion AL'
    Assert (@(Get-ChildItem -LiteralPath (Join-Path $target 'Test/src') -File).Count -eq 0) 'Test sin tests dados'
    Assert (-not (Test-Path -LiteralPath (Join-Path $target '.vscode/mcp.json'))) 'Sin MCP en raiz'
    Assert (-not (Test-Path -LiteralPath (Join-Path $target 'App/.vscode/mcp.json'))) 'Sin MCP en App'
    Assert (-not (Test-Path -LiteralPath (Join-Path $target 'Test/.vscode/mcp.json'))) 'Sin MCP en Test'
    Assert (Test-Path -LiteralPath (Join-Path $target 'requirements.es.md')) 'Requisitos presentes'
    $before = (Get-FileHash -LiteralPath (Join-Path $target 'requirements.es.md')).Hash
    $failed = $false
    try { & (Join-Path $root 'tools/Prepare-RequirementsChallenge.ps1') -ProjectRoot $root -Destination $target } catch { $failed = $true }
    Assert $failed 'Segunda ejecucion rechazada'
    Assert ((Get-FileHash -LiteralPath (Join-Path $target 'requirements.es.md')).Hash -eq $before) 'Repeticion sin sobrescritura'
    Write-Host "SUCCESS: challenge bootstrap on $($PSVersionTable.PSVersion)"
} finally {
    if (Test-Path -LiteralPath $temporary) { Remove-Item -LiteralPath $temporary -Recurse -Force }
}
