<#
 .Synopsis
 A simple partial configuration for push mode - Setup
#>

# Step 1: Configure the LCM for Partial Configuration

[DSCLocalConfigurationManager()]
configuration PartConfSetup
{

    node $AllNodes.NodeName
    {
        PartialConfiguration Config1
        {
            Description = "Creates just a directory"
            RefreshMode = "Push"
        }
        
        PartialConfiguration Config2
        {
            Description = "Creates just a file"
            RefreshMode = "Push"
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "w2016A"
        }
    )
}

PartConfSetup -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::new("Administrator", $PwSec)
$Hostname = "w2016A"

Set-DscLocalConfigurationManager -Path .\PartConfSetup -ComputerName $Hostname -Credential $PSCred -Force -Verbose 