$TestResults = [pscustomobject]@{PSTypeName='Testing';File=[string]::Empty;Results=@()}
$TestResults | Add-Member -Name Equal -MemberType ScriptMethod -Value {
    param($expected, $actual)

    $pass = $false
    try {
        $result = Assert-Equal -Expected $expected -Actual $actual
        $pass = $true
    }
    catch {
        $result = $Error[0].Exception.Message
    }

    $this.Results += [PSCustomObject]@{Pass=$pass; Result=$result}
}
$TestResults | Add-Member -Name Like -MemberType ScriptMethod -Value {
    param([string]$expected, [string]$actual, [string[]]$value = $null)

    if (-not $null -eq $value) {
        $expected = $expected -f $value
    }

    $pass = $false
    try {
        Assert-Like -Expected $expected -Actual $actual
        $result = $actual
        $pass = $true
    }
    catch {
        $result = $Error[0].Exception.Message
    }

    $this.Results += [PSCustomObject]@{Pass=$pass; Result=$result}
}
