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

        $expectedParamType = $_.Parameters["Expected"].ParameterType.Name
        $actualParamType = $_.Parameters["Actual"].ParameterType.Name

        if ($_.Parameters.ContainsKey("Expected")) {

            if ($expectedParamType -eq 'String') {

                $testThis += '  {0}([{1}]$e, [{2}]$a, [string[]]$v)' -f $noun, $expectedParamType, $actualParamType
                $testThis += '  {'
                $testThis += '      $e = $e -f $v'
                $testThis += '      Invoke-Assertion {0} $e $a' -f $noun
                $testThis += '  }'
            }

            $testThis += '  {0}([{1}]$e, [{2}]$a)' -f $noun, $expectedParamType, $actualParamType
            $testThis += '  {'
            $testThis += '      Invoke-Assertion {0} $e $a' -f $noun
            $testThis += '  }'

        }
        else {
            $testThis += '  {0}([{1}]$a)' -f $noun, $actualParamType
            $testThis += '  {'
            $testThis += '      Invoke-Assertion {0} $a' -f $noun
            $testThis += '  }'
        }
    }
}

$testThis += '}'

$testThis -join "`n" | Set-Content $PSScriptRoot\Testing.ps1 -Force

