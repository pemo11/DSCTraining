<#
 .Synopsis
 Example for the local resource
#>

configuration LogEx1
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node localhost
    {
        Log Log1
        {
            # Erscheint im Microsoft-Windows-DSC/Analytic-Log als Teil von Message
            Message = "Personal: DSC makes the world go crazy"
        }
    }
}

cd $PSScriptRoot


LogEx1

# Activate Analytic log once and forever
# wevtutil.exe sl "Microsoft-Windows-Dsc/Analytic" /q:true /e:true

Start-DSCConfiguration -Path .\LogEx1 -Verbose -Wait -Force

# DSC-Log ausgeben
Get-WinEvent -LogName Microsoft-Windows-DSC/Analytic -Oldest  | 
 Where-Object Message -match "Personal" | Select-Object -Property Id, TimeCreated, Message -First 3 | Format-List
