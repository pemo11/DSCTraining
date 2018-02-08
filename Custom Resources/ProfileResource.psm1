<#
 .Synopsis
 DSC-Ressource für das Anlegen eines Profilskriptes
#>

enum ProfileType
{
    CurrentUserAllHosts
    CurrentUserCurrentHost
    AllUsersAllHosts
    AllUsersCurrentHost
}

enum Ensure
{
    Absent
    Present
}

[DSCResource()]
class xPSProfileResource
{
    [DSCProperty(Key)]
    [ProfileType]$ProfileType

    [DSCProperty(Mandatory)]
    [String]$Username

    [DSCProperty()]
    [String]$Hostname

    [DSCProperty()]
    [String]$ErrorBackgroundColor

    [DSCProperty()]
    [Ensure]$Ensure
    
    [bool]Test()
    {
        $Result = $false
        switch($this.ProfileType)
        {
            "CurrentUserAllHosts" {
                $ProfilePath = "$env:systemdrive\users\$($this.Username)\documents\windowspowershell\profile.ps1"
                $Result = (Test-Path -Path $ProfilePath ) -And ($this.Ensure -eq "Present")
            }
            "CurrentUserCurrentHost" {
                $ProfilePath = "$env:systemdrive\users\$($this.Username)\documents\windowspowershell\$($this.Hostname)_profile.ps1"
                $Result = (Test-Path -Path $ProfilePath ) -And ($this.Ensure -eq "Present")
            }
            "AllUsersAllHosts" {
                $ProfilePath = "$env:systemdrive\Windows\System32\WindowsPowerShell\v1.0\profile.ps1"
                $Result = (Test-Path -Path $ProfilePath ) -And ($this.Ensure -eq "Present")
            }
            "AllUsersCurrentHost" {
                $ProfilePath = "$env:systemdrive\Windows\System32\WindowsPowerShell\v1.0\$($this.Hostname)_.profileps1"
                $Result = (Test-Path -Path $ProfilePath ) -And ($this.Ensure -eq "Present")
            }
        }
        return $Result
    }

