<#
 .Synopsis
 Einen Prozess starten per DSC
#>

configuration StartProcess
{
        param([String[]]$Computername)

        Import-DSCResource -ModuleName PSDesiredStateConfiguration

        Node $Computername
        {
            WindowsProcess Test
            {
                Ensure = "Present"
                Arguments = "/c dir C: /s"
                Path = "C:\Windows\System32\Cmd.exe"
                StandardOutputPath = "C:\CmdOutput.txt"
            }
        }
 

StartProcess -ComputerName Server1A

cd $PSScriptRoot

$Username = "Administrator"
$PwSec = "demo+123" | ConvertTo-Securestring -AsPlainText -Force
$Cred = [PSCredential]::new($Username, $PwSec)

Start-DSCConfiguration -Path StartProcess -Wait -Verbose -Credential $Cred