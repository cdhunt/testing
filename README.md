# Testing

A unit test runner for PowerShell.

## Why

There's already [Pester](https://github.com/pester/pester) so what's the point of this?

Pester was designing using [BDD-style](https://en.wikipedia.org/wiki/Behavior-driven_development) [DSL](https://en.wikipedia.org/wiki/Domain-specific_language).
That makes the test files read a bit like English and therefor self documenting.
That is a great feature, but the downside is it requires a lot of boilerplate to define each test.
After working with some other unit test frameworks in other languages,
I've grown to appreciate their focus on creating and running lots of tests quickly.
So, that is why I started messing around with a new module to write and run unit tests.
That is the primary intention of this module.
The assertions are built using Jakub's [Assert](https://github.com/nohwnd/Assert) module.

## Syntax of a Test

```powershell
function Test-Numbers ([PSTypeName('Testing')]$t)
{
    $tests = @(
        @{num=1;expected=1},
        @{num=2;expected=1},
        @{num="three";expected=1}
    )

    foreach ($test in $tests) {
        $actual = $test.num * 1
        $t.Equal($test.expected, $actual)
    }

```

A test is a function with the `Test` verb and a single parameter with the `[PSTypeName('Testing')]` attribute.
The function needs at least one assertion method called like `$t.Equal($expected, $actual)`.

## Assertions

### Equal

Parameters: [object]Expected, [object]Actual

Test `$actual -eq expected`

_example_

```powershell
$actual = 1 * 2
$t.Equal(2, $actual)
```
### Like

Parameters: [string]Expected, [string]Actual, [array]Values

Test `$actual -like $expected`

Optionally, take an array of values and format `$expected -f $values`

_example_

```powershell
$t.Like("{0} {1} is nice", $actual, @($FirstName, $LastName))
```

## Invoking

`Invoke-Testing [-Path] <string[]> [-Exit] [-Passthru]`

Pass in one or more file paths to PS1 files that contain functions that meet the above mentioned test syntax.

_NOTE:_ Files will be dot-sources so any code outside of function declarations will also be invoked. Only functions that have the correct signature will be invoked so your file can contain helper functions if desired.

## Output

The default output is a single result per file.


![output](/img/outputexample.png)


The `-Passthru` switch sends `Testing` objects to the pipeline.
One object per file.
Each `Testing` object contains a Result property per test function.
There's a lot of room for improvement in this representation.

```powershell
$results.Results

 Pass                                                                  Result
 ----                                                                  ------
 True                                                                       1
False                                      Expected int '1', but got int '2'.
 True                                                                       2
False                               Expected int '1', but got string 'three'.
 True                                                         Bob Man is nice
 True                                                        10 digit is nice
 True                                                      False True is nice
 True                                                                 is nice
False Expected the string 'Bob Man is mean' to match '*nice*' but it did not.
 True                                                         Bob Man is mean
 True                                                                       1
 True                                                                       2
 True                                                         Bob Man is nice
 True                                                        10 digit is nice
 True                                                      False True is nice
 True                                                                 is nice
 True                                                         Bob Man is mean
 ```

 The `-Throw` parameter will Throw an exception if any tests fail.

 The `-Exit` parameter will exit the process with ExitCode of 0 if all tests pass or an ExitCode equal to the number of failed tests.