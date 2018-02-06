<#
 .Synopsis
 Creating a user profile file on a remote computer with DSC
#>

configuration PoshConfig
{
    param([String[]]$Computername, 
          [Parameter(Mandatory=$true)][String]$Username)

    $Ps1Content = "# A sample for a powershell profile script`n"
    $Ps1Content += "`$PsHost.PrivateData.ErrorBackgroundColor = 'White'`n"
    $Ps1Content += "cd `$env:userprofile\documents\windowspowershell`n"

    Import-DscResource -ModuleName PsDesiredStateConfiguration

    node $Computername
    {
        # Create a directory for command line tools
        File ToolsDir
        {
            Ensure = "Present"
            DestinationPath = "$env:userprofile\documents\tools"
            Type = "Directory"
        }

        # Create the Windows PowerShell directory
        File Ps1Dir
        {
            Ensure = "Present"
            DestinationPath = "C:\Users\$Username\Documents\WindowsPowerShell"
            Type = "Directory"
        }

        # Create the profile file
        File Ps1File
        {
            Ensure = "Present"
            DependsOn = "[File]Ps1Dir"
            DestinationPath = "$env:userprofile\documents\WindowsPowerShell\Profile.ps1"
            Contents = $Ps1Content
            Type = "File"
        }

        # Append the tools directory to the path environment variable
        Environment Tools
        {
            Ensure = "Present"
            Name = "Path"
            Path = $true
            Value = "$env:userprofile\documents\tools"
        }
    }

}

# PoshConfig -Computername Localhost -Username PsHub-Admin

# Start-DscConfiguration -Path .\PoshConfig -Wait -Verbose -Force