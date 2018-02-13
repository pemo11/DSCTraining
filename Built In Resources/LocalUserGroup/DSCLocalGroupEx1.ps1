<#
 .Synopsis
 Creating two local user accounts and add them to a newly created local group
 .Notes 
 The password is set with a PSCredential object and is stored as plain text in the mof file
#>

configuration UserGroupEx1
{
   Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        User User1
        {
            Ensure = "Present"
            UserName = $Node.Username1
            FullName = $Node.Fullname1
            PasswordNeverExpires = $true
            Password = $Node.Credential
        }

        User User2
        {
            Ensure = "Present"
            UserName = $Node.Username2
            FullName = $Node.Fullname2
            PasswordNeverExpires = $true
            Password = $Node.Credential
        }

        Group Group1
        {
            Ensure="Present"
            GroupName=$Node.GroupName1
            Members = $Node.Username1, $Node.Username2
            DependsOn = "[User]User2"
        }
    }
}


$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force
$PSCred = [PSCredential]::New("DummyUser", $PwSec)

$ConfigData = @{

    AllNodes = @(
	    @{
            NodeName = "localhost"
            Username1 = "PSUser1"
            Username2 = "PSUser2"
            FullName1 = "The first PSUser"
            FullName2 = "The second PSUser"
            GroupName1 = "PSUser"
            Credential = $PSCred
		    PSDscAllowPlainTextPassword=$true
        }
	)
}

UserGroupEx1 -ConfigurationData $ConfigData

Start-DscConfiguration -Path .\UserGroupEx1 -Verbose -Wait 