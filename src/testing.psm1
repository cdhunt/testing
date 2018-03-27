Import-Module $PSScriptRoot\Assert\Assert.psd1

. $PSScriptRoot\classes\Result.ps1

& "$PSScriptRoot\classes\GenTesting.ps1"

. $PSScriptRoot\classes\Testing.ps1

. $PSScriptRoot\functions\Invoke-Assertion.ps1
. $PSScriptRoot\functions\Invoke-Testing.ps1