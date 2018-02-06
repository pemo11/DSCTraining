<#
 .Synopsis
 AllNodes verarbeiten
#>

configuration RoleConfig
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.Where{$_.Role -eq "Test"}.NodeName
    {
        File file1
        {
            Ensure = "Present"
            DestinationPath = "C:\RoleConfigBeispiel.txt"
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
            NodeName = "MobilServer2"
            Role = "Test"
        }
    )

    NodeData = @{
        FileContent = "DSC was here again!"
    }
}

cd $PSScriptRoot

RoleConfig -ConfigurationData $ConfigData

Start-DSCConfiguration -Path RoleConfig -Verbose -Wait