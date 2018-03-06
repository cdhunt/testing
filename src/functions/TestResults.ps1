$TestResults = [pscustomobject]@{PSTypeName='Testing';File=[string]::Empty;Results=@()}

$TestResults | Add-Member -Name Equal -MemberType ScriptMethod -Value {
    param($Expected, $Actual)

    Invoke-Assertion Equal $Expected $Actual
}

$TestResults | Add-Member -Name NotEqual -MemberType ScriptMethod -Value {
    param($Expected, $Actual)

    Invoke-Assertion NotEqual $Expected $Actual
}

$TestResults | Add-Member -Name Like -MemberType ScriptMethod -Value {
    param([string]$Expected, [string]$Actual, [string[]]$Value = $null)

    if (-not $null -eq $Value) {
        $Expected = $Expected -f $Value
    }

    Invoke-Assertion Like $Expected $Actual
}

$TestResults | Add-Member -Name Contain -MemberType ScriptMethod -Value {
    param($Expected, $Actual)

    Invoke-Assertion Contain $Expected $Actual
}