class Result {
    [bool]$Pass
    [object]$Expected
    [object]$Actual
    [string]$Message

    Result ($e, $a) {
        $this.Pass = $false
        $this.Expected = $e
        $this.Actual = $a
    }

    [void] Passed() {
        $this.Pass = $true
    }

    [void] Failed() {
        $this.Pass = $false
    }

    [Result] WithExpected($e) {
        $this.Expected = $e
        return $this
    }

    [Result] WithActul($a) {
        $this.Actual = $a
        return $this
    }

}