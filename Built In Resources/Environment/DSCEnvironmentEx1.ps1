<#
 .Synopsis
 Example for the environment resource
 .Description
 Adding a path to the path system environment variable
 .Notes
 Restarting the explorer can be necessary
#>

configuration EnvironmentEx1
{
    param([String]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        # Create a new directory
        File PoshDir
        {
            Ensure = "Present"
            DestinationPath = "C:\PoshTools"
            Type = "Directory"
        }

        # extend the path environment variable
        Environment Add2Path
        {
            Ensure = "Present"
            Name = "Path"
            Path = $true
            Value = "C:\PoshTools"
            DependsOn = "[File]PoshDir"
        }
    }
}

cd $PSScriptRoot

EnvironmentEx1 -Computername Localhost

Start-DSCConfiguration -Path .\EnvironmentEx1 -Wait -Verbose -Force

