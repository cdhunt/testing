function Test-Numbers ([PSTypeName('Testing')]$t)
{
    $tests = @(
        @{num=1;expected=1},
        @{num=2;expected=2}
    )

    foreach ($test in $tests) {
        $res = $test.num * 1
        $t.Equal($test.expected, $res)
    }

}

function Test-Strings ([PSTypeName('Testing')]$t)
{
    . $PSScriptRoot\testsut.ps1

    $tests = @(
        @{fname="Bob";lname="Man"},
        @{fname=10;lname="digit"},
        @{fname=$false;lname=$true},
        @{fname=$null;lname=$null}
    )

    foreach ($test in $tests) {
        $res = Get-TestString $test.fname $test.lname
        $t.Like("{0} {1} is nice", $res, @($test.fname, $test.lname))
    }

    $t.Like("*mean*", "Bob Man is mean")
}

function Test-Collections ([PSTypeName('Testing')]$t)
{

    $t.Contain(2, @(1..10))

}