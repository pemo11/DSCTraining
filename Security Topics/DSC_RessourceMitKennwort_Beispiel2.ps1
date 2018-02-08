<#
 .Synopsis
 Umgang mit Credentials in einer Konfiguration - Beispiel Nr. 2
#>

configuration PasswordConfig2
{
  param([PSCredential]$Credential)

  Import-DSCResource -ModuleName PSDesiredStateConfiguration
  Import-DSCResource -ModuleName xActiveDirectory

  node Localhost
  {
 
    xADUser UserNeu
    {
      Ensure = "Present"
      UserName = "DSCTest1"
      DomainName = "pshub.local"
      DisplayName = "DSC-Test User Nr. 1"
      Enabled = $true
      Password = $Credential
    }
  }
}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Cred = [PSCredential]::new("Administrator", $PwSec)

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Localhost"
            PSDscAllowPlainTextPassword = $true
        }
    )
}

PasswordConfig2 -ConfigurationData $ConfigData -Credential $Cred  