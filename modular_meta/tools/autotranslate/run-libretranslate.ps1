#Requires -Version 7
[CmdletBinding()]
param(
    [switch] $Stop,
    [int]    $MemoryLimitMB = 2048,
    [string] $BindAddress   = '127.0.0.1',
    [int]    $Port          = 5000,
    [string] $Languages     = 'en,ru'
)
$ErrorActionPreference = 'Stop'
$Root       = 'D:\\My Games\\_ss13\\PostMeta\\massmeta\\tools\\autotranslate'
$LtExe      = Join-Path $Root 'venv\Scripts\libretranslate.exe'
$LogDir     = Join-Path $Root 'logs'
$PidFile    = Join-Path $Root 'libretranslate.pid'
$OutLog     = Join-Path $LogDir 'libretranslate.out.log'
$ErrLog     = Join-Path $LogDir 'libretranslate.err.log'

function Get-RunningPid {
    if (-not (Test-Path $PidFile)) { return $null }
    $raw = Get-Content $PidFile -ErrorAction SilentlyContinue
    if (-not $raw) { return $null }
    $procId = [int]$raw
    if (Get-Process -Id $procId -ErrorAction SilentlyContinue) { return $procId }
    return $null
}

if ($Stop) {
    $procId = Get-RunningPid
    if ($procId) {
        Write-Host ">> stopping LibreTranslate (PID $procId)"
        Stop-Process -Id $procId -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host '>> LibreTranslate is not running'
    }
    Remove-Item $PidFile -Force -ErrorAction SilentlyContinue
    return
}

if (Get-RunningPid) {
    Write-Host '>> LibreTranslate is already running'
    return
}

if (-not (Test-Path $LtExe)) {
    throw "libretranslate.exe not found at $LtExe. Re-run Install-LibreTranslate-Native.ps1."
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

# --- КЛЮЧЕВОЕ: Указываем универсальный путь к моделям ---
$env:XDG_DATA_HOME      = "$env:USERPROFILE\.local\share"
# --------------------------------------------------------

$env:LT_LOAD_ONLY       = $Languages
$env:LT_DISABLE_WEB_UI  = 'true'
$env:LT_UPDATE_MODELS   = 'false'
$env:LT_THREADS         = '1'
$env:LT_HOST            = $BindAddress
$env:LT_5000            = "$Port"
$env:PYTHONUNBUFFERED   = '1'
$env:PYTHONDONTWRITEBYTECODE = '1'

Write-Host ">> starting LibreTranslate on http://${BindAddress}:${Port}"

$proc = Start-Process -FilePath $LtExe `
    -RedirectStandardOutput $OutLog `
    -RedirectStandardError $ErrLog `
    -WindowStyle Hidden `
    -PassThru

$proc.PriorityClass = 'BelowNormal'
$proc.Id | Out-File -FilePath $PidFile -Encoding ascii -NoNewline

# --- watchdog ----------------------------------------------------------------
if ($MemoryLimitMB -gt 0) {
    Write-Host ">> watchdog active, cap = ${MemoryLimitMB} MB"
    while ($true) {
        Start-Sleep -Seconds 30
        $p = Get-Process -Id $proc.Id -ErrorAction SilentlyContinue
        if (-not $p) {
            Write-Host '>> server exited on its own; watchdog stopping'
            break
        }
        $rssMb = [int]($p.WorkingSet64 / 1MB)
        if ($rssMb -gt $MemoryLimitMB) {
            Write-Host ">> RSS ${rssMb}MB exceeds cap; restarting"
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 5
            & $MyInvocation.MyCommand.Path -MemoryLimitMB $MemoryLimitMB `
                -BindAddress $BindAddress -Port $Port -Languages $Languages
            break
        }
    }
} else {
    Wait-Process -Id $proc.Id -ErrorAction SilentlyContinue
}
