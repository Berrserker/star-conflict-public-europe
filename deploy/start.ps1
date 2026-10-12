# Starts MongoDB and the server Hub (which spawns all other services), without windows.
param(
    [string]$ServerDir = "C:\SC\server",
    [string]$DbDir     = "C:\SC\db"
)
$cloud = "$ServerDir\cloud"
if (Get-Process Hub -ErrorAction SilentlyContinue) { Write-Host "Server is already running."; exit }

if (-not (Get-Process mongod -ErrorAction SilentlyContinue)) {
    Start-Process -FilePath "$cloud\mongodb\mongod.exe" -ArgumentList '-f', 'config.cfg', '--dbpath', "`"$DbDir`"" -WorkingDirectory "$cloud\mongodb" -WindowStyle Hidden
}
$up = $false
for ($i = 0; $i -lt 60; $i++) {
    try { $t = New-Object Net.Sockets.TcpClient; $t.Connect("127.0.0.1", 27017); $t.Close(); $up = $true; break } catch { Start-Sleep -Milliseconds 500 }
}
if (-not $up) { throw "MongoDB did not start (port 27017)." }

Start-Process -FilePath "$cloud\Hub.exe" -WorkingDirectory $cloud -WindowStyle Hidden
Write-Host "Starting services..."
Start-Sleep 25
$n = (Get-Process | Where-Object { $_.Path -like "$cloud\*" }).Count
Write-Host "Server processes running: $n (expected about 19)"
