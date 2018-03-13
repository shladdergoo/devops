$ErrorActionPreference = "Stop"

$versionProjectPath=$(versionProjectPath)
$versionElement=$(versionElement)
$buildRevision=$(buildRevision)

Write-Host "Reading project version"

[xml]$projXml=Get-Content -Path $versionProjectPath
$versionXml=$projXml.SelectSingleNode($versionElement)

if ($versionXml -eq $null) { 
    Write-Host "Could not find element at"$versionElement 
    Exit
}

$baseVersion=$versionXml.InnerText

Write-Host "Got version"$baseVersion

Write-Host "##vso[build.updatebuildnumber]$baseVersion.$buildRevision"
