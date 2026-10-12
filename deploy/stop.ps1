# Stops all server services, then shuts MongoDB down gracefully so no data is lost.
# Players are disconnected immediately; announce restarts in advance.
param([string]$ServerDir = "C:\SC\server")
$cloud = "$ServerDir\cloud"

Get-Process | Where-Object { $_.Path -like "$cloud\*" -and $_.ProcessName -ne 'mongod' } | Stop-Process -Force
Start-Sleep 3
& "$cloud\mongodb\mongo.exe" --quiet 127.0.0.1/admin --eval "db.shutdownServer()" 2>$null | Out-Null
for ($i = 0; $i -lt 30 -and (Get-Process mongod -ErrorAction SilentlyContinue); $i++) { Start-Sleep 1 }
if (Get-Process | Where-Object { $_.Path -like "$cloud\*" }) { Write-Warning "Some processes are still running." } else { Write-Host "Server stopped." }
