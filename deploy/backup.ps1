# Dumps the game databases while the server runs; keeps the newest $Keep backups.
param(
    [string]$ServerDir = "C:\SC\server",
    [string]$BackupDir = "C:\SC\backups",
    [int]$Keep = 14
)
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
& "$ServerDir\cloud\mongodb\mongodump.exe" --host 127.0.0.1 --out "$BackupDir\$stamp" 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Error "mongodump failed ($LASTEXITCODE)"; exit 1 }
Get-ChildItem $BackupDir -Directory | Sort-Object Name -Descending | Select-Object -Skip $Keep | Remove-Item -Recurse -Force
Write-Host "Backup saved: $BackupDir\$stamp"
