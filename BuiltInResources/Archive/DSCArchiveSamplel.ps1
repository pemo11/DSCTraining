<#
 .Synopsis
 Zip-Datei auspacken der DSC
#>

configuration ArchiveTest
{
    param([String]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        # Per Script-Ressource Zip-Datei herunterladen
        Script DownloadZip
        {
            # muss $true zurückgegeben
            TestScript = { !(Test-Path -Path C:\Temp\Ps1Skripte.zip) } 

            # Rückgabewert muss Hashtable sein - Result spielt keine Rolle?
            GetScript = {
                @{Result = ""}
            }

            SetScript = {
              $Url = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
              Write-Verbose "*** Downloading $Url"
              # $env:temp scheint nicht zu gehen ???
              $LocalPath = "C:\Temp\Ps1Skripte.zip"
              $WC = New-Object -TypeName System.Net.WebClient
              $WC.DownloadFile($Url, $LocalPath)
            } 
        }

        Archive Ps1Zip
        {
            Ensure = "Present"
            # $env:temp scheint nicht zu gehen
            Path = "C:\Temp\Ps1Skripte.zip"
            Destination = "C:\Ps1Skripte"
            Force = $true
            DependsOn = "[Script]DownloadZip"
        }
    }
}

cd $PSScriptRoot

ArchiveTest -ComputerName MobilServer2

Start-DSCConfiguration -Path ArchiveTest -Verbose -Wait -Force