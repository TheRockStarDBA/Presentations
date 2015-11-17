﻿## Runspace Perf with Building a Runspace Test

#1..10 | % {
$code = { 
  $begin = Get-Date
  $result = Get-Process
  $end = Get-Date
  
  $begin
  $end
  $result
}

$start = Get-Date

$rs = [runspacefactory]::CreateRunspace()
$rs.ThreadOptions = 'ReuseThread'
$rs.Open()
$newPowerShell = [PowerShell]::Create()
$newPowerShell.Runspace = $rs
[void]$newPowerShell.AddScript($code)
$job = $newPowerShell.BeginInvoke()
While (-Not $job.IsCompleted) {}
$completed = Get-Date

$result = $newPowerShell.EndInvoke($job)
$received = Get-Date

$rs.close()
$newPowerShell.Dispose()

$spinup = $result[0]
$exit = $result[1]

$timeToLaunch = ($spinup - $start).TotalMilliseconds
$timeToExit = ($completed - $exit).TotalMilliseconds
$timeToRunCommand = ($exit - $spinup).TotalMilliseconds
$timeToReceive = ($received - $completed).TotalMilliseconds
$TotalTime = ($received - $start).TotalMilliseconds

[pscustomobject]@{
    Type = 'Runspace'
    SetUpJob = $timeToLaunch
    RunCode = $timeToRunCommand
    ExitJob = $timeToExit
    RecieveResults = $timeToReceive
    Total = $TotalTime
} 
#} | measure-object -Property Total -Average