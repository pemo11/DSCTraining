<#
 .Synopsis
 Install several apps with the package resource
#>

configuration InstallApps1
{
    node $AllNodes.NodeName
    {
        foreach($Product in $Node.ProductList)
        {
            $PackageData = $ConfigurationData.Packages[$Product]

            Package $PackageData.Name
            {
                Ensure = "Present"
                Name = $PackageData.FullName
                ProductId = $PackageData.ProductId
                Path = $PackageData.Path
                Arguments = $PackageData.InstallArguments
            }
        }
    }
}

$ConfigData = @{

    Packages = @{

        "SevenZip" = @{
            Name = "7Zip"
            Version = ""
            FullName = "7 Zip 16.04 (x64)"
            ProductId = ""
            Path = "C:\Packages\7Zip\7z1604-x64.exe"
            InstallArguments = "/S"
        }
        
        "NotepadPP" = @{
            Name = "NotepadPP"            
            Version = ""
            FullName = "Notepad++"
            ProductId = ""
            InstallPath = "C:\Packages\NotepadPlus\Npp.7.5.4.installer.x64.exe"
            Arguments = "/S"
        }
        
        "ConEmu" = @{
            Name="ConEmu"
            Version = ""
            FullName = "Con Emu"
            ProductId = ""
            Path = "C:\Packages\ConEmu\ConEmuSetup.180206.exe"
            InstallArguments = "/p:x64 /quiet /norestart"
        }

        "VWMWareTools" = @{
            Name="VMWareTools"
            Version = ""
            FullName = "VMWare Tools"
            ProductId = "150A78E4-A6BA-4FA5-BE15-D2C4AB5E0AAA"
            ProductId2 = "507F5BFC-6DFE-43CF-A552-DABE868FCDFE"
            Path = "C:\Packages\VMWareTools\Setup.exe"
            InstallArguments = "/S /v `"/qn REBOOT=R`""
        }

        "SQLServerExpress" = @{
            Name = "SQLExpress"
            Version = ""
            ProductId = ""
            Path = ""
            InstallArguments = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=SQLEXPRESS /INSTANCENAME=SQLEXPRESS /UPDATEENABLED=FALS"
            MsiArguments = ""
        }

    }

    AllNodes = @(
        @{
            NodeName = "W2016X"
            ProductList = @("VWMWareTools")
        }
    )
}

InstallApps1 -ConfigurationData $ConfigData

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("Administrator", $PwSec)

# no effect for "a configuration is pending error"
# Remove-DscConfigurationDocument -Stage Pending, Current

# Start-DSCCOnfiguration -Path .\InstallApps1 -Credential $PSCred -Verbose -Wait -Force