<#
 .Synopsis
 Just a helper for setting up the samples
#>

# Clean all directories with just mof files
Get-ChildItem -Path . -Directory -Recurse | ForEach-Object {
    # contains only mof files?
    $Groups = Get-ChildItem -Path $_.FullName -File -Recurse | Group-Object
    if ($Groups.Count -eq 0 -or ($Groups.Count -eq 1 -and $Groups.Name -like "*.mof"))
    {
        Remove-Item -Path $_.FullName -Recurse -Force -WhatIf
    }
}