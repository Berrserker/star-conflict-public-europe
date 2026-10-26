# Вшивает загрузку ow_quest_transport_speed.lua в designersdefs.lua.
# Файл игры не перекодируется: строка вставляется байтами ASCII, остальные байты остаются как были.
# Повторный запуск ничего не меняет, если строка уже есть.
#
# Пример:
#   powershell -NoProfile -ExecutionPolicy Bypass -File .\deploy\patch-quest-transport.ps1 -GameDir "D:\SteamLibrary\steamapps\common\star conflict"
param(
    [Parameter(Mandatory = $true)][string]$GameDir
)
$ErrorActionPreference = "Stop"

function Find-Bytes([byte[]]$hay, [byte[]]$needle) {
    if ($needle.Length -eq 0 -or $hay.Length -lt $needle.Length) { return -1 }
    for ($i = 0; $i -le $hay.Length - $needle.Length; $i++) {
        $ok = $true
        for ($j = 0; $j -lt $needle.Length; $j++) {
            if ($hay[$i + $j] -ne $needle[$j]) { $ok = $false; break }
        }
        if ($ok) { return $i }
    }
    return -1
}

$destLua = Join-Path $GameDir "data\gamedata\def\ex\ow_quest_transport_speed.lua"
$srcLua = Join-Path $PSScriptRoot "files\data\gamedata\def\ex\ow_quest_transport_speed.lua"
if (-not (Test-Path $srcLua)) { throw "Missing $srcLua" }
$destDir = Split-Path $destLua -Parent
New-Item -ItemType Directory -Force -Path $destDir | Out-Null
[System.IO.File]::Copy($srcLua, $destLua, $true)

$path = Join-Path $GameDir "data\gamedata\def\designersdefs.lua"
if (-not (Test-Path $path)) { throw "designersdefs.lua not found: $path" }

$bytes = [System.IO.File]::ReadAllBytes($path)
$ascii = [System.Text.Encoding]::ASCII
$nl = "`r`n"
$hasLf = $false
foreach ($one in $bytes) { if ($one -eq 10) { $hasLf = $true; break } }
if (-not $hasLf) { $nl = "`n" }

# The first version of this patch appended onto a file that had no trailing
# newline, so both execscript calls landed on one line. Split that if it is still there.
$glued = $ascii.GetBytes("dummymenuadv.lua' )sys.execscript( 'gamedata/def/ex/ow_quest_transport_speed.lua' )")
$split = $ascii.GetBytes("dummymenuadv.lua' )${nl}sys.execscript( 'gamedata/def/ex/ow_quest_transport_speed.lua' )")
$gluedAt = Find-Bytes $bytes $glued
if ($gluedAt -ge 0) {
    $out = New-Object byte[] ($bytes.Length - $glued.Length + $split.Length)
    [System.Buffer]::BlockCopy($bytes, 0, $out, 0, $gluedAt)
    [System.Buffer]::BlockCopy($split, 0, $out, $gluedAt, $split.Length)
    $tail = $gluedAt + $glued.Length
    [System.Buffer]::BlockCopy($bytes, $tail, $out, $gluedAt + $split.Length, $bytes.Length - $tail)
    [System.IO.File]::WriteAllBytes($path, $out)
    Write-Host "Hook split onto its own line in $path"
    return
}

$marker = $ascii.GetBytes("ow_quest_transport_speed.lua")
if ((Find-Bytes $bytes $marker) -ge 0) {
    Write-Host "Hook already present in $path"
    return
}

$anchor = $ascii.GetBytes("sys.execscript( 'scripts/dummymenuadv.lua' )")
$idx = Find-Bytes $bytes $anchor
if ($idx -lt 0) { throw "Anchor line not found in $path" }

$end = $idx + $anchor.Length
$prefix = New-Object byte[] $end
[System.Buffer]::BlockCopy($bytes, 0, $prefix, 0, $end)
# Last line of designersdefs.lua has no trailing newline. Start the hook on the next line.
$lead = @()
if ($end -eq 0 -or ($bytes[$end - 1] -ne 10 -and $bytes[$end - 1] -ne 13)) {
    $lead = $ascii.GetBytes($nl)
}
$line = $ascii.GetBytes("sys.execscript( 'gamedata/def/ex/ow_quest_transport_speed.lua' )$nl")
$tailLen = $bytes.Length - $end
$out = New-Object byte[] ($prefix.Length + $lead.Length + $line.Length + $tailLen)
[System.Buffer]::BlockCopy($prefix, 0, $out, 0, $prefix.Length)
if ($lead.Length -gt 0) { [System.Buffer]::BlockCopy($lead, 0, $out, $prefix.Length, $lead.Length) }
[System.Buffer]::BlockCopy($line, 0, $out, $prefix.Length + $lead.Length, $line.Length)
if ($tailLen -gt 0) {
    [System.Buffer]::BlockCopy($bytes, $end, $out, $prefix.Length + $lead.Length + $line.Length, $tailLen)
}
[System.IO.File]::WriteAllBytes($path, $out)
Write-Host "Hook added to $path"
