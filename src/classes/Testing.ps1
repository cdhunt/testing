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

    [void] Equal($e, $a)
    {
        Invoke-Assertion Equal $e $a
    }

    [void] NotEqual($e, $a)
    {
        Invoke-Assertion NotEqual $e $a
    }

    [void] Contain($e, $a)
    {
        Invoke-Assertion Contain $e $a
    }

    [void] Like([string]$e, [string]$a)
    {
        Invoke-Assertion Like $e $a
    }

    [void] Like([string]$e, [string]$a, [string[]]$v)
    {
        $e = $e -f $v

        Invoke-Assertion Like $e $a
    }
}