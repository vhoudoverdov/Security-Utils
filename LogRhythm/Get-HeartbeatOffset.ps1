Function Get-HeartBeatOffset {
Param([string]$LogFile)

if (!$LogFile) {throw 'Specify a path to a LogRhythm mediator log using the -LogFile parameter'}

$Hosts = @();

gc $LogFile | % { 
if($_ -match 'from (.+): clock offset = (.+) minutes$') { 
    $Properties = @{Host =   $Matches[1]; Offset = $Matches[2]}
    $Hosts += New-Object Psobject -Property $Properties}}
$High =  [Double]+0.99
$Low =   [Double]-0.99

$Hosts | Get-Unique -AsString  | % {if([Double]$_.Offset -gt $High -or[Double]$_.Offset -lt $Low){$_}}}