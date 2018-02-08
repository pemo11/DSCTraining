<#
 .Synopsis
 Processing AllNodes with Where and a multi value property with ForEach
#>

configuration RoleConfigSample2
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    # First apply a configuration only to certain nodes
    node $AllNodes.Where{$_.Role -eq "Test"}.NodeName
    {
        $i = 0
        # And then process an array property with foreach
        $Node.Files.ForEach{
            $i++
            File "file$i"
            {
                Ensure = "Present"
                DestinationPath = $_
                Contents = $ConfigurationData.NodeData.FileContent
            }
        }
    }
}

$ConfigData = @{
 
    AllNodes = @(
        @{
            NodeName = "Server1"
            Role = "Production"
            FilePath = "C:\AllNodesMitForEach.txt"
        },
        @{
            NodeName = "MobilServer2"
            Role = "Test"
            Files = "C:\DSC01.txt", "C:\DSC02.txt", "C:\DSC03.txt"
        },
        @{
            NodeName = "Localhost"
            Role = "Test1"
            Files = "C:\DSC11.txt", "C:\DSC22.txt"
        }

    )

    NodeData = @{
        FileContent = "DSC was here again!"
    }
}

RoleConfigSample2 -ConfigurationData $ConfigData

# Start-DSCConfiguration -Path RoleConfigSample2 -Verbose -Wait # -Force

# For Troubleshooting
# Remove-DscConfigurationDocument -Stage Current, Pending, Previous -Verbose
