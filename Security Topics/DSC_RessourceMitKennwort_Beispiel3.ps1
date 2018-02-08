<#
 .Synopsis
 Umgang mit Credentials in einer Konfiguration - Beispiel Nr. 3
#>

configuration PasswordConfig3
{
  param([PSCredential]$Credential)

  Import-DSCResource -ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xActiveDirectory

  node Localhost
  {

    xADUser UserNeu
    {
      Ensure = "Present"
      UserName = "DSCTest2"
      DomainName = "pshub.local"
      DisplayName = "DSC-Test User Nr. 2"
      Enabled = $true
      Password = $Credential
    }

    LocalConfigurationManager
    {
        CertificateID = $Node.ThumbPrint
    }
  }
}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Cred = [PSCredential]::new("Administrator", $PwSec)

$CertThumb = (dir Cert:\LocalMachine\My -Eku "1.3.6.1.4.1.311.80.1"| Where Subject -eq "CN=PMServer").Thumbprint

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Localhost"
            CertificateFile = "C:\PublicKeys\PMServer.cer"
            Thumbprint = $CertThumb
         }
    )
}

PasswordConfig3 -ConfigurationData $ConfigData -Credential $Cred  