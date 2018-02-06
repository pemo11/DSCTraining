<#
 .Synopsis
 A small DSC example for using configuration data
 #>

configuration HalloDSC
{

    Import-DscResource –ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {

        # Creating the directory
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = $Node.SharePath
            Type = "Directory"
        }

        # Creating the file
        File TestFile
        {
            Ensure = "Present"
            DestinationPath = (Join-Path -Path $Node.SharePath -Child $Node.Filename)
            Contents = $AllNodes.PoshContent
            Type = "File"
        }
        
    }

}

$ConfData = @{

     AllNodes = @(
        @{
            NodeName = "Localhost"
            PoshContent = "`"The current local time: `$(Get-Date -Format t)`""
            SharePath = "C:\PoshScripts"
            FileName = "Test.ps1"
        }
    )
}

# HalloDSC -ConfigurationData $ConfData

# Start-DscConfiguration HalloDSC -Verbose -Wait