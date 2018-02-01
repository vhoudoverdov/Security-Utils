<#
.Synopsis
Decodes and sets the OSSEC authentication key for a client and adds the OSSEC server to ossec.conf.  Then restarts the ossec service.
Define each client as a hashtable

Vasken Houdoverdov

.Description
Sets the OSSEC authentication key and OSSEC server IP address for a client.
Define clients as hashtables with the following keys:  {Computer, Credential, OssecServer, ClientKey}
$Client = @{Computer = "client.mycorp.local"; Credential = "mycorp.local\sysop"; OssecServer = "10.13.0.1"; ClientKey = "base64key"}

.Example
$Client1 = @{Computer = "host1"; Credential = "mycorp.local\sysop"; OssecServer = "10.13.0.1"; ClientKey = "base64key"}
$Client1 | Set-OssecAuthenticationInfo

.Example
$Client1 = @{Computer = "host1"; Credential = "mycorp.local\sysop"; OssecServer = "10.13.0.1"; ClientKey = "base64key"}
$Client2 = @{Computer = "host2"; Credential = "mycorp.local\sysop"; OssecServer = "10.13.0.1"; ClientKey = "base64key"}
$Client1, $Client2 | Set-OssecAuthenticationInfo

#>

function Set-OssecAuthenticationInfo
{
    [CmdletBinding()]
    param(
    [Parameter(ValueFromPipeline=$True,Mandatory=$True)]
    [Hashtable[]]$ClientInfo,
    [String]$ErrorLog ="$Home\Set-OssecAuthenticationInfo_errors.txt"
          )
    
    Begin{}

    Process{
    try{
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value $ClientInfo.Computer

    Invoke-Command -ComputerName $ClientInfo.Computer -Credential $ClientInfo.Credential -ScriptBlock {
    param ($Base64Key,$OssecServerIP)
    $OssecPath = "C:\Program Files (x86)\ossec-agent\"
    $DecodedKey = [System.Text.Encoding]::ASCII.GetString([System.Convert]::FromBase64String($Base64Key)).Trim()
    $DecodedKey | ? {$_.trim() -ne "" } | Set-Content "$OssecPath\client.keys"
    (Get-Content "$OssecPath\ossec.conf") | ForEach-Object { $_ -replace "<ossec_config>", "<ossec_config>`r`n<client>`r`n<server-ip>$OssecServerIP</server-ip>`r`n</client>" } | Set-Content "$p\ossec.conf"
    Restart-Service OssecSvc
                                            } -ArgumentList $ClientInfo.ClientKey, $ClientInfo.OssecServer
       }
    catch{$_ | Set-Content $ErrorLog}   
           }
    End{}
 }
