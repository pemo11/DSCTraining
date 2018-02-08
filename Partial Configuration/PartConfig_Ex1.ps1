<#
 .Synopsis
 A simple partial configuration for push mode - example 1
#>

configuration Config1
{
    node $AllNodes.Nodename
    {
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = "C:\DSCWasHere"
            Type = "Directory"
        }
    }
}

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "W2016A"
        }
    )

}

Config1 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::new("Administrator", $PwSec)
$Hostname = "w2016A"
Publish-DscConfiguration -Path .\Config1 -ComputerName $Hostname -Credential $PSCred

Start-DscConfiguration -ComputerName $Hostname -Credential $PSCred -Wait -Verbose -UseExisting