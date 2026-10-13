# Runs as a Windows shutdown script (local Group Policy, as SYSTEM) on every orderly shutdown or reboot,
# including one started by the hosting panel through ACPI. Stops the server and shuts MongoDB down
# gracefully. Players get no countdown here; for planned restarts use restart.ps1.
# A hard power-off/reset skips this; mongod then recovers from its journal.
$log = "C:\SC\server\shutdown.log"
"$(Get-Date -Format s) shutdown: stopping server" | Add-Content $log
try {
    & "$PSScriptRoot\..\stop.ps1" *>&1 | ForEach-Object { "$(Get-Date -Format s)   $_" } | Add-Content $log
} catch {
    "$(Get-Date -Format s) error: $($_.Exception.Message)" | Add-Content $log
}
"$(Get-Date -Format s) shutdown: done, mongod running: $([bool](Get-Process mongod -ErrorAction SilentlyContinue))" | Add-Content $log
