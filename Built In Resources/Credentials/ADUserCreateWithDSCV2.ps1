<#
 .Synopsis
 DSC-Beispiel mit Credentials
 .Description
 Anlegen einer Freigabe
#>

configuration NewPoshShare
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xSmbShare

    node $AllNodes.NodeName
    {
        xSmbShare Share1
        {
          Ensure = "Present"
          Path = "C:\Users\Administrator\Documents\WindowsPowerShell\Scripts"
          Name = "PoshScripts"
          ReadAccess = "Administrator"
          FullAccess = "PsUser"
          PsDscRunAsCredential = $Node.NodeCredentials
        }
    }
}

$PwSec = "demo+123" | Convertto-SecureString -AsPlainText -Force
$Server1ACred = [PSCredential]::new("Administrator", $PwSec)

cd $PSScriptRoot

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Server1A"
            NodeCredentials = $Server1ACred
            PSDscAllowPlainTextPassword = $true
        }
    )
}

NewPoshShare -ConfigurationData $ConfigData

# Start-DscConfiguration -Path NewPoshShare -Credential $Server1ACred -Wait -Verbose -Force