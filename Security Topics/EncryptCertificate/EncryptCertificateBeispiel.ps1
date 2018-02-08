<#
 .Synopsis
 Credentials mit Zertifikat verschlüsseln
#>

configuration CopyFromFileShare
{
    param([PSCredential]$Credential)
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        Script CreateShare
        {
            # muss ein $false liefern
            TestScript = { (Get-WmiObject -Class Win32_Share -Filter "Name='\\\\mobilserver2\\pskurs'") -ne $null }

            GetScript = { @{Result = (Get-WmiObject -Class Win32_Share -Filter "Name='\\\\mobilserver2\\pskurs'") -ne $null}}

            SetScript = ({
                $NetWsh = New-Object -ComObject WScript.Network
                $NetWsh.MapNetworkDrive("P:", "\\Mobilserver2\PsKurs", $false, "{0}", "{1}")
            } -f $Credential.Username, $Credential.GetNetworkCredential().Password)

        }
        
        File file1
        {
            Ensure = "Present"
            SourcePath = "\\Mobilserver2\pskurs\123.csv"
            DestinationPath = "C:\123.csv"
            Type = "File"
       }

        $i = 0
        foreach($DirName in $AllNodes.DirNames)
        {
            File "Dir$((++$i))"
            {
                Ensure = "Present"
                DestinationPath = $DirName
                Type = "Directory"
            }
        }
    }
}

$PwSec = "demo+123" | ConvertTo-SecureString -Force -AsPlainText

$Cred = [PSCredential]::New("Administrator", $PwSec)

$ConfigData = @{
 
    AllNodes = @(
       @{
            NodeName = "Win7B"
            NodeCredential = $Cred
            CertificateFile = "C:\PublicKeys\PsKurs.cer"
            Thumbprint = "613BE3432F2F351DDFDEF8EEE2C86A95D76B8C56"
            DirNames = @("C:\Dir1", "C:\Dir11", "C:\Dir22")
       }
    )
}

CopyFromFileShare -ConfigurationData $ConfigData -Credential $Cred

cd $PSScriptRoot

$Cred = [PSCredential]::New("Pemo7", $PwSec)

Start-DSCConfiguration -Path CopyFromFileShare -Verbose -Wait  -Force -Credential $Cred 