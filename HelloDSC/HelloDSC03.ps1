<#
 .Synopsis
 A simple DSC example for creating a directory and a Smb Share on the local computer
 .Nodes
 The Module xSmbShare is a requirement
 #>

configuration HalloDSC
{

    Import-DscResource –ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xSmbShare

    node localhost
    {

        # Create the directory
        File TestDir
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshScripts"
            Type = "Directory"
        }

        # Create the file
        File TestFile
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshScripts\Test.ps1"
            Type = "File"
            Contents = "`"The current local time is : `$(Get-Date -Format t)`""
        }
        
        # Doesn't work on Windows 7 and Windows Server 2008 R2
        xSmbShare PoshShare
        {
            Ensure = "Present"
            Name = "PoshScripts"
            Path = "C:\PoshScripts"
            Description = "All my PowerShell scripts written in the last 10 years"
        }
    }

}

# HalloDSC 

# Start-DscConfiguration -Path .\HalloDSC -Verbose -Wait