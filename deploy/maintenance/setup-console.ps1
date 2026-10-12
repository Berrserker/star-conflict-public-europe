# One-time setup of the Hub remote console used by restart.ps1 (run as Administrator).
# Creates a random password and an RSA host key next to the server (never in git),
# enables Hub's built-in SSH console on 127.0.0.1-only use, and blocks the port in the firewall.
param(
    [string]$ServerDir = "C:\SC\server",
    [int]$Port = 2224
)
$ErrorActionPreference = "Stop"
$cloud = "$ServerDir\cloud"
$cfg   = "$cloud\data\hub_local.cfg"
$key   = "$cloud\hub_ssh_key"
$pw    = "$cloud\hub_console.pw"

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    throw "Node.js not found. Install it first: winget install OpenJS.NodeJS.LTS  (then open a new PowerShell)"
}
if (Test-Path $cfg) { throw "$cfg already exists - check it by hand instead of overwriting." }

# Dependencies for hubcmd.js (node_modules is git-ignored)
Push-Location $PSScriptRoot; npm install --no-audit --no-fund | Out-Null; Pop-Location

# RSA host key in PEM format (the Hub's SSH server only understands that)
if (-not (Test-Path $key)) {
    & "$env:SystemRoot\System32\OpenSSH\ssh-keygen.exe" -q -t rsa -b 2048 -m PEM -N '""' -f $key
}

# Random console password, stored only on this machine
$bytes = New-Object byte[] 18; [Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)
$password = [Convert]::ToBase64String($bytes) -replace '[+/=]', 'x'
Set-Content -Path $pw -Value $password -NoNewline -Encoding ASCII

# hub.cfg ends with "exec hub_local.cfg", so Hub picks this up on its next start
@(
    "// Hub remote console for maintenance commands (created by deploy\maintenance\setup-console.ps1, not in git)",
    "set ssh_port $Port",
    "set ssh_passwd `"$password`"",
    "set ssh_privateKeyFile `"hub_ssh_key`"",
    "set ssh_publicKeyFile `"hub_ssh_key.pub`""
) | Set-Content -Path $cfg -Encoding ASCII

# Hub listens on 0.0.0.0 and Windows may have a program-wide allow rule for hub.exe; block wins over allow.
Get-NetFirewallRule -DisplayName "SC block hub console" -ErrorAction SilentlyContinue | Remove-NetFirewallRule
New-NetFirewallRule -DisplayName "SC block hub console" -Direction Inbound -Protocol TCP -LocalPort $Port -Action Block | Out-Null

Write-Host "Done. Restart the server (stop.ps1 / start.ps1) to enable the console; the Hub log must show 'Sucessfuly started secure shell on port $Port'."
Write-Host "Test: node $PSScriptRoot\hubcmd.js $Port $pw /hub_status"
