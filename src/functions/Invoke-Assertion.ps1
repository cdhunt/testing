function Invoke-Assertion ($Name, $Expected, $Actual)
{
    $result = [Result]::new($Expected, $Actual)
    try {
        $null = &"Assert-$Name" -Expected $expected -Actual $actual -ErrorAction Stop
        $result.Passed()
    }
    catch {
        $result.Failed()
        $result.Message = $_.Exception.Message
    }

    $this.AddResult($result)
}