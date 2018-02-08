# Soll detaillierte Fehler bei ungültigem Zertifikat ausgeben - klappt aber nicht

# Gute Beschreibung: https://newyear2006.wordpress.com/2014/07/26/bei-powershell-ssltls-zertifikate-prfung-einfach-ignorieren/

<#

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
#>

# $RemoteHost = "https://PMServer:8088/PSDSCPullServer.svc"
$RemoteHost = "PMServer"

$Port = "8088"

$Client = New-Object -TypeName System.Net.Sockets.TcpClient  #-ArgumentList $RemoteHost, $Port
$Client.Connect($RemoteHost, $Port)

$Stream = $Client.GetStream()
# [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

$SSlStream = New-Object -TypeName System.Net.Security.SslStream -ArgumentList $Stream, $false, {
                   Write-Host "Sender: $($Args[0])";
                   Write-Host "Certificate: $(($Args[1]).GetType())";
                   Write-Host  "CertificateChain: $($Args[2])";
                   Write-Host  "PolicyErrors: $($Args[3])"; 
         }
$Result = $SSlStream.AuthenticateAsClient($RemoteHost)
$Client.Close()