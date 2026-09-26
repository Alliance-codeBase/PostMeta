#Requires -Version 7
<#
.SYNOPSIS
    Runs LibreTranslate (Russian <-> English only) natively on Windows,
    without Docker, bound to loopback, for the SS13 auto-translation feature.

.DESCRIPTION
    Native-Python counterpart to Install-LibreTranslate.ps1 (Docker) and
    install-libretranslate.sh (Linux/systemd).

    Installs libretranslate into a dedicated venv under
    %LOCALAPPDATA%\LibreTranslate, creates a small launcher script, and
    registers a Scheduled Task that starts the server at logon (and keeps it
    alive). No Docker, no WSL, no systemd.

.PARAMETER BindAddress
    Loopback address to listen on. Default 127.0.0.1.

.PARAMETER Port
    TCP port. Default 5000.

.PARAMETER Languages
    Comma-separated list of languages to load. Default 'en,ru'.

.PARAMETER MemoryLimit
    Soft memory cap in MB, enforced by a PowerShell watchdog that restarts
    the server if its working set exceeds the cap. Set 0 to disable.
    Note: this is a watchdog, not a hard cgroup-style cap.

.PARAMETER StartupTimeoutSeconds
    How long to wait for the endpoint to answer on first run. The first run
    downloads the Argos RU<->EN models, which can take several minutes.

.PARAMETER RegisterStartupTask
    Register a Scheduled Task that starts the server at logon.

.PARAMETER Remove
    Tear everything down instead of installing.

.EXAMPLE
    .\Install-LibreTranslate-Native.ps1

.EXAMPLE
    .\Install-LibreTranslate-Native.ps1 -Remove
#>
[CmdletBinding()]
param(
    [string] $BindAddress = '127.0.0.1',
    [int]    $Port = 5000,
    [string] $Languages = 'en,ru',
    [int]    $MemoryLimit = 2048,
    [int]    $StartupTimeoutSeconds = 900,
    [switch] $RegisterStartupTask,
    [switch] $Remove
)

$ErrorActionPreference = 'Stop'

$InstallRoot = Join-Path $env:LOCALAPPDATA 'LibreTranslate'
$VenvDir     = Join-Path $InstallRoot 'venv'
$VenvPython  = Join-Path $VenvDir 'Scripts\python.exe'
$LogDir      = Join-Path $InstallRoot 'logs'
$Launcher    = Join-Path $InstallRoot 'run-libretranslate.ps1'
$PidFile     = Join-Path $InstallRoot 'libretranslate.pid'
$TaskName    = 'LibreTranslate-SS13'
$PipCache    = Join-Path $InstallRoot 'pip-cache'

# Argos model directory — same layout the Docker volume used, so if you ever
# migrate from the container you can just copy the folder here.
$ArgosDir = Join-Path $env:USERPROFILE '.local\share\argos-translate'

function Get-Python {
    # Prefer the py launcher, fall back to python on PATH.
    if (Get-Command py -ErrorAction SilentlyContinue) {
        $v = & py -3 --version 2>&1
        if ($LASTEXITCODE -eq 0) { return @{ Exe = 'py'; Args = @('-3') } }
    }
    if (Get-Command python -ErrorAction SilentlyContinue) {
        $v = & python --version 2>&1
        if ($LASTEXITCODE -eq 0) { return @{ Exe = 'python'; Args = @() } }
    }
    throw 'Python 3 was not found. Install it from https://www.python.org/downloads/ (check "Add to PATH") and re-run.'
}

# --- teardown ----------------------------------------------------------------

if ($Remove) {
    Write-Host '>> stopping any running server'
    & $Launcher -Stop 2>$null
    if (Test-Path $PidFile) { Remove-Item $PidFile -Force -ErrorAction SilentlyContinue }

    if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
        Write-Host '>> removing scheduled task'
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }

    # Ask before nuking the venv — reinstalling is a few minutes.
    $answer = Read-Host ">> remove the venv at '$VenvDir'? [y/N]"
    if ($answer -match '^[yY]') {
        Remove-Item -Recurse -Force $VenvDir -ErrorAction SilentlyContinue
    }

    Write-Host ">> Argos models at '$ArgosDir' were left in place."
    Write-Host "   Remove them manually if you want a clean slate."
    return
}

# --- preflight ---------------------------------------------------------------

$py = Get-Python
Write-Host ">> using Python: $($py.Exe) $($py.Args -join ' ')"

New-Item -ItemType Directory -Force -Path $InstallRoot, $LogDir, $PipCache | Out-Null

# --- venv + pip install ------------------------------------------------------

if (-not (Test-Path $VenvPython)) {
    Write-Host ">> creating venv at $VenvDir"
    & $py.Exe @($py.Args) -m venv $VenvDir
    if ($LASTEXITCODE -ne 0) { throw 'venv creation failed.' }
}

Write-Host '>> upgrading pip'
& $VenvPython -m pip install --upgrade pip --quiet

