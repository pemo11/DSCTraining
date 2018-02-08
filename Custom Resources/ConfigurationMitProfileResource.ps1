<#
 .Synopsis
 Konfiguration mit CustomResource
#>

configuration SetProfile
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ProfileResource 

    node $AllNodes.Nodename
    {
        xPSProfileResource Profile
        {
            Ensure = "Present"
            Username = "Pemo2"
            ProfileType = "CurrentUserAllHosts"
            ErrorBackgroundColor = "White"
        }
    }

}

$ConfigData = @{
    AllNodes = @(
      @{ 
        NodeName = "PMServer"
       }
    )
}

SetProfile -ConfigurationData $ConfigData

Copy .\SetProfile\PMServer.mof "C:\Program Files\WindowsPowerShell\DscService\Configuration\PoshConfig.mof"
# Der Force-Parameter ist wichtig, damit die Checksum aktualisiert wird

New-DscChecksum -Path "C:\Program Files\WindowsPowerShell\DscService\Configuration" -Force -Verbose