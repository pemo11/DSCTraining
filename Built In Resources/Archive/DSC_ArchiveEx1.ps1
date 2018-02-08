<#
 .Synopsis
 Zip-Datei auspacken der Archive-Ressource
 .Notes
 Es wird eine Datei aus dem Internet geladen und in ein temporäres Verzeichnis kopiert
 das zuvor gegebenenfalls angelegt wird
#>

configuration ArchiveTest
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        # Per Script-Ressource Zip-Datei herunterladen
        Script DownloadZip
        {
            # muss $true zurückgegeben
            TestScript = { 
               #  !(Test-Path -Path $Node.ZipPath) 
               return $true
            } 

            # Rückgabewert muss Hashtable sein - Result spielt keine Rolle?
            GetScript = {
                @{Result = ""}
            }

            SetScript = {
              $Url = $Node.ZipURL
              Write-Verbose "*** Downloading $Url"
              # $env:temp scheint nicht zu gehen ???
              $LocalPath = $Node.ZipPath
              $WC = New-Object -TypeName System.Net.WebClient
              $WC.DownloadFile($Url, $LocalPath)
            } 
        }

        Archive Ps1Zip
        {
            Ensure = "Present"
            # $env:temp scheint nicht zu gehen
            Path = $Node.ZipPath
            Destination = $Node.ZipDestination
            Force = $true
            DependsOn = "[Script]DownloadZip"
        }
    }
}

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
            ZipURL = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
            ZipPath = "C:\Temp\Ps1Skripte.zip"
            DownloadPath = "C:\Temp"
            ZipDestination = "C:\Ps1SkripteAusDemInternet"
        }
    )
}


ArchiveTest -Configuration $ConfigData

Start-DSCConfiguration -Path ArchiveTest -Verbose -Wait -Force