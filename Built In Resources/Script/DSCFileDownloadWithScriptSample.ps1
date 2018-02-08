<#
 .Synopsis
 Ein Beispiel fuer die Script-Ressource
#>

configuration ScriptBeispiel
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        Script DownloadZip
        {
            # muss $false zurueckgegeben
            # $env:temp geht nicht
            TestScript = {
                            $LocalFile = $using:Node.LocalFile
                            Test-Path -Path C:\Temp\$LocalFile
                         }

            # Rueckgabewert muss Hashtable sein - Result spielt keine Rolle
            GetScript = {
                @{Result = $true}
            }

            SetScript = {
              # Geht nicht
              # $Url = $Node.Url
              $Url = $using:Node.Url
              $LocalPath = "C:\Temp"
              Write-Verbose "*** Downloading $Url nach $LocalPath ***"
              if (!(Test-Path -Path $LocalPath))
              {
                  md $LocalPath | Out-Null
              }
              try
              {
                $WC = New-Object -TypeName System.Net.WebClient
                $WC.DownloadFile($Url, "$LocalPath\$($using:Node.Localfile)")
              }
              catch
              {
                Write-Verbose "Fehler beim Download: $_"
              }  
            }
        }
    }
}

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "Server1A"
            Url = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
            LocalFile = "PoshSkripte123.zip"
        }
    )
}

cd $PSScriptRoot

ScriptBeispiel -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Server1ACred = [PSCredential]::new("Administrator", $PwSec)

Start-DSCConfiguration -Path ScriptBeispiel -Wait -Verbose -Credential $Server1ACred -Force