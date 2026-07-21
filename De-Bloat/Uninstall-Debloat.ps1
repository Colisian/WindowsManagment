<#
.SYNOPSIS
    Intune Win32 uninstall script for the De-Bloat deployment.
.DESCRIPTION
    Debloating cannot be reversed - removed AppX packages and OEM software are not
    reinstalled here. This script only clears the completion tag so that Intune
    reports the app as removed (and so detection returns "not installed"). It always
    exits 0.
#>

$tagPath = "HKLM:\SOFTWARE\Debloat"

if (Test-Path $tagPath) {
    Remove-Item -Path $tagPath -Recurse -Force -ErrorAction SilentlyContinue
    Write-Output "Removed completion tag $tagPath"
} else {
    Write-Output "Completion tag $tagPath not present; nothing to remove"
}

exit 0
