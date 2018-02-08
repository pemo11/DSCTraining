<#
 .Synopsis
 DSC-Fehleranalyse mit Hilfe des Moduls xDscDiagnostics
#>

# Ausgabe aller Meldungen, um die SequenceID zu finden

# wevtutil clear-log Microsoft-Windows-DSC/Operational
# wevtutil clear-log Microsoft-Windows-DSC/Analytic

# Update-xDscEventLogStatus -Channel Analytic -Status Enabled
# Update-xDscEventLogStatus -Channel Debug -Status Enabled
# Update-xDscEventLogStatus -Channel Analytic -Status Disabled

Get-Command -Module xDscDiagnostics

Get-xDscOperation  


# [Microsoft.PowerShell.xDscDiagnostics.EventType].GetFields().Name

Trace-xDscOperation -SequenceID 4 |  Where-Object EventType -eq "Error" | fl Message