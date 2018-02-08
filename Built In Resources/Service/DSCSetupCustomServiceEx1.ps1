<#
 .Synopsis
 Einen Systemdienst installieren
#>

configuration SetupQuoteService
{
    param([String]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        Service QuoteService
        {
            Ensure = "Present"
            Name = "Zitatedienst"
            BuiltInAccount = "LocalSystem"
            StartupType = "Manual"
            Description = "Originelle StarTrek-Zitate aus TOS"
            DisplayName = "TOS-Zitatedienst"
            Path = "F:\PoshSkripte\DSC\BuchBeispiele\Service\Zitatedienst.exe"
        }
    }
}

SetupQuoteService -Computername Localhost

Start-DSCConfiguration -Path SetupQuoteService -Wait -Verbose -Force