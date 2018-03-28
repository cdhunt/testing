param(
    # Specifies a path to one or more locations.
    [Parameter(Position=0)]
    [Alias("PSPath")]
    [ValidateNotNullOrEmpty()]
    [string]
    $Path = ".\src",

    # Parameter help description
    [Parameter(Position=1)]
    [string]
    $Output = ".\release"
)

Process {

    [Job]::New().
        AddStage([Clean]::New($Output)).
        AddStage([Copy]::New($Path, $Output)).
        AddStage([Test]::New($Output)).
        Invoke().
        GetResult()

}

Begin {
    class Stage {
        [string] $Name
        hidden [DateTime] $StartTime = [DateTime]::Now

        Stage($Name) {
            $this.Name = $Name
        }

        [TimeSpan] GetElapsed(){
            return [DateTime]::Now - $this.StartTime
        }

        [string] GetHeader() {
            return "~ [{0}] ~" -f $this.Name
        }
    }

    class Clean : Stage {
        [string] $Destination

        Clean ($Destination) : base('Clean') {
            $this.Destination = $Destination
        }

        Invoke([Job]$J) {

            $J.LogHeader($this.GetHeader())

            if (Test-Path -Path $this.Destination) {
                Get-ChildItem -Path $this.Destination -Recurse | ForEach-Object {
                        $_ | Remove-Item -ErrorAction Stop -Confirm:$false -Recurse
                        $J.LogEntry("- {0}" -f $_.FullName)
                }
            }
        }
    }

    class Copy : Stage {
        [string] $Source
        [string] $Destination

        Copy ($Source, $Destination) : base('Copy') {
            $this.Source = $Source
            $this.Destination = $Destination
        }

        Invoke([job]$J) {

            $J.LogHeader($this.GetHeader())

            Get-ChildItem -Path $this.Source | ForEach-Object {
                $_ | Copy-Item -Destination $this.Destination -ErrorAction Stop -Recurse
                $J.LogEntry("+ {0}" -f (Resolve-Path (Join-Path -Path $this.Destination -ChildPath $_.Name) ))
            }
        }
    }

    class Test : Stage {
        [string] $Destination

        Test ($Destination) : base('Test') {
            $this.Destination = $Destination
        }

        Invoke([job]$J) {

            $J.LogHeader($this.GetHeader())

           $J.LogEntry("Test [{0}]" -f $this.Destination)
        }
    }


    class Job {

        hidden [array] $Result = @()
        hidden [DateTime] $StartTime = [DateTime]::Now
        hidden [Stage[]] $Stages = @()

        [TimeSpan] GetElapsed(){
            return [DateTime]::Now - $this.StartTime
        }

        [void] LogHeader([string]$S) {
            $this.Result += $S
        }

        [void] LogEntry([string]$S) {
            $this.Result += "`t{0}" -f $S
        }

        [void] LogError([string]$S) {
            $this.LogEntry("`!![{0}]!!" -f $S)
        }

        [Job] AddStage([Stage]$S) {
            $this.Stages += $S

            return $this
        }

        [Job] Invoke() {
            $this.Stages | ForEach-Object {
                try {
                    $_.Invoke($this)
                }
                catch {
                    $this.LogError($_.Exception.Message)
                    break
                }
            }

            return $this
        }

        [string] GetResult() {
            return $this.Result | Out-String
        }
    }
}
