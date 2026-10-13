# Registers on-shutdown.ps1 as a machine shutdown script in the local Group Policy, so any orderly
# Windows shutdown/reboot (Windows Update, hosting panel via ACPI, Start menu) stops the server and
# MongoDB gracefully first. Run once as Administrator. Overwrites the local GPO scripts.ini/gpt.ini,
# so check that no other local policy scripts exist before running it.
$gp      = "$env:windir\System32\GroupPolicy"
$scripts = "$gp\Machine\Scripts"
$target  = "$PSScriptRoot\on-shutdown.ps1"
New-Item -ItemType Directory -Force "$scripts\Shutdown", "$scripts\Startup" | Out-Null

@"
[Shutdown]
0CmdLine=powershell.exe
0Parameters=-NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$target"
"@ | Set-Content "$scripts\scripts.ini" -Encoding Unicode

# Script extension GUIDs; Version must grow so gpupdate picks the change up.
$ver = 1
if (Test-Path "$gp\gpt.ini") { if ((Get-Content "$gp\gpt.ini" -Raw) -match 'Version=(\d+)') { $ver = [int]$matches[1] + 1 } }
@"
[General]
gPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]
Version=$ver
"@ | Set-Content "$gp\gpt.ini" -Encoding ASCII

gpupdate /target:computer /force | Out-Null
$reg = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Shutdown\0\0'
$k = Get-Item $reg -ErrorAction SilentlyContinue   # Get-ItemProperty fails on the binary ExecTime value
if ($k) { Write-Host "Shutdown script registered: $($k.GetValue('Script')) $($k.GetValue('Parameters'))" }
else { Write-Warning "Not registered; check gpedit.msc > Computer Configuration > Windows Settings > Scripts > Shutdown" }
