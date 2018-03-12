function Invoke-Testing {
    [CmdletBinding()]
    param (
        # Specifies a path to one or more locations.
        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="ParameterSetName",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,

        # Throw
        [Parameter()]
        [switch]
        $Throw,

        # Exit
        [Parameter()]
        [switch]
        $Exit,

        # Passthru
        [Parameter()]
        [switch]
        $Passthru
    )

    begin {
        $failCount = 0
        $red = "" + [char]0x001b + "[31m"
        $green = "" + [char]0x001b + "[32m"
    }

    process {
        $Path | ForEach-Object {
            $testFile = $_
            . $testFile

            $TestResults = [Testing]::New($testFile)
            $TestResults.StartTimer()

            Get-ChildItem function:\ |
            ForEach-Object {
                if ($_.Parameters.ContainsKey("t")) {
                    if ($_.Parameters["t"].Attributes -contains "Testing") {
                        $func = $_.Name
                        &$func $TestResults
                    }
                }
            }

            $TestResults.StopTimer()

            $TestResults | Write-Host

            if ($Passthru) {
                Write-Output -InputObject $TestResults
            }

        }
    }

    end {
        if ($Throw) {
            if ($TestResults.FailureCount -gt 0) {
                Throw "{0} tests failed." -f $TestResults.FailureCount
            }
        }

        if ($Exit) {
            exit $TestResults.FailureCount
        }
    }
}