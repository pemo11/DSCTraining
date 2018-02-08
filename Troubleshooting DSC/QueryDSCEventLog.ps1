<#
 .Synopsis
 Query the DSC event log for error messages without the xDscDiagnostics module
#>

<#
.SYNOPSIS
Gets error messages from the DCS operational log

.DESCRIPTION
Gets error messages from the DCS operational log

.PARAMETER EventId
The EventId

.PARAMETER Count
Number of events

.PARAMETER TimeSpan
Period of time to get events from

.EXAMPLE
Get-DSCErrorLog -TimeSpan "LastHour"

.NOTES
Should include the analytical log too - may be
#>
function Get-DSCErrorLog
{
    param(
        [Int]$EventId,
        [Int]$Count, 
        [ValidateSet("Last30Minute","LastHour","Today")][String]$TimeSpan
    )
    $FilterHt = @{LogName="Microsoft-Windows-Dsc/Operational";Level=2}
    if ($EventId -ne 0) {
        $FilterHt += @{Id=$EventId}
    }
    switch ($TimeSpan)
    {
        "Last30Minute" {
            $DateValue = (Get-Date).AddMinutes(-30)
            $FilterHt += @{StartTime=$DateValue}
        }
        "LastHour" {
            $DateValue = (Get-Date).AddHours(-1)
            $FilterHt += @{StartTime=$DateValue}
        }
        "Today" {
            $DateValue = (Get-Date -Date 0:0)
            $FilterHt += @{StartTime=$DateValue}
        }
    }
    if ($Count -ne 0) {
        $Events = Get-WinEvent -FilterHashtable $FilterHt -MaxEvents $Count
    }
    else {
        $Events = Get-WinEvent -FilterHashtable $FilterHt
    }
    $Events | Format-List -Property Message, TimeCreated, Id
}

# Get-WinEvent -LogName "Microsoft-Windows-Dsc/Operational"

# wevtutil.exe set-log “Microsoft-Windows-Dsc/Analytic” /q:true /e:true
# wevtutil.exe set-log “Microsoft-Windows-Dsc/Debug” /q:True /e:true

# Query all DSC logs
<#
$DscEvents=[System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Operational") `
         + [System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Analytic" -Oldest) `
         + [System.Array](Get-WinEvent "Microsoft-Windows-Dsc/Debug" -Oldest)
#>
