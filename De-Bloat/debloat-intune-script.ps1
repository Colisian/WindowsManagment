$DebloatFolder = "C:\ProgramData\Debloat"
If (Test-Path $DebloatFolder) {
    Write-Output "$DebloatFolder exists. Skipping."
}
Else {
    Write-Output "The folder '$DebloatFolder' doesn't exist. This folder will be used for storing logs created after the script runs. Creating now."
    Start-Sleep 1
    New-Item -Path "$DebloatFolder" -ItemType Directory
    Write-Output "The folder $DebloatFolder was successfully created."
}

$templateFilePath = "C:\ProgramData\Debloat"

##Download RemoveBloat.ps1 from the Colisian fork so the custom whitelist fixes are used (not upstream)
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
$scriptUrl = "https://raw.githubusercontent.com/Colisian/WindowsManagment/main/De-Bloat/RemoveBloat.ps1"
$pathwithfile = "$templateFilePath\RemoveBloat.ps1"

Invoke-WebRequest -Uri $scriptUrl -OutFile $pathwithfile -UseBasicParsing

# Define apps to whitelist (comma-separated)
# DellInc.DellCommandUpdate is the AppX package name behind "Dell Command | Update for Windows Universal"
$whitelistApps = "Dell Command | Endpoint Configure for Microsoft Intune,Dell Command | Configure,Dell Command | Update for Windows Universal,DellInc.DellCommandUpdate,Dell Trusted Device"

# Define apps to bloat (comma-separated)
$bloatApps = ""

# Define scheduled tasks to remove (empty by default). Comma separated
$tasksToRemove = @() -join ','

$scriptArgs = @{
    customwhitelist = $whitelistApps
}
if ($bloatApps) {
    $scriptArgs.custombloatlist = $bloatApps
}
if ($tasksToRemove) {
    $scriptArgs.TasksToRemove = $tasksToRemove
}

# Execute the script with parameters (direct call - Invoke-Expression breaks on "|" in app names)
& $pathwithfile @scriptArgs
