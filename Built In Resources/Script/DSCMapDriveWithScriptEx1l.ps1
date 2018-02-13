<#
 .Synopsis
 Map a smb share with a drive letter with the help of the script resources
 .Description
 It was a lot of nitty gritty details to consider for being able to finaly use the Drivename property
 in combination with the node variable
 It works with scriptblocks and using local variables in conjunction with node:
 Its not possible to use $node:property within set, test or get
 the script resource is not very good
#>

configuration MapDriveWithScriptEx1
{
    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    node $AllNodes.NodeName
    {

        $Cred = $Node.Credential
        $Username = $Cred.Username
        $Password = $Cred.GetNetworkCredential().Password
        $DriveName = $Node.DriveName
        $RemotePath = $Node.RemotePath

        Script MapShare1
        {
            # if return value is $false set action will be taken
            TestScript = {
                (Get-PSDrive -Name $using:DriveName -ErrorAction Ignore)  -ne $null
            }
            
            # returns a hashtable with result=$true
            GetScript = {
                Result = (Get-PSDrive -Name $using:DriveName -ErrorAction Ignore) -eq `$null
            }

            # A Scriptblock with parameters
            SetScript = {
                New-SmbMapping -LocalPath $using:DriveName -RemotePath $using:RemotePath -Username $using:Username -Password $using:Password
            }
        }
    }
}

$PwSec = "demo+123" | ConvertTo-SecureString -AsPlainText -Force    
$PSCred = [PSCredential]::New("Administrator", $PwSec)

$ConfigData = @{

    AllNodes = @(

        @{
            NodeName = "W2016A"
            DriveName = "P:"
            RemotePath = "\\W2016B\Docs"
            Credential = $PSCred
            PSDscAllowPlainTextPassword = $true
        }
    )
}

cd $PSScriptRoot

MapDriveWithScriptEx1 -ConfigurationData $ConfigData 

# Start-DSCConfiguration -Path .\MapDriveWithScriptEx1 -Wait -Verbose -Credential $PSCred -Force 