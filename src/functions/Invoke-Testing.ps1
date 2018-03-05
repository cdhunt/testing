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
    }

    process {
        $Path | ForEach-Object {
            $testFile = $_
            . $testFile

            . $PSScriptRoot\TestResults.ps1

            $TestResults.File = $testFile

            $stopwatch = Measure-Command {
                    Get-ChildItem function:\ |
                    ForEach-Object {
                        if ($_.Parameters.ContainsKey("t")) {
                            if ($_.Parameters["t"].Attributes -contains "Testing") {
                                $func = $_.Name
                                &$func $TestResults
                            }
                        }
                    }
            }

            $ok = if ($TestResults.Results.pass -contains $false) {
                $failCount += ($TestResults.Results.pass -contains $false).Count
                "FAIL"

            } else {
                "ok"
            }

            "{0}`t{1}`t{2:n2}s" -f $ok, $testFile, $stopwatch.TotalSeconds | Write-Host

            if ($Passthru) {
                Write-Output -InputObject $TestResults
            }

        }
    }

    end {
        if ($Throw) {
            if ($failCount -gt 0) {
                Throw "$failCount tests failed."
            }
        }

        if ($Exit) {
            exit $failCount
        }
    }
}