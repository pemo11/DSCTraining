<#
 .Synopsis
 Report von einem DSC-Pullserver abrufen
#>

Set-StrictMode -Version 2.0

function Get-Report
{
    param(
        [String]$AgentId, 
        [String]$ServiceURI
    )
    $Request = Invoke-WebRequest -Uri $ServiceURI -ContentType "application/json;odata=minimalmetadata;streaming=$true;charset=utf-8" `
     -UseBasicParsing -Headers @{Accept = "application/json";ProtocolVersion="2.0"} `
     -ErrorAction Ignore -ErrorVariable Ev

    $Content = ConvertFrom-Json $Request.Content
    $Content.Value
}

# Geht aktuell noch nicht
$AgentId = (Get-DscLocalConfigurationManager).AgentId
# Soll HTTP-Anfrage sein
$Uri = "http://pmserver:8080/PSDSCPullServer.svc"

Get-Report  -AgentId $AgentId -ServiceURI $URI