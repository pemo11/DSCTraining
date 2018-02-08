<#
 .Synopsis
 Configure the LCM for a reboot - alternative A
#>

[DSCLocalConfigurationManager()]
configuration LCMSetup1
{
  
  node Localhost
  {
    settings
    {
        RebootNodeIfNeeded = $true
        RefreshFrequencyMins =  45
        ConfigurationMode = "ApplyOnly"
        ActionAfterReboot =  "ContinueConfiguration"
    }
  }
}

LCMSetup1

Set-DscLocalConfigurationManager -Path .\LCMSetup1 -Verbose 

Get-DscLocalConfigurationManager