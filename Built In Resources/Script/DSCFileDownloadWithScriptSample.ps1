<#
 .Synopsis
 Download a file with wget and the script resource
#>

configuration ScriptDownloadEx1
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        $TmpFilePath = Join-Path -Path C:\Temp -ChildPath (Split-Path -Path $Node.DownloadUrl -Leaf)

        Script DownloadFile
        {
            # has to return false otherwise no action is taken that is set is not called
            TestScript = {
                            Test-Path -Path $using:TmpFilePath
                         }

            # return value does not matter - just has to be a hashtable
            GetScript = {
                @{Result = $true}
            }

            SetScript = {
                $Url = $using:Node.DownloadUrl
                Write-Verbose "*** Downloading $Url nach $using:TmpFilePath ***"
                try
                {
                    Invoke-WebRequest -uri $Url -OutFile $using:TmpFilePath
              }
              catch
              {
                    Write-Verbose "Error downloading $Url ($_)"
              }  
            }
        }
    }
}

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
            DownloadUrl = "http://www.activetraining.de/Downloads/Ps1Skripte.zip"
        }
    )
}

# cd $PSScriptRoot

ScriptDownloadEx1 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::new("Administrator", $PwSec)

Start-DSCConfiguration -Path .\ScriptDownloadEx1 -Wait -Verbose -Force # -Credential $PSCred -Force

dir C:\temp\*.zip