Write-Host '>> installing libretranslate (this may take a few minutes)'
& $VenvPython -m pip install --upgrade libretranslate `
    --cache-dir $PipCache
if ($LASTEXITCODE -ne 0) { throw 'pip install libretranslate failed.' }

# --- launcher ----------------------------------------------------------------

Write-Host ">> writing launcher $Launcher"

# The launcher is a small PS script that starts the server detached, writes a
# pid file, and can stop it. Kept on disk (not inline) so the scheduled task
# and manual use share exactly the same code path.
$launcherBody = @'
#Requires -Version 7
[CmdletBinding()]
param(
    [switch] $Stop,
    [int]    $MemoryLimitMB = __MEMLIMIT__,
    [string] $BindAddress   = '__BINDADDR__',
    [int]    $Port          = __PORT__,
    [string] $Languages     = '__LANGS__'
)

$ErrorActionPreference = 'Stop'

$Root       = '__ROOT__'
$VenvPython = Join-Path $Root 'venv\Scripts\python.exe'
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

if (-not (Test-Path $VenvPython)) {
    throw "venv python not found at $VenvPython. Re-run Install-LibreTranslate-Native.ps1."
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$env:LT_LOAD_ONLY       = $Languages
$env:LT_DISABLE_WEB_UI  = 'true'
$env:LT_UPDATE_MODELS   = 'false'
$env:LT_THREADS         = '1'
$env:LT_HOST            = $BindAddress
$env:LT_PORT            = "$Port"

# Trim Python's memory appetites slightly; these are cheap wins.
$env:PYTHONUNBUFFERED   = '1'
$env:PYTHONDONTWRITEBYTECODE = '1'

Write-Host ">> starting LibreTranslate on http://${BindAddress}:${Port}"

# Start-Process so we can capture the PID and detach cleanly. Lower priority
# so a busy SS13 server always wins the CPU fight, mirroring --cpu-shares=256.
$proc = Start-Process -FilePath $VenvPython `
    -ArgumentList @('-m', 'libretranslate') `
    -RedirectStandardOutput $OutLog `
    -RedirectStandardError  $ErrLog `
    -WindowStyle Hidden `
    -PassThru

$proc.PriorityClass = 'BelowNormal'
$proc.Id | Out-File -FilePath $PidFile -Encoding ascii -NoNewline

# --- watchdog ----------------------------------------------------------------
# No cgroups on Windows without a Job Object. A lightweight polling watchdog
# is enough for a dev box: if RSS exceeds the cap, restart the process.
# The scheduled task re-invokes this launcher at logon; the watchdog just
# bounces the child process within the same session.
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
            # Re-exec ourselves to pick up the new process.
            & $MyInvocation.MyCommand.Path -MemoryLimitMB $MemoryLimitMB `
                -BindAddress $BindAddress -Port $Port -Languages $Languages
            break
        }
    }
} else {
    # No watchdog: just wait for the child to exit so the task stays alive
    # and Task Scheduler can restart it if configured to.
    Wait-Process -Id $proc.Id -ErrorAction SilentlyContinue
}
'@

# Inject the caller's parameters into the launcher template.
$launcherBody = $launcherBody.
    Replace('__MEMLIMIT__', $MemoryLimit).
    Replace('__BINDADDR__', $BindAddress).
    Replace('__PORT__',     $Port).
    Replace('__LANGS__',    $Languages).
    Replace('__ROOT__',     $InstallRoot.Replace('\', '\\'))

Set-Content -Path $Launcher -Value $launcherBody -Encoding UTF8

# --- start + wait ------------------------------------------------------------

Write-Host '>> starting server (first run downloads models, be patient)'
& $Launcher

Write-Host -NoNewline ">> waiting for http://${BindAddress}:${Port}/languages"
$deadline = (Get-Date).AddSeconds($StartupTimeoutSeconds)
$ready = $false
while ((Get-Date) -lt $deadline) {
    try {
        Invoke-RestMethod -Uri "http://${BindAddress}:${Port}/languages" -TimeoutSec 5 | Out-Null
        $ready = $true
        break
    } catch {
        Write-Host -NoNewline '.'
        Start-Sleep -Seconds 5
    }
}
if (-not $ready) {
    Write-Host
    throw "Endpoint did not come up within $StartupTimeoutSeconds seconds. Check $LogDir\libretranslate.err.log"
}
Write-Host ' up.'

# --- smoke test --------------------------------------------------------------

# Built from code points so this file's encoding can never break the test.
$russian = "`u{043F}`u{0440}`u{0438}`u{0432}`u{0435}`u{0442}, `u{0433}`u{0434}`u{0435} `u{0441}`u{0431}?"

Write-Host '>> smoke test'
$body = @{
    q      = $russian
    source = 'ru'
    target = 'en'
    format = 'text'
} | ConvertTo-Json -Compress

$response = Invoke-RestMethod `
    -Uri "http://${BindAddress}:${Port}/translate" `
    -Method Post `
    -ContentType 'application/json; charset=utf-8' `
    -Body ([System.Text.Encoding]::UTF8.GetBytes($body))

Write-Host "   $russian  ->  $($response.translatedText)"

# --- optional startup task ---------------------------------------------------

if ($RegisterStartupTask) {
    Write-Host '>> registering logon task'
    if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false
    }

    $pwsh = (Get-Command pwsh -ErrorAction SilentlyContinue).Source
    if (-not $pwsh) { $pwsh = 'powershell.exe' }

    $action  = New-ScheduledTaskAction -Execute $pwsh `
        -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$Launcher`""
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $settings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -ExecutionTimeLimit (New-TimeSpan -Days 0)  # unlimited: it's a server

    Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger `
        -Settings $settings -RunLevel Highest `
        -Description 'Starts the native LibreTranslate server for SS13.' | Out-Null
}

# --- done --------------------------------------------------------------------

@"

Done.

Add to config\game_options.txt:

    TRANSLATE_HTTP_URL http://${BindAddress}:${Port}
    TRANSLATE_HTTP_TIMEOUT_SECONDS 5

Then restart the server. SSautotranslate probes the endpoint at init; if it
does not answer, translation stays off for the round and nothing else breaks.

Useful commands:
    & "$Launcher"                 # start
    & "$Launcher" -Stop           # stop
    Get-Content "$LogDir\libretranslate.err.log" -Wait
    Get-Process python | Where-Object Path -like "*LibreTranslate*" | Select-Object Id,WorkingSet64

Uninstall:
    .\Install-LibreTranslate-Native.ps1 -Remove
"@ | Write-Host
