<#
 .Synopsis
 Test fuer die xPsProfile-Resource
#>

configuration PsProfileTest
{
    param([String[]]$Computername)

    Import-DSCResource -ModuleName PSDesiredStateConfiguration
    Import-DscResource -ModuleName ProfileResource

    node $Computername
    {
        xPSProfile TestProfile
        {
            Ensure = "Present"
            Username  = "Administrator"
            ProfileType = "CurrentUserCurrentHost"
            Hostname = "PemoHost"
        }

        Log LogPsProfile
        {
            Message = "Eine xPSProfile Resource wurde angewendet."
        }
    }
}

PsProfileTest -Computername Server12A, Server12B

# Enable-DscDebug -BreakAll

# Start-DscConfiguration -Path .\PsProfileTest -Wait -Verbose -Force