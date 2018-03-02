Write-Host "Reading project version"

$baseVersion=([xml](Get-Content -Path $(versionProjectPath))).$(versionElement)

Write-Host "Got version"$baseVersion

Write-Host "##vso[build.updatebuildnumber]$baseVersion.$(buildRevision)"

