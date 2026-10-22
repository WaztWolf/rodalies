# Rodalies Chaos 2.2 - Windows launcher (PowerShell 5.1+)
# Downloads verified HTML from this repo; no embedded here-strings.
# Nothing runs in the background; exit the browser with Alt+F4.
$ErrorActionPreference = 'Stop'

$base = 'https://raw.githubusercontent.com/WaztWolf/rodalies/main'
$htmlUrl = "$base/rodalies.html"
$workDir = Join-Path $env:TEMP 'rodalies-chaos'
$htmlFile = Join-Path $workDir 'rodalies.html'

function Find-ChromiumBrowser {
    $candidates = New-Object 'System.Collections.Generic.List[string]'
    foreach ($name in @('msedge.exe', 'chrome.exe')) {
        foreach ($regPath in @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\App Paths\$name",
            "HKLM:\Software\Microsoft\Windows\CurrentVersion\App Paths\$name"
        )) {
            try {
                $regItem = Get-Item -LiteralPath $regPath -ErrorAction Stop
                $value = $regItem.GetValue('')
                if ($value) { $candidates.Add([string]$value) }
            } catch { }
        }
    }
    $pf = [Environment]::GetFolderPath('ProgramFiles')
    $pfx86 = [Environment]::GetFolderPath('ProgramFilesX86')
    foreach ($root in @($pf, $pfx86, $env:LOCALAPPDATA)) {
        if (-not [string]::IsNullOrWhiteSpace($root)) {
            $candidates.Add((Join-Path $root 'Microsoft\Edge\Application\msedge.exe'))
            $candidates.Add((Join-Path $root 'Google\Chrome\Application\chrome.exe'))
        }
    }
    foreach ($name in @('msedge.exe', 'chrome.exe')) {
        $command = Get-Command $name -ErrorAction SilentlyContinue
        if ($command -and $command.Source) { $candidates.Add([string]$command.Source) }
    }
    foreach ($candidate in $candidates) {
        $clean = $candidate.Trim('"')
        if (Test-Path -LiteralPath $clean -PathType Leaf) { return $clean }
    }
    return $null
}

function Test-RodaliesHtml([string]$path) {
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return $false }
    if ((Get-Item -LiteralPath $path).Length -lt 200) { return $false }
    # Check the WHOLE file, not only its first line.
    $content = [IO.File]::ReadAllText($path, [Text.Encoding]::UTF8)
    return ($content -match '(?is)<!doctype\s+html\b|<html(?:\s|>)' -and $content -match '(?i)rodalies')
}

Write-Host ''
Write-Host '===============================================' -ForegroundColor Magenta
Write-Host '     RODALIES CHAOS 2.2 / WINDOWS' -ForegroundColor Cyan
Write-Host '===============================================' -ForegroundColor Magenta

try {
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
    $browser = Find-ChromiumBrowser
    if (-not $browser) {
        throw 'No se ha encontrado Microsoft Edge ni Google Chrome.'
    }
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null

    Write-Host '[1/3] Comprobando el HTML de GitHub...' -ForegroundColor Yellow
    if (Test-Path -LiteralPath $htmlFile) { Remove-Item -LiteralPath $htmlFile -Force }
    Invoke-WebRequest -Uri $htmlUrl -OutFile $htmlFile -UseBasicParsing -TimeoutSec 25 -Headers @{ 'Cache-Control'='no-cache' }
    if (-not (Test-RodaliesHtml $htmlFile)) {
        throw 'El archivo descargado no es el HTML esperado. Comprueba rodalies.html en GitHub.'
    }

    # Independent Chromium profile => a new app window, not an existing browser tab.
    $profileDir = Join-Path $workDir ('profile-' + [Guid]::NewGuid().ToString('N'))
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    $fileUri = ([System.Uri]::new([IO.Path]::GetFullPath($htmlFile))).AbsoluteUri
    Write-Host "[2/3] Navegador: $browser" -ForegroundColor Cyan
    $arguments = @(
        "--user-data-dir=`"$profileDir`""
        "--app=`"$fileUri`""
        '--start-fullscreen'
        '--new-window'
        '--no-first-run'
        '--no-default-browser-check'
        '--disable-extensions'
    )
    Write-Host '[3/3] Abriendo una ventana independiente...' -ForegroundColor Green
    Start-Process -FilePath $browser -ArgumentList ($arguments -join ' ') | Out-Null
    Write-Host 'Rodalies activado. Alt+F4: cerrar | F: pantalla completa | Espacio: turbo' -ForegroundColor Magenta
} catch {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    throw
}
