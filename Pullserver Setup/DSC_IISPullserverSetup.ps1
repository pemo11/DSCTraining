<#
 .Synopsis
 Pull-Server per DSC konfigurieren
#>

configuration SetupDSCPullserver
{
    param(
        [Parameter(Mandatory=$true)]
        [String]$CertThumbPrint,
        [ValidateNotNullOrEmpty()]
        [String]$RegistrationKey
    )

    Import-DSCResource -ModuleName xPSDesiredStateConfiguration
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node Localhost
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name = "DSC-Service"
        }

        xDSCWebService PSDSCPullServer
        {
            Ensure = "Present"
            EndpointName = "PSDSCPullServer"
            Port = 8088
            PhysicalPath = "$env:SystemDrive\inetpub\PSDSCPullServer"
            CertificateThumbPrint = $CertThumbPrint
            # CertificateThumbPrint = "AllowUnencryptedTraffic"
            ModulePath = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            State = "Started"
            DependsOn = "[WindowsFeature]DSCServiceFeature"
           # AcceptSelfSignedCertificates = $true
            UseSecurityBestPractices = $true
            DisableSecurityBestPractices = "SecureTLSProtocols"
        }

        File RegistryKeyFile
        {
            Ensure = "Present"
            Type = "File"
            DestinationPath = "$env:ProgramFiles\WindowsPowerShell\DscService\Registrationkeys.txt"
            Contents = $RegistrationKey
        }

    }

}

$CertThumb = "BF649E77F2BAA8D1145DEEADB7C615D7F61A5A61"

$RegistrationKey = "a017fb5b-1808-48f3-acc4-17e6a72138c1"

SetupDSCPullserver -CertThumbPrint $CertThumb -RegistrationKey $RegistrationKey

cd E:\PoshSkripte\DSC_PullServer

Start-DscConfiguration -Path .\SetupDSCPullserver -Wait -Verbose -Force