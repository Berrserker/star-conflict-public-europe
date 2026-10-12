# Restart the server with an in-game countdown for players.
#   restart.ps1 -Minutes 10           announce, wait, disconnect players, stop and start the server
#   restart.ps1 -Minutes 10 -NoStart  same, but leave the server stopped (e.g. before a VPS reboot)
#   restart.ps1 -Cancel               cancel a running countdown / leave maintenance mode
# Players see the built-in SN_MAINTENANCE_COUNTDOWN notification; Hub repeats it every minute and
# disconnects everyone when it reaches zero ("Disconnecting all clients due to maintenance mode").
param(
    [int]$Minutes = 10,
    [switch]$NoStart,
    [switch]$Cancel,
    [string]$ServerDir = "C:\SC\server",
    [int]$Port = 2224
)
$ErrorActionPreference = "Stop"
$deploy = Split-Path $PSScriptRoot -Parent
$pw     = "$ServerDir\cloud\hub_console.pw"
if (-not (Test-Path $pw)) { throw "Console not set up: run deploy\maintenance\setup-console.ps1 first." }

function Send-Hub([string]$cmd) {
    node "$PSScriptRoot\hubcmd.js" $Port $pw $cmd
    if ($LASTEXITCODE -ne 0) { throw "Hub console command failed: $cmd" }
}

if ($Cancel) { Send-Hub "/leaveMaintenanceMode"; Write-Host "Maintenance cancelled."; exit }
if ($Minutes -lt 1) { throw "-Minutes must be at least 1" }

Write-Host "Announcing restart in $Minutes minute(s)..."
Send-Hub "/enterMaintenanceMode $Minutes"

$until = (Get-Date).AddMinutes($Minutes).AddSeconds(20)
while ((Get-Date) -lt $until) {
    $left = [int]($until - (Get-Date)).TotalSeconds
    Write-Host ("  waiting, {0}s left (Ctrl+C here does NOT cancel - use -Cancel)" -f $left)
    Start-Sleep ([Math]::Min(60, [Math]::Max(1, $left)))
}

& "$deploy\backup.ps1" -ServerDir $ServerDir
& "$deploy\stop.ps1"   -ServerDir $ServerDir
if (-not $NoStart) { & "$deploy\start.ps1" -ServerDir $ServerDir }
