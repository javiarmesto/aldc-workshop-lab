[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][ValidateRange(1,8)][int]$Lab,
    [string]$ProjectRoot = (Split-Path $PSScriptRoot -Parent),
    [string]$PluginPath,
    [string]$BCQualityPath,
    [string]$PlansPath,
    [string]$BaseCommit,
    [string]$IncrementCommit
)
$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path -LiteralPath $ProjectRoot).Path
if (-not $PluginPath) { $PluginPath = Join-Path (Split-Path $ProjectRoot -Parent) 'review-dates-lab' }
if (-not $BCQualityPath) { $BCQualityPath = Join-Path (Split-Path $ProjectRoot -Parent) 'bcquality' }
if (-not $PlansPath) { $PlansPath = Join-Path $ProjectRoot '.github/plans' }
function Report([string]$State, [string]$Message) { Write-Host "[$State] $Message" }
function CheckPath([string]$Path) {
    if (Test-Path -LiteralPath $Path) { Report 'PRESENTE' $Path }
    else { Report 'FALTA' $Path }
}
function LocalPath([string]$Path) { CheckPath (Join-Path $ProjectRoot $Path) }
function CheckCommand([string]$Name) {
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) { Report 'DISPONIBLE' "$Name : $($command.Source)"; return $true }
    Report 'FALTA' "Comando $Name"; return $false
}
function CheckPlan([string]$Pattern) {
    $found = @(Get-ChildItem -LiteralPath $PlansPath -Recurse -File -Filter $Pattern -ErrorAction SilentlyContinue)
    if ($found.Count -eq 0) { Report 'REVISAR' "No encontrado $Pattern bajo $PlansPath; ajusta -PlansPath al plans.root real." }
    foreach ($file in $found) { Report 'PRESENTE' $file.FullName }
}
function CheckBCQualitySelection {
    $found = @(Get-ChildItem -LiteralPath $PlansPath -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like '*.bcq-criteria.json' -or $_.Name -like '*.bcq-selection.json' })
    if ($found.Count -eq 0) { Report 'REVISAR' "No se encontró selección BCQuality bajo $PlansPath; comprueba plans.root." }
    foreach ($file in $found) { Report 'PRESENTE' $file.FullName }
}
Report 'INFO' ("Lab {0:00}: comprobaciones de lectura, no instala ni modifica archivos." -f $Lab)
Report 'INFO' 'PRESENTE no significa cargado por el agente ni validado funcionalmente.'
LocalPath 'contract.es.md'
LocalPath 'App/app.json'
LocalPath 'Test/app.json'
$hasGit = CheckCommand 'git'
if ($hasGit) {
    & git -C $ProjectRoot rev-parse --show-toplevel
    if ($LASTEXITCODE -eq 0) {
        & git -C $ProjectRoot branch --show-current
        & git -C $ProjectRoot rev-parse HEAD
        & git -C $ProjectRoot --no-optional-locks status --short
    } else { Report 'REVISAR' 'La carpeta no es un repositorio Git accesible.' }
}
switch ($Lab) {
    1 {
        LocalPath 'tools/Prepare-Lab01.ps1'
        LocalPath 'templates/primitives'
        LocalPath 'templates/plugin/skills/review-date-rules'
        LocalPath 'aldc.yaml'
        Report 'MANUAL' 'Ejecuta Prepare-Lab01 si falta preparar las primitivas; confirma su carga en un chat nuevo.'
    }
    2 {
        LocalPath 'tools/Prepare-Lab02.ps1'
        LocalPath 'templates/plugin/plugin.json.example'
        Report 'INFO' 'La ausencia del plugin antes de Prepare es normal. Si existe, no repitas la copia.'
        CheckPath $PluginPath
        if (Test-Path -LiteralPath $PluginPath) {
            CheckPath (Join-Path $PluginPath 'plugin.json')
            CheckPath (Join-Path $PluginPath 'skills/review-date-rules/SKILL.md')
        }
        Report 'MANUAL' 'Confirma registro en Customization, skill usada y llamada real a Learn; no retires ALDC.'
    }
    3 {
        CheckPath (Join-Path $PluginPath 'skills/review-date-rules/SKILL.md')
        LocalPath 'evidence/lab02-run-note.md'
        Report 'MANUAL' 'Conserva la respuesta del Lab 02 y comprueba la ruta cargada antes/despues; registra el cambio de la skill externa.'
    }
    4 {
        LocalPath 'aldc.yaml'
        CheckPath (Join-Path $BCQualityPath 'skills/entry.md')
        LocalPath 'App/.alpackages'
        Report 'MANUAL' 'Comprueba las rutas reales en aldc.yaml. Desde Architect consulta Customer, cargando paquetes si es necesario.'
        Report 'MANUAL' 'Las herramientas disponibles en terminal no demuestran acceso desde el agente.'
    }
    5 {
        CheckPlan '*.architecture.md'
        CheckPlan '*.spec.md'
        CheckBCQualitySelection
        LocalPath 'App/.vscode/launch.json'
        LocalPath 'Test/.vscode/launch.json'
        Report 'MANUAL' 'Lee las aprobaciones, comprueba delegacion y sandbox de App/Test. No se muestran datos de launch.json.'
        Report 'MANUAL' 'Tras implementar: publica App y ejecuta C01-C12. Compilar no demuestra publicacion ni 12/12.'
    }
    6 {
        CheckBCQualitySelection
        LocalPath 'evidence/lab05-run-note.md'
        CheckPath (Join-Path $BCQualityPath 'skills/entry.md')
        if ($BaseCommit -and $IncrementCommit -and $hasGit) {
            if ($BaseCommit -notmatch '^[0-9a-fA-F]{7,40}$' -or $IncrementCommit -notmatch '^[0-9a-fA-F]{7,40}$') {
                throw 'Usa SHA de commits, de 7 a 40 caracteres hexadecimales.'
            }
            & git -C $ProjectRoot diff --ignore-space-at-eol $BaseCommit $IncrementCommit -- App/src/CustomerFollowUpMgt.Codeunit.al
            if ($LASTEXITCODE -ne 0) { Report 'REVISAR' 'No se pudo obtener el diff local; usa GitHub o facilita el diff al revisor.' }
        } else { Report 'MANUAL' 'Indica -BaseCommit y -IncrementCommit para mostrar el diff local, o usa herramientas GitHub equivalentes.' }
        Report 'MANUAL' 'Reviewer: confirma acceso efectivo al diff y aplicacion del protocolo BCQuality. Devuelve informe en chat si es solo lectura.'
    }
    7 {
        if (CheckCommand 'apm') {
            & apm --version
            if ($LASTEXITCODE -ne 0) { Report 'REVISAR' 'apm --version fallo.' }
            & apm install --help
            if ($LASTEXITCODE -ne 0) { Report 'REVISAR' 'No se obtuvo ayuda de install.' }
            & apm audit --help
            if ($LASTEXITCODE -ne 0) { Report 'REVISAR' 'No se obtuvo ayuda de audit.' }
        }
        $package = Join-Path $ProjectRoot 'packages/october-workshop-primitives'
        CheckPath $package
        foreach ($name in @('README.md','apm.yml')) {
            $file = Join-Path $package $name
            CheckPath $file
            if (Test-Path -LiteralPath $file -PathType Leaf) { Get-Content -LiteralPath $file }
        }
        if (Test-Path -LiteralPath $package) { Get-ChildItem -LiteralPath $package -Force | Select-Object Name,Mode }
        $consumer = Join-Path $ProjectRoot 'apm-consumer'
        if (Test-Path -LiteralPath $consumer) { Report 'REVISAR' 'apm-consumer ya existe: no lo sobrescribas ni repitas la preparacion sin revisarlo.' }
        else { Report 'INFO' 'apm-consumer todavia no existe; listo para preparar cuando revises la version/opciones APM.' }
        Report 'MANUAL' 'Comprueba soporte de paquete local, --target copilot y --frozen en la ayuda. Este helper no instala ni ejecuta audit.'
    }
    8 {
        CheckPlan '*.spec.md'
        LocalPath 'evidence/lab05-run-note.md'
        LocalPath 'evidence/lab06-bcquality.md'
        LocalPath 'evidence/lab07-apm.md'
        LocalPath 'labs/material/demo-storyboard.md'
        Report 'MANUAL' 'La pareja receptora debe comprobar fecha y persistencia y registrar aceptar/devolver; la presencia de archivos no prueba aceptacion.'
    }
}
Report 'FIN' 'Revisa FALTA/REVISAR y completa MANUAL. No es un certificado de aprobacion del laboratorio.'
