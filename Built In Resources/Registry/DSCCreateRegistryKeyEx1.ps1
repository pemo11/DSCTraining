<#
 .Synopsis
 Einen Registry-Schlüssel per DSC anlegen
 .Description
 PsDscRunAsCredential ist erforderlich
#>

configuration CreateRegKeys
{
        param([PSCredential]$Credential)

        Import-DSCResource -ModuleName PSDesiredStateConfiguration

        Node $AllNodes.NodeName
        {
            Registry Key1
            {
                Ensure = "Present"
                Key = "HKey_Current_User\Software\PsKurs"
                ValueName = "StartTermin"
                ValueData = "1.4.2017"
                ValueType = "String"
                PsDscRunAsCredential = $Credential 
            }
            Registry Key2
            {
                Ensure = "Present"
                Key = "HKey_Current_User\Software\PsKurs"
                ValueName = "AnzahlTeilnehmer"
                ValueData = "7"
                ValueType = "Dword"
                PsDscRunAsCredential = $Credential 
            }
        }
}

cd $PSScriptRoot

# Wichtig: Benutzer-Credentials erforderlich, sonst wird kein Key angelegt

$Username = "Administrator"
$PwSec = "demo+123" | ConvertTo-Securestring -AsPlainText -Force
$Cred = [PSCredential]::new($Username, $PwSec)


$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "Localhost"
            PsDscAllowPlainTextPassword = $true
        }
    )
}

CreateRegKeys  -Credential $Cred -ConfigurationData $ConfigData

Start-DSCConfiguration -Path CreateRegKeys -Wait -Verbose -Force 