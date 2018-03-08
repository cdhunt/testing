ipmo $PSScriptRoot\..\src\testing.psd1 -Force

Invoke-Testing $PSScriptRoot\manualtests.ps1, $PSScriptRoot\happypath.ps1 -Exit