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
	All($e, $a)
	{
		Invoke-Assertion All $e $a
	}

	Any($e, $a)
	{
		Invoke-Assertion Any $e $a
	}

	Contain($e, $a)
	{
		Invoke-Assertion Contain $e $a
	}

	Equal($e, $a)
	{
		Invoke-Assertion Equal $e $a
	}

	Equivalent($e, $a)
	{
		Invoke-Assertion Equivalent $e $a
	}

	False($e, $a)
	{
		Invoke-Assertion False $e $a
	}

	GreaterThan($e, $a)
	{
		Invoke-Assertion GreaterThan $e $a
	}

	GreaterThanOrEqual($e, $a)
	{
		Invoke-Assertion GreaterThanOrEqual $e $a
	}

	LessThan($e, $a)
	{
		Invoke-Assertion LessThan $e $a
	}

	LessThanOrEqual($e, $a)
	{
		Invoke-Assertion LessThanOrEqual $e $a
	}

	Like($e, $a)
	{
		Invoke-Assertion Like $e $a
	}

	NotContain($e, $a)
	{
		Invoke-Assertion NotContain $e $a
	}

	NotEqual($e, $a)
	{
		Invoke-Assertion NotEqual $e $a
	}

	NotLike($e, $a)
	{
		Invoke-Assertion NotLike $e $a
	}

	NotNull($e, $a)
	{
		Invoke-Assertion NotNull $e $a
	}

	NotSame($e, $a)
	{
		Invoke-Assertion NotSame $e $a
	}

	NotType($e, $a)
	{
		Invoke-Assertion NotType $e $a
	}

	Null($e, $a)
	{
		Invoke-Assertion Null $e $a
	}

	Same($e, $a)
	{
		Invoke-Assertion Same $e $a
	}

	StringEqual($e, $a)
	{
		Invoke-Assertion StringEqual $e $a
	}

	StringNotEqual($e, $a)
	{
		Invoke-Assertion StringNotEqual $e $a
	}

	True($e, $a)
	{
		Invoke-Assertion True $e $a
	}

}
