<# 
.SYNOPSIS 
    Log parser for LogRhythm Mediator logs 
.DESCRIPTION 
    Run as: 'Parse-MediatorLog C:\loki.log'
.NOTES 
   vhoudoverdov@ucla.edu
.LINK 
   www.it.ucla.edu
#>  

# 06/23/2017 00:04:24.429199 [LOG2] \*\*\*WARNING\*\*\* Invalid normal message date  detected for message source LOG Flat File - Other: correcting the msgdate and normalmsgdate from 1/1/0001 8:00:00 AM to 6/23/2017 7:04:24 AM
# 06/23/2017 01:11:03.781094 [LOG2] \*\*\*WARNING\*\*\* The maximum log processing rate has been exceeded. Currently processing 3227.152 logs/sec
# 06/23/2017 02:01:37.969483 [LOG2] \*\*\*WARNING\*\*\* The maximum log archiving rate has been exceeded. Currently archiving 11216.14 logs/sec
# 06/23/2017 02:22:03.111985 [LOG2] \*\*\*WARNING\*\*\* LogRhythm Mediator Server shutting down NOW
# 06/23/2017 06:01:38.557056 [LOG2] \*\*\*WARNING\*\*\* Unprocessed log realtime queue size (60115) exceeds maximum queue size (60000), spooling to disk
# Abnormally high heartbeat offsets

function Parse-MediatorLog {
[CmdletBinding()]
Param(
  [Parameter(Mandatory=$True,Position=1)]
   [string]$Path)
	
$MaxLogProcessingSet = @();
$UnprocessedLogQueueSet = @();
$MediatorShuttingDownSet = @();
$MaxLogArchivingSet = @();

$CSS = @"
<style>
BODY{background-color:#99ccff;}
TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}
TH{border-width: 3px;padding: 2px;border-style: solid;border-color: black;background-color:gold}
TD{border-width: 3px;padding: 2px;border-style: solid;border-color: black;background-color: #cac3c2;}
TD:hover{background-color: #dde0e0;}"
</style>
"@   


gc $Path | % { 

if($_ -match '(.+) (.+) \[.+\] \*\*\*WARNING\*\*\* The maximum log processing rate has been exceeded. Currently processing (.+) logs\/sec$') { 
    $MatchProps = @{
        Date = $Matches[1]
        Time = $Matches[2]
        LogsPerSec = $Matches[3]}

$MaxLogProcessingSet += New-Object PSObject -Property $MatchProps
       }


if($_ -match '(.+) (.+) \[.+\] \*\*\*WARNING\*\*\* Unprocessed log realtime queue size \((.+)\) exceeds maximum queue size \((.+)\), spooling to disk$') {   
    $MatchProps = @{
        Date = $Matches[1]
        Time = $Matches[2]
        UnprocessedLogRealQueue = $Matches[3]
        UnprocessedLogMaxQueue = $Matches[4]}

$UnprocessedLogQueueSet += New-Object PSObject -Property $MatchProps
}

if($_ -match '(.+) (.+) \[.+\] \*\*\*WARNING\*\*\* LogRhythm Mediator Server shutting down NOW$') { 
    $MatchProps = @{
        Date = $Matches[1]
        Time = $Matches[2]}

$MediatorShuttingDownSet += New-Object PSObject -Property $MatchProps
}

if($_ -match '(.+) (.+) \[.+\] \*\*\*WARNING\*\*\* The maximum log archiving rate has been exceeded. Currently archiving (.+) logs\/sec$') {  
    $MatchProps = @{
        Date = $Matches[1]
        Time = $Matches[2]
        LogsPerSec = $Matches[3]}
       

$MaxLogArchivingSet += New-Object PSObject -Property $MatchProps
}

}
$MaxLogProcessingSet, $UnprocessedLogQueueSet,$MediatorShuttingDownSet, $MaxLogArchivingSet | ConvertTo-Html -Head $CSS | Out-File 'a.html';
}
      

Parse-MediatorLog '~\Desktop\modified.log'