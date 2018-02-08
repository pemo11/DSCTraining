<#
 .Synopsis
 A simple partial configuration for push mode - example 2
#>

configuration Config2
{
    node $AllNodes.Nodename
    {
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = "C:\DSCWasHere\LookHere2.txt"
            Contents = "More Happy times with DSC"
            Type = "File"
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

Config2 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::new("Administrator", $PwSec)
$Hostname = "w2016A"

Publish-DscConfiguration -Path .\Config2 -ComputerName $Hostname -Credential $PSCred

Start-DscConfiguration -ComputerName $Hostname -Credential $PSCred -Wait -Verbose -UseExisting