Import-Module -Force $PSScriptRoot\..\..\Axiom\src\Axiom.psm1 -DisableNameChecking
. $PSScriptRoot\..\src\New-PsObject.ps1

Describe "New-PSObject" { 
    It "Creates a new object of type PSCustomObject" {
        $hashtable = @{ 
            Name = 'Jakub'
        }

        $object = New-PSObject $hashtable 
        $object | Verify-Type ([PSCustomObject])
    }

    It "Creates a new PSObject with the properties populated" {
        $hashtable = @{ 
            Name = 'Jakub'
        }

        $object = New-PSObject $hashtable 
        $object.Name | Verify-Equal $hashtable.Name
    }
}