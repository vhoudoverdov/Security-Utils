<# 
.SYNOPSIS 
    Return a .NET DateTime object that falls within a specified range.
    Vasken Houdoverdov
.DESCRIPTION 
    Part of a module that facilitiates the generation of random DateTime objects and the modification of FileInfo objects to the resulting dates.
.EXAMPLE
    New-RandomDate
#> 
Function New-RandomDate {
$Ceiling = Get-Date -Year 2100 -Month 12 -Date 31
$Floor = Get-Date -Year 1980 -Month 12 -Date 31
Return $(New-Object DateTime($(Get-Random -Max $Ceiling.Ticks -Min $Floor.Ticks))).ToUniversalTime()
}

<# 
.SYNOPSIS 
    Utility for timestomping files in the specified path.  
    Several properties of object type System.IO.FileInfo are modified as a result.
    Vasken Houdoverdov
.DESCRIPTION 
    Part of a module that facilitiates the generation of random DateTime objects and the modification of FileInfo objects to the resulting dates.
.Example 
    Timestomp-Files $Path
#> 

Function Timestomp-Files {
Param([string]$Path)

if(!$(Test-Path $Path)){throw "The specified path wasn't found:  $Path"}
if(!$(Test-Path "$Path\*")){throw "The specified path was empty:  $Path"}

Get-ChildItem $Path | % {
$_.LastAccessTime = $(New-RandomDate)
$_.LastWriteTime = $(New-RandomDate)
$_.LastAccessTimeUTC = $(New-RandomDate)
$_.LastWriteTimeUTC = $(New-RandomDate)
$_.CreationTime = $(New-RandomDate)
$_.CreationTimeUTC = $(New-RandomDate)
}}