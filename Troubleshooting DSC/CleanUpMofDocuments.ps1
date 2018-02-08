<#
 .Synopsis
 Cleans up staging mof files
#>

# List pending mof files

$OldVerbosePreference = $VerbosePreference
$VerbosePreference = "Continue"

dir C:\Windows\System32\Configuration\*.mof -OutVariable MofFiles

Write-Verbose "Number of Mof-Files before: $(@($MofFiles.Count))"

Remove-DscConfigurationDocument -Stage Previous,Current,Pending -Force

dir C:\Windows\System32\Configuration\*.mof -OutVariable MofFiles

Write-Verbose "Number of Mof-Files after: $(@($MofFiles.Count))"

$VerbosePreference = $OldVerbosePreference

