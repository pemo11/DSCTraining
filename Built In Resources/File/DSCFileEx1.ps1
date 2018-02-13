<#
 .Synopsis
 Sets up a powershell profile file for a user account
 .Notes 
 The name of the user account does not has to exist because only the folder structure will be created
#>

configuration FileEx1
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {
        $Username = $Node.Username

        File ProfileDir
        {
            Ensure = "Present"
            DestinationPath = "C:\Users\$Username\Documents\WindowsPowerShell"
            Type = "Directory"
            Force = $true
        }

        File ProfileFile
        {
            Ensure = "Present"
            DestinationPath = "C:\Users\$Username\Documents\WindowsPowerShell\Profile.ps1"
            Contents = $AllNodes.ProfileContent
            Type = "File"
            DependsOn = "[File]ProfileDir"
        }
    }
}

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "localhost"
            Username = "Administrator2"
            ProfileContent = "`$Host.PrivateData.ErrorBackgroundColor = 'White'"
        }
    )
}

cd $PSScriptRoot

FileEx1 -ConfigurationData $ConfigData

Start-DSCConfiguration -Path .\FileEx1 -Wait -Verbose -Force

