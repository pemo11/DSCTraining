<#
 .Synopsis
 How to use configuration data - example 2
 .Notes
 Separating the where from what or something like this by applying configuration only to certain nodes
#>

configuration ConfigTest2
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    # consider only nodes with a certain value for their DSC role property
    node ($AllNodes.Where{$_.DSCRole -eq "Special"}).NodeName
    {
        Log ConfigTest
        {
            Message = "Creating a directory on a node: {0} Name: {1}" -f $Node.NodeNr, $NodeName
        }
    
        File TestDir
        {
            Ensure  = "Present"
            DestinationPath = $Node.DirectoryPath
            Type = "Directory"
        }
    }
}

$ConfigData = @{
        AllNodes = @(
            @{
                NodeName = "Localhost"
                NodeNr = 1
                Rolle = "Spezial"
                DirectoryPath = "C:\LocalhostTest"
            }
            @{
                NodeName = "Server1"
                NodeNr = 2
                Rolle = "Spezial"
                DirectoryPath = "C:\Server1Test"
            }
            @{
                NodeName = "Server2"
                NodeNr  = 3
                DSCRole = "General"
            }
            @{
                NodeName = "Server3"
                NodeNr  = 4
                DSCRole = "Special"
                DirectoryPath = "C:\Server3Test"
            }
        )
}

ConfigTest2 -ConfigurationData $ConfigData