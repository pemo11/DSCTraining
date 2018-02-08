<#
 .Synopsis
 Test-Skript für das PSResource-Module
#>

# Zuerst das Modul laden - cool!
using module "C:\Program Files\WindowsPowerShell\Modules\ProfileResource\1.0\ProfileResource.psm1"

describe "ProfileTest" {

    $PsProfile = [xPSProfileResource]::New()

    it "Creates Current User Current Host Profile" {
        $PsProfile.ProfileType = "CurrentUserCurrentHost"
        $PsProfile.Username = "Administrator.PMServer"
        $PsProfile.Hostname = "PemoHost"
        $PsProfile.Ensure = "Present"
        $PsProfile.Set()

        test-Path  "C:\Users\Administrator.PMServer\Documents\WindowsPowerShell\PemoHost_Profile.ps1"  | Should be $true

    }

    it "Removes Current User Current Host Profile" {
        $PsProfile.ProfileType = "CurrentUserCurrentHost"
        $PsProfile.Username = "Administrator.PMServer"
        $PsProfile.Hostname = "PemoHost"
        $PsProfile.Ensure = "Absent"
        $PsProfile.Set()

        test-Path  "C:\Users\Administrator.PMServer\Documents\WindowsPowerShell\PemoHost_Profile.ps1"  | Should be $false

    }

    it "Creates Backup  Current User Current Host Profile" {
        $PsProfile.ProfileType = "CurrentUserCurrentHost"
        $PsProfile.Username = "Administrator.PMServer"
        $PsProfile.Hostname = "PemoHost"
        $PsProfile.Ensure = "Present"

        $PsProfile.Set()

        $PsProfile.Set()

        test-Path  "C:\Users\Administrator.PMServer\Documents\WindowsPowerShell\PemoHost_Profile_Backup.ps1"  | Should be $true

    }

}