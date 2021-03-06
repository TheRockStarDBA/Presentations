$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")
. "$here\$sut"

Describe 'Demonstrating Code Coverage' {
    It 'Calls FunctionOne with no switch parameter set' {
        FunctionOne | Should Be 'SwitchParam was not set'
    }

    It 'Calls FunctionOne with switch parameter set' {
        FunctionOne -SwitchParam | Should Be 'SwitchParam was set'
    }
    It 'Calls FunctionTwo and should return first value' {
        FunctionTwo | Should Be 'I get executed'
    }
}