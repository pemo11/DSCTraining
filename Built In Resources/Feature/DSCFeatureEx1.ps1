<#
 .Synopsis
 Install a Windows Feature
 .Notes
 Why doing this with DSC? Because adding a feature is always part of a configuration setting
 on a higher level like setting up a website
 Don't even think about an if statement for testing if the feature already exists
 This is not the way DSC works and its not necesseary anyway

 Only works on Windows Server
#>

configuration WinFeatureEx1
{
    param([String[]]$Computername, [String]$Featurename)
    
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        WindowsFeature Feature1
        {
            Ensure = "Present"
            Name = $Featurename
            LogPath = "C:\FeatureInstall.log"
        }
    }

}

cd $PSScriptRoot

WinFeatureEx1 -Computername localhost -FeatureName WindowsPowerShellWebAccess

Start-DSCConfiguration -Path FeatureTest -Wait -Verbose