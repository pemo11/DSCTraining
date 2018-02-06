<#
 .Synopsis
 A simple DSC example for creating a PowerShell profile directory
 #>

 configuration Ps1Profile
 {
   param([String[]]$Computername)

   Import-DscResource –ModuleName PSDesiredStateConfiguration

   node $Computername
   {
     File ProfileDir
     {
       Ensure = "Present"
       DestinationPath = "C:\Users\Administrator\Documents\WindowsPowerShell\Profile"
       Type = "Directory"
     }

   }
 }