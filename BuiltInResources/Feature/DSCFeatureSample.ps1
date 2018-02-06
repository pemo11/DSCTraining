<#
 .Synopsis
 Windows-Feature anlegen per DSC
#>

configuration FeatureTest
{
    param([String[]]$Computername)
    
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    
    node $Computername
    {
        WindowsFeature Feature1
        {
            Ensure = "Present"
            Name = "WindowsPowerShellWebAccess"
            LogPath = "C:\FeatureInstall.log"
        }
    }

}

cd $PSScriptRoot

FeatureTest -Computername MobilServer2

Start-DSCConfiguration -Path FeatureTest -Wait -Verbose