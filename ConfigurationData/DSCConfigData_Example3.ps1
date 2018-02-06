<#
 .Synopsis
 How to use configuration data - example 3
 .Notes
 Config data does not have to be part of the hashtable
#>

configuration ConfigTest3
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        File TestFile
        {
            Ensure  = "Present"
            DestinationPath = $Node.FilePath
            Type = "File"
            Contents = $ConfigurationData.FileContent
        }

    }
}

$ConfigData = @{

    FileContent = "Let the good times roll with DSC!"

    AllNodes = @(
        @{
            NodeName = "*"
            FilePath = "C:\DSCTest.txt"
        }
        @{
            NodeName = "Server1"
        }
        @{
            NodeName = "Server2"
        }
    )
}

ConfigTest3 -ConfigurationData $ConfigData 