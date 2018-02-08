<#
 .Synopsis
 Zertifikat für DSC anlegen
#>

$EKUDocumentEncrypt = "1.3.6.1.4.1.311.80.1"

cd $PSScriptRoot

. .\New-SelfSignedCertificateEx.ps1

New-SelfsignedCertificateEx `
    -Subject "CN=${env:ComputerName}" `
    -EKU $EKUDocumentEncrypt `
    -KeyUsage DataEncipherment, KeyEncipherment `
    -SAN ${env:ComputerName} `
    -FriendlyName "DSC-Zertifikat-Verschlüsselung" `
    -Exportable `
    -StoreLocation "LocalMachine"

<#
New-SelfsignedCertificateEx `
    -Subject "CN=${env:ComputerName}" `
    -EKU $EKUDocumentEncrypt `
    -KeyUsage DataEncipherment, KeyEncipherment `
    -SAN ${env:ComputerName} `
    -FriendlyName "DSC-Zertifikat-Verschlüsselung" `
    -Exportable `
    -StoreLocation "LocalMachine" `
    -KeyLength 2048 `
    -ProviderName "Microsoft Enhanced Cryptographic Provider v1.0" `
    -AlgorithmName "RSA" `
    -SignatureAlgorithm "SHA256"
#>
