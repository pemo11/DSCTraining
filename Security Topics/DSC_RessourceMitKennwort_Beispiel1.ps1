<#
 .Synopsis
 Umgang mit Credentials in einer Konfiguration - Beispiel Nr. 1
#>

configuration PasswordConfig1
{
  param(
     [PSCredential]$Credential
 )

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

PasswordConfig1 -Credential $Cred   