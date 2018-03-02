$revisionPropertyName = "buildRevision"

$uriRoot = $env:SYSTEM_TEAMFOUNDATIONSERVERURI
$projectName = $env:SYSTEM_TEAMPROJECT
$buildDefName = $env:BUILD_DEFINITIONNAME

$apiVersionString = "api-version=4.1-preview"
$buildDefsUri = "$uriRoot$projectName/_apis/build/definitions?$apiVersionString"
$header = @{Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"}

$buildDefs = Invoke-RestMethod -Uri $buildDefsUri -Method Get -ContentType "application/json" -Headers $header -Verbose -Debug
 
$buildDef = $buildDefs.value | Where-Object { $_.name -eq $buildDefName }

if ($buildDef -eq $null)
{
    Write-Error "Unable to find a build definition for '$buildDefName'. Check the config values and try again." -ErrorAction Stop
}

$buildDefObj = Invoke-RestMethod -Uri ($buildDef.Url + "?" + $apiVersionString) -Method Get -ContentType "application/json" -Headers $header -Verbose -Debug

if ($buildDefObj.variables.$revisionPropertyName -eq $null)
{
    Write-Error "Unable to find a variable called '$revisionPropertyName' in Build Definition '$buildDefName'. Please check the config and try again." -ErrorAction Stop
}

[int]$counter = [convert]::ToInt32($buildDefObj.variables.$revisionPropertyName.Value, 10)
$updatedCounter = $counter + 1
Write-Host "Revision number for '$buildDefName' is $counter. Will be updating to $updatedCounter"

$buildDefObj.variables.$revisionPropertyName.Value = $updatedCounter.ToString()
$buildDefJson = $buildDefObj | ConvertTo-Json -Depth 100

Invoke-RestMethod -Uri ($buildDefObj.Url + "&" + $apiVersionString) -Method Put -ContentType "application/json" -Headers $header -Body $buildDefJson -Verbose -Debug
