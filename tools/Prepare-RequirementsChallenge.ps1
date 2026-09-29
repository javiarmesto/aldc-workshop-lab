[CmdletBinding()]
param(
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$Destination,
    [ValidateRange(50000,99949)][int]$AppObjectIdFrom = 71400,
    [ValidateRange(50000,99949)][int]$TestObjectIdFrom = 71500
)

$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not $Destination) {
    $Destination = Join-Path (Split-Path $ProjectRoot -Parent) 'customer-followup-requisitos'
}
$Destination = [IO.Path]::GetFullPath($Destination)
$parent = Split-Path $Destination -Parent
$appTo = $AppObjectIdFrom + 49
$testTo = $TestObjectIdFrom + 49
if ($appTo -gt 99999 -or $testTo -gt 99999 -or
    ($AppObjectIdFrom -le $testTo -and $TestObjectIdFrom -le $appTo)) {
    throw 'Los rangos App y Test (50 IDs cada uno) deben estar separados y terminar antes de 100000.'
}
$comparison = [StringComparison]::OrdinalIgnoreCase
$rootWithSeparator = $ProjectRoot.TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
if ($Destination.Equals($ProjectRoot, $comparison) -or $Destination.StartsWith($rootWithSeparator, $comparison)) {
    throw 'El reto debe crearse fuera de la copia del workshop.'
}
if (Test-Path -LiteralPath $Destination) { throw "El destino ya existe; no se sobrescribe: $Destination" }

$requirements = Join-Path $ProjectRoot 'challenges/customer-followup-requisitos/requirements.es.md'
$readme = Join-Path $ProjectRoot 'challenges/customer-followup-requisitos/README.md'
$sourceManifest = Join-Path $ProjectRoot 'App/app.json'
$launchExample = Join-Path $ProjectRoot 'App/.vscode/launch.json.example'
foreach ($file in @($requirements, $readme, $sourceManifest, $launchExample)) {
    if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { throw "Falta el archivo de origen: $file" }
}
$source = Get-Content -LiteralPath $sourceManifest -Raw | ConvertFrom-Json
if (-not (Test-Path -LiteralPath $parent -PathType Container)) { throw "No existe la carpeta padre: $parent" }
$stage = Join-Path $parent ('.customer-followup-requisitos-' + [guid]::NewGuid().ToString('N'))
try {
    New-Item -ItemType Directory -Path $stage | Out-Null
    foreach ($relative in @('App/src','Test/src','App/.vscode','Test/.vscode','evidence')) {
        New-Item -ItemType Directory -Path (Join-Path $stage $relative) -Force | Out-Null
    }
    Copy-Item -LiteralPath $requirements -Destination (Join-Path $stage 'requirements.es.md')
    Copy-Item -LiteralPath $readme -Destination (Join-Path $stage 'README.md')
    Copy-Item -LiteralPath $launchExample -Destination (Join-Path $stage 'App/.vscode/launch.json.example')
    Copy-Item -LiteralPath $launchExample -Destination (Join-Path $stage 'Test/.vscode/launch.json.example')

    $appId = [guid]::NewGuid().ToString()
    $testId = [guid]::NewGuid().ToString()
    $publisher = [string]$source.publisher
    $appName = 'Customer Follow-up Requirements Challenge'
    $testName = 'Customer Follow-up Requirements Challenge Tests'
    $common = @{
        publisher = $publisher; version = '1.0.0.0'
        platform = [string]$source.platform; application = [string]$source.application
        runtime = [string]$source.runtime; features = @('NoImplicitWith')
    }
    $app = $common.Clone()
    $app.id = $appId; $app.name = $appName
    $app.idRanges = @(@{ from = $AppObjectIdFrom; to = $appTo }); $app.dependencies = @()
    $test = $common.Clone()
    $test.id = $testId; $test.name = $testName
    $test.idRanges = @(@{ from = $TestObjectIdFrom; to = $testTo })
    $test.dependencies = @(@{ id = $appId; name = $appName; publisher = $publisher; version = '1.0.0.0' })
    [IO.File]::WriteAllText((Join-Path $stage 'App/app.json'), ($app | ConvertTo-Json -Depth 8), [Text.UTF8Encoding]::new($false))
    [IO.File]::WriteAllText((Join-Path $stage 'Test/app.json'), ($test | ConvertTo-Json -Depth 8), [Text.UTF8Encoding]::new($false))

    $workspace = @'
{
  "folders": [
    { "name": "Requirements challenge (ALDC root)", "path": "." },
    { "name": "App", "path": "App" },
    { "name": "Test", "path": "Test" },
    { "name": "BCQuality (optional sibling)", "path": "../bcquality" }
  ],
  "settings": {
    "al.enableCodeAnalysis": true,
    "al.codeAnalyzers": ["${CodeCop}", "${UICop}", "${PerTenantExtensionCop}"]
  }
}
'@
    [IO.File]::WriteAllText((Join-Path $stage 'customer-followup-requisitos.code-workspace'), $workspace, [Text.UTF8Encoding]::new($false))
    $ignore = @'
.alpackages/
.alcache/
*.app
*.g.xlf
.vscode/launch.json
.vscode/rad.json
.coverage/
.github/plans/telemetry/
'@
    [IO.File]::WriteAllText((Join-Path $stage '.gitignore'), $ignore, [Text.UTF8Encoding]::new($false))
    $git = Get-Command git -ErrorAction SilentlyContinue
    if ($git) {
        & git -C $stage init --quiet
        if ($LASTEXITCODE -ne 0) { throw 'No se pudo inicializar Git en el reto.' }
    }
    Move-Item -LiteralPath $stage -Destination $Destination
} finally {
    if (Test-Path -LiteralPath $stage) { Remove-Item -LiteralPath $stage -Recurse -Force }
}
Write-Host "Reto preparado: $Destination"
Write-Host "Rangos App $AppObjectIdFrom-$appTo; Test $TestObjectIdFrom-$testTo. Confirma disponibilidad en el sandbox."
Write-Host 'Lee README.md y requirements.es.md. Ningun objeto AL ni test se ha generado.'
