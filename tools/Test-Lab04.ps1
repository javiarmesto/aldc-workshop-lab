[CmdletBinding()]
param(
    [string]$ProjectRoot,
    [string]$PluginPath,
    [string]$BCQualityPath,
    [string]$PlansPath,
    [string]$BaseCommit,
    [string]$IncrementCommit
)
& (Join-Path $PSScriptRoot 'Test-LabPrerequisites.ps1') -Lab 4 @PSBoundParameters

