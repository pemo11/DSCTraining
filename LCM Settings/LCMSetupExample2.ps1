<#
 .Synopsis
 Configure the LCM for a reboot - alternative B
#>

configuration LCMSetup2
{
  
  LocalConfigurationManager
  {
        RebootNodeIfNeeded = $false
        RefreshFrequencyMins =  33
        ConfigurationMode = "ApplyOnly"
        ActionAfterReboot =  "ContinueConfiguration"
  }
}

LCMSetup2

Set-DscLocalConfigurationManager -Path .\LCMSetup2 -Verbose 

Get-DscLocalConfigurationManager