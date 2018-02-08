<#
 .Synopsis
 Beispiel für die Script-Ressource
 .Description
 Es war ein ganz schönes "Gefrimel" bis das Einsetzen der Node-Eigenschaft DriveName endlich funktioniert hat
#>

configuration ScriptBeispiel
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        Script MapShare1
        {
            # Muss $false ergeben, damit SetScript ausgeführt wird
            TestScript = "(Get-PSDrive -Name $($Node.DriveName) -ErrorAction Ignore) -ne `$null"
            
            # Hier kommt es auf ein $Result=$true an
            GetScript = "@{Result=(Get-PSDrive -Name $($Node.DriveName) -ErrorAction Ignore) -eq `$null}" 
            
            SetScript = ({
                $Username = "{0}"
                $Password = "{1}" 
                $DriveName = "{2}:"
                $RemotePath = "{3}"
                New-SmbMapping -LocalPath $DriveName -RemotePath $RemotePath -Username $Username -Password $Password
            } -f $Node.Credential.Username, $Node.Credential.GetNetworkCredential().Password, $Node.DriveName, $Node.RemotePath)
        }
    }

}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force    
$Server1ACred = [PSCredential]::New("Administrator", $PwSec)

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "Server1A"
            DriveName = "U"
            RemotePath = "\\mobilserver2\pskurs"
            Credential = $Server1ACred
            PSDscAllowPlainTextPassword = $true
        }
    )
}

cd $PSScriptRoot

ScriptBeispiel -Computername Server1A -ConfigurationData $ConfigData 

Start-DSCConfiguration -Path ScriptBeispiel -Wait -Verbose -Credential $Server1ACred -Force