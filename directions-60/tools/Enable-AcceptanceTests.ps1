$ErrorActionPreference = 'Stop'
$labRoot = Split-Path $PSScriptRoot -Parent
$sourceRoot = Join-Path $labRoot 'acceptance-tests'
$targetRoot = Join-Path $labRoot 'Test/src'
foreach ($file in Get-ChildItem -LiteralPath $sourceRoot -Filter '*.al') {
    $destination = Join-Path $targetRoot $file.Name
    if (Test-Path -LiteralPath $destination) {
        if ((Get-FileHash -LiteralPath $file.FullName).Hash -ne (Get-FileHash -LiteralPath $destination).Hash) {
            throw "Existing modified test will not be overwritten: $destination"
        }
    } else {
        Copy-Item -LiteralPath $file.FullName -Destination $destination
    }
}
Write-Host 'Acceptance tests activated. Compile App, then Test. Run with Function test isolation.'
