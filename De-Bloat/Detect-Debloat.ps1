<#
.SYNOPSIS
    Intune Win32 custom detection script for the De-Bloat deployment.
.DESCRIPTION
    Reports the app as installed only when RemoveBloat.ps1 has completed a run
    matching the expected version tag it writes to HKLM:\SOFTWARE\Debloat.

    Intune detection contract for a custom script:
      - exit 0 WITH stdout  = detected (installed)  -> no re-run
      - exit 0 WITHOUT stdout = NOT detected         -> triggers (re)install
    So keep $expectedVersion in sync with $debloatVersion at the end of RemoveBloat.ps1.
    Bumping the version there makes this return "not detected" and forces a re-run.
#>

$expectedVersion = "2026.07.20"
$tagPath         = "HKLM:\SOFTWARE\Debloat"

$actualVersion = (Get-ItemProperty -Path $tagPath -Name "Version" -ErrorAction SilentlyContinue).Version

if ($actualVersion -eq $expectedVersion) {
    Write-Output "Debloat $expectedVersion detected"
    exit 0
}

# Not found / wrong version: emit nothing and exit 0 so Intune treats it as not installed.
exit 0
