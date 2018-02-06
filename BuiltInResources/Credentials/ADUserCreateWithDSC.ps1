<#
 .Synopsis
 DSC-Beispiel mit Credentials
 .Description
 Anlegen einer Freigabe
#>

configuration NewPoshShare
{
    param([String[]]$Computername, [PSCredential]$Credential)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xSmbShare

    node $Computername
    {
        xSmbShare Share1
        {
          Ensure = "Present"
          Path = "C:\Users\Administrator\Documents\WindowsPowerShell\Scripts"
          Name = "PoshScripts"
          ReadAccess = "Administrator"
          FullAccess = "PsUser"
          PsDscRunAsCredential = $Credential
        }
    }
}

$PwSec = "demo+123" | Convertto-SecureString -AsPlainText -Force
$Server1ACred = [PSCredential]::new("Administrator", $PwSec)

cd $PSScriptRoot
NewPoshShare -Computername Server1A -Credential $Server1ACred

# Start-DscConfiguration -Path NewPoshShare -Credential $Server1ACred -Wait -Verbose -Force