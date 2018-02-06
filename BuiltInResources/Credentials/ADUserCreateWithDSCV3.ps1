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

[DSCLocalConfigurationManager()]
configuration SetCertificateId
{
    param([String[]]$Computername, [String]$Thumbprint)

    node $Computername
    {
        Settings
        {
            CertificateId = $Thumbprint
        }
    }
}

cd $PSScriptRoot

$PwSec = "demo+123" | Convertto-SecureString -AsPlainText -Force
$Server1ACred = [PSCredential]::new("Administrator", $PwSec)

SetCertificateId -Computername Server1A -Thumbprint "‎B9E2B7C05AB8391CBFB7EE4A277CCBFB6EBA31B5" 

Set-DscLocalConfigurationManager -Path SetCertificateId -ComputerName Server1A -Credential $Server1ACred -Verbose

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Server1A"
            NodeCredentials = $Server1ACred
            CertificateFile = "C:\PublicKeys\DSCCred.cer"
            Thumbprint = "‎B9E2B7C05AB8391CBFB7EE4A277CCBFB6EBA31B5"
        }
    )
}

# NewPoshShare -ConfigurationData $ConfigData


# Set-DscLocalConfigurationManager -Path .\NewPoshShare -Credential $Server1ACred -Verbose

# Start-DscConfiguration -Path NewPoshShare -Credential $Server1ACred -Wait -Verbose -Force