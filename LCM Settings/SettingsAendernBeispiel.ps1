<#
 .Synopsis
 Ändern einer LCM-Einstellung
#>

[DSCLocalConfigurationManager()]
configuration LCMSettings
{   
    node Localhost
    {
        Settings
        {
            RebootNodeIfNeeded = $false
        }
    }
}

cd $PSScriptRoot

LCMSettings

Set-DscLocalConfigurationManager -Path LCMSettings

Get-DscLocalConfigurationManager