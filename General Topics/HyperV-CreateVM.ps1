<#
 .Synopsis
 Hyper VM per DSC anlegen
#>

$ConfigData = @{

    AllNodes = @(
        @{
            NodeName = "PMServer"
            VhdPath = "E:\HyperV\Virtual Hard Disks\WindowsServer2012R2.vhdx"
            VhdSize = 64GB
        }
    )
}

configuration SetupVM
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DSCResource -ModuleName xHyper-V

    node $AllNodes.NodeName
    {
        
       
        xVMHyperV DSCServerVm
        {
            Ensure = "Present"
            Name = "DSCServer2"
            Generation = 1
            StartupMemory = 1024MB
            EnableGuestService = $true
            ProcessorCount = 2
            SwitchName = "ExternesNetzwerk"
            VhdPath = $Node.VhdPath
            State = "Running"
        }

    }
}

SetupVm -ConfigurationData $ConfigData

cd $PSScriptRoot

Start-DscConfiguration -Path SetupVm -Wait -Verbose -Force