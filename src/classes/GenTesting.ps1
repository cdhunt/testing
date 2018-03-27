$testThis = @()

$testThis += @'
class Testing {
    [string]$File
    [Result[]]$Results
    [Timespan]$Duration

    hidden [Datetime]$StartTime
    hidden [DateTime]$EndTime

    Testing ([string]$Path) {
        $this.File = $Path
    }

    [void] AddResult([Result]$r) {
        $this.Results += $r
    }

    [void] StartTimer() {
        $this.StartTime = Get-Date
    }

    [void] StopTimer() {
        $this.EndTime = Get-Date
        $this.Duration = $this.EndTime - $this.StartTime
    }

    [int] FailureCount() {
        return ($this.Results | Where-Object {-not $_.Pass}).Count
    }

    [string] ToString() {

        if ($this.FailureCount() -gt 0)
        {
            $resultText += [char]0x001b + "[31mFAIL"
        }
        else
        {
            $resultText += [char]0x001b + "[32mok"
        }

        $clearAnsi = [string]::Empty + [char]0x001b + "[0m"

        return "{0}`t{1}`t{2:n2}s{3}" -f $resultText, $this.File, $this.Duration.TotalSeconds, $clearAnsi

    }
'@

Get-Command -Module Assert -Verb Assert | % {
    $noun = $_.Noun
    if ($noun -ne 'Throw' -and $noun -ne 'Type') {
        $testThis += "`t" + $noun + '($e, $a)'

        $testThis += "`t{`n`t`tInvoke-Assertion " + $noun + ' $e $a' + "`n`t}`n"
    }
}

$testThis += '}'

$testThis -join "`n" | Set-Content $PSScriptRoot\Testing.ps1 -Force

