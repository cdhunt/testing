function Invoke-Assertion ($Name, $Expected, $Actual)
{
    $pass = $false
    try {
        $null = &"Assert-$Name" -Expected $expected -Actual $actual -ErrorAction Stop
        $result = $actual
        $pass = $true
    }
    catch {
        $result = $_.Exception.Message
    }

    $this.Results += [PSCustomObject]@{Pass=$pass; Result=$result}
}