<#
 .Synopsis
 How to use configuration data - example 1
#>

configuration ConfigTest1
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        Log ConfigTest
        {
            Message = "Creating a directory {0} on node: {1}" -f $Node.DirectoryPath, $NodeName
        }
    
        File TestDir
        {
            Ensure  = "Present"
            DestinationPath = $Node.DirectoryPath
            Type = "Directory"
        }
        
        File TestFile
        {
            Ensure  = "Present"
            DestinationPath = Join-Path -Path $Node.DirectoryPath -ChildPath $Node.TheFileName
            Contents = "Happy days are here again thanks to DSC!"
            Type = "File"
        }

    }
}

$ConfigData = @{

        AllNodes = @(
            @{
                NodeName = "*"
                TheFileName = "DSCTest.txt"
            }
            @{
                NodeName = "Server1"
                DirectoryPath = "C:\Server1Test"
            }
            @{
                NodeName = "Server2"
                VerzPfad = "C:\Server2Test"
            }
        )
}

ConfigTest1 -ConfigurationData $ConfigData