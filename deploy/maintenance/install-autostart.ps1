# Autostart after boot (run once as Administrator):
#   "SC server autostart" - deploy\start.ps1 one minute after boot
#   "SC stats autostart"  - deploy\stats\stats.ps1 (localhost:8088) two minutes after boot
# Both tasks run as the CURRENT user with LogonType S4U, so no RDP session or stored password is needed.
# They must NOT run as SYSTEM: the server names its database after the Windows user (cosmosim_<user>) and
# writes logs to that user's %LOCALAPPDATA%; as SYSTEM it would start with an empty cosmosim_SYSTEM database.
param([string]$Deploy = (Split-Path $PSScriptRoot -Parent))
$ErrorActionPreference = "Stop"
$user = "$env:USERDOMAIN\$env:USERNAME"
$principal = New-ScheduledTaskPrincipal -UserId $user -LogonType S4U -RunLevel Highest
$settings  = New-ScheduledTaskSettingsSet -ExecutionTimeLimit ([TimeSpan]::Zero) -MultipleInstances IgnoreNew -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

$log = "C:\SC\server\autostart.log"   # last autostart output (git-ignored, under server\)
$startCmd = "& '$Deploy\start.ps1' *> '$log'"
$a1 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -NonInteractive -ExecutionPolicy Bypass -Command `"$startCmd`""
$t1 = New-ScheduledTaskTrigger -AtStartup; $t1.Delay = "PT1M"
Register-ScheduledTask -TaskName "SC server autostart" -Action $a1 -Trigger $t1 -Principal $principal -Settings $settings -Force | Out-Null

$a2 = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$Deploy\stats\stats.ps1`""
$t2 = New-ScheduledTaskTrigger -AtStartup; $t2.Delay = "PT2M"
Register-ScheduledTask -TaskName "SC stats autostart" -Action $a2 -Trigger $t2 -Principal $principal -Settings $settings -Force | Out-Null

Write-Host "Registered 'SC server autostart' (+1 min) and 'SC stats autostart' (+2 min) as $user (S4U)."
Write-Host "Shutdown is NOT handled: before a planned reboot run deploy\maintenance\restart.ps1 -Minutes N -NoStart."
