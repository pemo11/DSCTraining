<#
 .Synopsis
 Umgebungsvariable anlegen
 .Description
 Es wird immer eine System-Variable angelegt
 Wichtig: Damit die Änderung beim Start der PowerShell übernommen wird,
 muss eventuell Explorer neu gestartet werden!
#>

configuration EnvTest
{
    param([String]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $Computername
    {
        File Dir1
        {
            Ensure = "Present"
            DestinationPath = "C:\PsTools"
            Type = "Directory"
        }

        File File1
        {
            Ensure = "Present"
            SourcePath = "F:\Tools\Smtp4Dev.exe"
            DestinationPath = "C:\PsTools\Smtp4Dev2.exe"
            Type = "File"
            DependsOn = "[File]Dir1"
        }

        Environment Env1
        {
            Ensure = "Present"
            Name = "Path"
            Path = $true
            Value = "C:\PsTools"
            DependsOn = "[File]Dir1"
        }
    }
}

cd $PSScriptRoot

EnvTest -Computername Localhost

Start-DSCConfiguration -Path EnvTest -Wait -Verbose -Force

