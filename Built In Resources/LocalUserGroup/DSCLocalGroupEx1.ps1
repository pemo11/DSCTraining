
configuration UserGroupAnlegen
{
    param([String[]]$Computername, [PSCredential]$UserPwCred)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $Computername
    {
        User User1
        {
            Ensure = "Absent"
            UserName = "PsUser1"
            FullName = "Peter Monadjemi 1"
            PasswordNeverExpires = $true
            Password = $UserPwCred
        }

        User User2
        {
            Ensure = "Present"
            UserName = "PsUser2"
            FullName = "Peter Monadjemi 2"
            PasswordNeverExpires = $true
            Password = $UserPwCred
        }

        Group Group1
        {
            Ensure="Absent"
            GroupName="PsUser"
            Members = "PemoUser1", "PemoUser2"
            DependsOn = "[User]User2"
        }
    }
}


$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$UserPwCred = [PSCredential]::New("Dummy", $PwSec)

del DSCTest -Force -recurse -ErrorAction Ignore

$ConfigData = @{

    AllNodes = @(
	    @{
            # NodeName darf kein * sein
            NodeName = "Win7B"
		    PSDscAllowPlainTextPassword=$true
        }
	)
}

DSCTest -Computername Win7B -UserPwCred $UserPwCred -ConfigurationData $ConfigData

$Username = "Pemo7"
$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$Cred = [PSCredential]::new($Username, $PwSec)


Start-DscConfiguration -Path .\DSCTest -Verbose -Wait -Credential $Cred