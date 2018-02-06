<#
 .Synopsis
 A simple DSC example for creating a directory and a file on drive C: on the local computer
 #>

configuration HalloDSC
{
    Import-DscResource –ModuleName PSDesiredStateConfiguration

    node localhost
    {
        # Create a directory
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshScripts"
            Type = "Directory"
        }

        # Create a file
        File TestFile
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshScripts\Test.ps1"
            Type = "File"
            Contents = "`"The current time is: $(Get-Date -Format t)`""
        }
    }

 }

# Generate a mof file localhost.mof
# HalloDSC

# Apply the configuration to the local computer
# Start-DscConfiguration -Path .\HalloDSC -Verbose -Wait