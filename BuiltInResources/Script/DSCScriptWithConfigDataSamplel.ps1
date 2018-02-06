<#
 .Synopsis
 Ein einfaches Beispiel für das Verwenden von Konfigurationsdaten bei der Script-Ressource
#>

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName = "localhost"
            Property = "1234"
            Url = "http://www.activetraining.de"
        }
    )
}

$PropVal = "5678"

configuration Test
{

    Import-DSCResource -ModuleName PSDesiredStateConfiguration

    Node $AllNodes.NodeName
    {
        Script Script1
        {
            GetScript = { return @{Result = $true } }

            SetScript = {
                $Url = $using:Node.Url
                $PropValue = $using:Node.Property
                Write-Verbose "*** Url: $($using:Node.Url)"
                Write-Verbose "*** Set: Property-Wert: $PropValue"
            }

            TestScript = {
                Write-Verbose ("*** Test: Property-Wert: " + $using:Node.PropValue)
                $False
            }
        }
    }
}

Test -ConfigurationData $ConfigData

Start-DscConfiguration -Path Test -Verbose -Wait -Force