<#
 .Synopsis
 Query the DSC event log with the xDscDiagnostics module
#>

# Install-Module -Name xDscDiagnostics -Force

Import-Module -Name xDscDiagnostics
Get-Command -Module xDscDiagnostics

# Get Details for DSC Operations
Get-xDscOperation

Get-xDscOperation -Newest 5

# Get details about DSC events
# The sequence Id is the number of the DSC operation
# 1 means last operation etc. just run Get-xDscOperation before
Trace-xDscOperation -SequenceID 1
$Trace = Trace-xDscOperation -SequenceID 9
$Trace.Event | Format-List -Property TimeCreated, Message

# Getting events for a remote computer

# Create a firewall rule first
# New-NetFirewallRule -Name "Service RemoteAdmin" -DisplayName "Remote DSC Eventlog" -Action Allow

# Trace-xDscOperation -ComputerName Server1 -Credential Get-Credential Administrator -SequenceID 5

# Reset the mof cache
Stop the dsccore provider processes
