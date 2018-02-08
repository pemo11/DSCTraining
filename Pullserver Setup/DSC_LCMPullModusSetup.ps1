<#
 .Synopsis
 LCM für Pullserver konfigurieren
#>

[DSCLocalConfigurationManager()]
configuration LCMSetup
{
    node localhost
    {
        Settings
        {
            RefreshMode = "Pull"
            # Ist die Default-Einstellung
            ConfigurationMode = "ApplyAndMonitor"
            AllowModuleOverwrite = $true
        }

        ConfigurationRepositoryWeb MeinPullServer
        {
            ServerURL = "https://PMServer:8088/PSDSCPullServer.svc"
            RegistrationKey = "a017fb5b-1808-48f3-acc4-17e6a72138c1"
            ConfigurationNames = @("PoshConfig")
        }
    }
}

LCMSetup

Set-DscLocalConfigurationManager -Path .\LCMSetup -Verbose -Force 