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
  All([Object]$a)
  {
      Invoke-Assertion All $a
  }
  Any([Object]$a)
  {
      Invoke-Assertion Any $a
  }
  Contain([Object]$e, [Object]$a)
  {
      Invoke-Assertion Contain $e $a
  }
  Equal([Object]$e, [Object]$a)
  {
      Invoke-Assertion Equal $e $a
  }
  Equivalent([Object]$e, [Object]$a)
  {
      Invoke-Assertion Equivalent $e $a
  }
  False([Object]$a)
  {
      Invoke-Assertion False $a
  }
  GreaterThan([Object]$e, [Object]$a)
  {
      Invoke-Assertion GreaterThan $e $a
  }
  GreaterThanOrEqual([Object]$e, [Object]$a)
  {
      Invoke-Assertion GreaterThanOrEqual $e $a
  }
  LessThan([Object]$e, [Object]$a)
  {
      Invoke-Assertion LessThan $e $a
  }
  LessThanOrEqual([Object]$e, [Object]$a)
  {
      Invoke-Assertion LessThanOrEqual $e $a
  }
  Like([String]$e, [Object]$a, [string[]]$v)
  {
      $e = $e -f $v
      Invoke-Assertion Like $e $a
  }
  Like([String]$e, [Object]$a)
  {
      Invoke-Assertion Like $e $a
  }
  NotContain([Object]$e, [Object]$a)
  {
      Invoke-Assertion NotContain $e $a
  }
  NotEqual([Object]$e, [Object]$a)
  {
      Invoke-Assertion NotEqual $e $a
  }
  NotLike([String]$e, [Object]$a, [string[]]$v)
  {
      $e = $e -f $v
      Invoke-Assertion NotLike $e $a
  }
  NotLike([String]$e, [Object]$a)
  {
      Invoke-Assertion NotLike $e $a
  }
  NotNull([Object]$a)
  {
      Invoke-Assertion NotNull $a
  }
  NotSame([Object]$e, [Object]$a)
  {
      Invoke-Assertion NotSame $e $a
  }
  NotType([Type]$e, [Object]$a)
  {
      Invoke-Assertion NotType $e $a
  }
  Null([Object]$a)
  {
      Invoke-Assertion Null $a
  }
  Same([Object]$e, [Object]$a)
  {
      Invoke-Assertion Same $e $a
  }
  StringEqual([String]$e, [Object]$a, [string[]]$v)
  {
      $e = $e -f $v
      Invoke-Assertion StringEqual $e $a
  }
  StringEqual([String]$e, [Object]$a)
  {
      Invoke-Assertion StringEqual $e $a
  }
  StringNotEqual([String]$e, [Object]$a, [string[]]$v)
  {
      $e = $e -f $v
      Invoke-Assertion StringNotEqual $e $a
  }
  StringNotEqual([String]$e, [Object]$a)
  {
      Invoke-Assertion StringNotEqual $e $a
  }
  True([Object]$a)
  {
      Invoke-Assertion True $a
  }
}
