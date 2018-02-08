<#
 .Synopsis
 Kills DSC related processes
 .Notes
 No guarantee that this reset DSC
#>

$SB = {
    $DSCProcessID = Get-CimInstance -ClassName MSFT_Providers | 
        Where-Object Provider -eq "dsccore" | 
            Select-Object -ExpandProperty HostProcessIdentifier 

    Get-Process -ID $DSCProcessID | Stop-Process -Force -PassThru
}

$Hostname = "Localhost"
Invoke-Command -ComputerName $Hostname -ScriptBlock $SB
