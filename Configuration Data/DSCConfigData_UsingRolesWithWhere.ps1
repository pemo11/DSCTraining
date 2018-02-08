<#
 .Synopsis
 Process the AllNodes array with Where
#>

configuration RoleConfig
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    # First apply a configuration only to certain nodes
    node $AllNodes.Where{$_.Role -eq "Test"}.NodeName
    {
        File file1
        {
            Ensure = "Present"
            DestinationPath = "C:\RoleConfigSample.txt"
            Contents = $ConfigurationData.NodeData.FileContent
        }
    }
}

$ConfigData = @{
 
    AllNodes = @(
        @{
            NodeName = "Server1"
            Role = "Production"
        },
        @{
            NodeName = "Server2"
            Role = "Test"
        }
    )

    NodeData = @{
        FileContent = "DSC was here again!"
    }
}

RoleConfigSample1 -ConfigurationData $ConfigData

# Start-DSCConfiguration -Path RoleConfigSample1 -Verbose -Wait