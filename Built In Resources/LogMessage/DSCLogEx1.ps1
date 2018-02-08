<#
 .Synopsis
 Log-Eintrag schreiben per  DSC
#>

configuration LogTest
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node localhost
    {
        Log Log1
        {
            # Erscheint im Microsoft-Windows-DSC/Analytic-Log als Teil von Message
            Message = "Alles klar mit DSC"
        }
    }
}

cd $PSScriptRoot


LogTest

# Erst dadurch werden die Meldungen geschrieben
# Start-DSCConfiguration -Path LogTest -Verbose -Wait

# DSC-Log ausgeben
# Get-WinEvent -LogName Microsoft-Windows-DSC/Analytic -Oldest  | Select Id, TimeCreated, Message
