<#
 .Synopsis
 Domain Controller einrichten per DSC
 .Notes
 Letzte Änderung: 20/7/2017
#>

$ConfigData = @{

    AllNodes = @(
        @{
            Nodename = "ServerDC"
            NodeRole = "DC"
            DomainName = "pmtrain.local"
        }
        @{
            Nodename = "*"
            NTDSPath = "C:\NTFS"
            RetryCount = 3
            RetryIntervalSec = 30
            PSDscAllowPlainTextPassword = $true
        }
    )
}

configuration DCSetup
{
    param             
    (             
        [Parameter(Mandatory)]
        [PSCredential]$SafemodeAdministratorCred,             
        [Parameter(Mandatory)]            
        [PSCredential]$DomainCred,
        [Parameter(Mandatory)]            
        [PSCredential]$ADUserCred
    ) 

    Import-DscResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource -ModuleName xPendingReboot

    node $AllNodes.Where{$_.NodeRole -eq "DC"}.Nodename
    {
        LocalConfigurationManager            
        {            
            ActionAfterReboot = "ContinueConfiguration"            
            ConfigurationMode = "ApplyOnly"            
            RebootNodeIfNeeded = $true            
        }          

        # Noch nicht getestet
        xPendingReboot PendingReboot
        {
            # $Nodename ist eine DSC-Variable
            Name = $Nodename
        }

        File ADDir
        {
            Ensure = "Present"
            Type =  "Directory"
            DestinationPath = $Node.NTDSPath
        }

        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }

        WindowsFeature ADDSTools
        {
            Ensure = "Present"
            Name = "RSAT-ADDS"
        }

     
        xADDomain FirstDom
        {
            DomainName = $Node.DomainName
            DomainAdministratorCredential  = $DomainCred
            SafemodeAdministratorPassword  = $SafemodeAdministratorCred
            DatabasePath = $Node.NTDSPath
            LogPath = $Node.NTDSPath
            DependsOn = "[WindowsFeature]ADDSInstall", "[File]ADDir"
        }

        xWaitForADDomain DomainWait 
        { 
            DomainName = $Node.DomainName 
            DomainUserCredential = $DomainCred 
            RetryCount = $Node.RetryCount 
            RetryIntervalSec = $Node.RetryIntervalSec 
            DependsOn = "[xADDomain]FirstDom" 
        }

        xADUser AdUser
        { 
            Ensure = "Present" 
            DomainName = $Node.DomainName 
            DomainAdministratorCredential = $DomainCred 
            UserName = "PsUser"
            Password = $ADUserCred 
            DependsOn = "[xWaitForADDomain]DomainWait" 
        } 

    }
}

$Username = "Administrator"
$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Cred = [PSCredential]::new($Username, $PwSec)

DCSetup -ConfigurationData $ConfigData -SafeModeAdministratorCred $Cred -DomainCred $Cred -ADUserCred $Cred

# Start-DSCConfiguration -Path .\DCSetup -Verbose -Wait -Credential $Cred -Force