    [void]Set()
    {
        switch($this.ProfileType)
        {
            "CurrentUserAllHosts" {
                $ProfilePath = "$env:systemdrive\users\$($this.Username)\documents\windowspowershell\profile.ps1"
                if ($this.Ensure -eq "Present")
                {
                    if (Test-Path -Path $ProfilePath)
                    {
                        $ProfileBackupPath = "$([System.IO.Path]::GetFileNameWithoutExtension($ProfilePath))_Backup.ps1"
                        Copy-Item -Path $ProfilePath -Destination $ProfileBackupPath -Force 
                        Write-Verbose "$ProfilePath wird nach $ProfileBackupPath kopiert."
                    }
                    if (!(Test-Path -Path (Split-Path $ProfilePath)))
                    {
                        md -Path (Split-Path $ProfilePath) -Force
                    }
                    Set-Content -Path $ProfilePath -Value "# Per DSC angelegt"
                    if ($this.ErrorBackgroundColor -ne "")
                    {
                        Add-Content -Path $ProfilePath -Value ('$Host.PrivateData.ErrorBackgroundColor = "' + $this.ErrorBackgroundColor + '"')
                    }
                    Write-Verbose "$ProfilePath wurde angelegt."
                }
                else
                {
                    rm -Path $ProfilePath -Force -Recurse
                    Write-Verbose "$ProfilePath wurde entfernt."
                }
             }

            "CurrentUserCurrentHost" {
                $ProfilePath = "c:\users\$($this.Username)\documents\windowspowershell\$($this.Hostname)_profile.ps1"
                if ($this.Ensure -eq "Present")
                {
                    if (Test-Path -Path $ProfilePath)
                    {
                        $ProfileBackupPath = Join-Path -Path (Split-Path -Path $ProfilePath) -ChildPath "$([System.IO.Path]::GetFileNameWithoutExtension($ProfilePath))_Backup.ps1"
                        Copy-Item -Path $ProfilePath -Destination $ProfileBackupPath -Force 
                        Write-Verbose "$ProfilePath wird nach $ProfileBackupPath kopiert."
                    }
                    if (!(Test-Path -Path (Split-Path $ProfilePath)))
                    {
                        md -Path (Split-Path $ProfilePath) -Force
                    }
                    Set-Content -Path $ProfilePath -Value "# Per DSC angelegt"
                    if ($this.ErrorBackgroundColor -ne "")
                    {
                        Add-Content -Path $ProfilePath -Value ('$Host.PrivateData.ErrorBackgroundColor = "' + $this.ErrorBackgroundColor + '"')
                    }
                    Write-Verbose "$ProfilePath wurde angelegt."
                }
                else
                {
                    rm -Path $ProfilePath -Force
                    Write-Verbose "$ProfilePath wurde entfernt."
                }
            }

            "AllUsersAllHosts" {
                $ProfilePath = "$env:systemdrive\Windows\System32\WindowsPowerShell\v1.0\profile.ps1"
                if ($this.Ensure -eq "Present") {
                    if (Test-Path -Path $ProfilePath)
                    {
                        $ProfileBackupPath = "$([System.IO.Path]::GetFileNameWithoutExtension($ProfilePath))_Backup.ps1"
                        Copy-Item -Path $ProfilePath -Destination $ProfileBackupPath -Force 
                        Write-Verbose "$ProfilePath wird nach $ProfileBackupPath kopiert."
                    }
                    if (!(Test-Path -Path (Split-Path $ProfilePath)))
                    {
                        md -Path (Split-Path $ProfilePath) -Force
                    }
                    Set-Content -Path $ProfilePath -Value "# Per DSC angelegt"
                    if ($this.ErrorBackgroundColor -ne "")
                    {
                        Add-Content -Path $ProfilePath -Value ('$Host.PrivateData.ErrorBackgroundColor = "' + $this.ErrorBackgroundColor + '"')
                    }
                    Write-Verbose "$ProfilePath wurde angelegt."
                } 
                else
                {
                    rm -Path $ProfilePath -Force -Recurse
                    Write-Verbose "$ProfilePath wurde entfernt."
                }
            }

            "AllUsersCurrentHost" {
                $ProfilePath = "$env:systemdrive\Windows\System32\WindowsPowerShell\v1.0\$($this.Hostname)_profile.ps1"
                if ($this.Ensure -eq "Present") {
                    if (Test-Path -Path $ProfilePath)
                    {
                        $ProfileBackupPath = "$([System.IO.Path]::GetFileNameWithoutExtension($ProfilePath))_Backup.ps1"
                        Copy-Item -Path $ProfilePath -Destination $ProfileBackupPath -Force 
                        Write-Verbose "$ProfilePath wird nach $ProfileBackupPath kopiert."
                    }
                    if (!(Test-Path -Path (Split-Path $ProfilePath)))
                    {
                        md -Path (Split-Path $ProfilePath) -Force
                    }
                    Set-Content -Path $ProfilePath -Value "# Per DSC angelegt"
                    if ($this.ErrorBackgroundColor -ne "")
                    {
                        Add-Content -Path $ProfilePath -Value ('$Host.PrivateData.ErrorBackgroundColor = "' + $this.ErrorBackgroundColor + '"')
                    }
                    Write-Verbose "$ProfilePath wurde angelegt."
                }
                else
                {
                    rm -Path $ProfilePath -Force -Recurse                    
                    Write-Verbose "$ProfilePath wurde entfernt."
                }
            }
        }
    }

    [xPSProfileResource]Get()
    {
        if ($this.Ensure -eq "Present")  {
            switch($this.ProfileType)
            {
                "CurrentUserAllHosts" {  }
                "CurrentUserCurrentHost" {  }
                "AllUsersAllHosts" { }
                "AllUsersAllHosts" { }
            }
        } 
        return $this
    }

}