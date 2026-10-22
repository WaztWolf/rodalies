# Rodalies Chaos 2.0 - Windows launcher (PowerShell 5.1+)
# No installation, administrator permissions or persistent background task required.
$ErrorActionPreference = 'Stop'

$base = 'https://raw.githubusercontent.com/WaztWolf/rodalies/main'
$source = "$base/rodalies.html?v=$([DateTimeOffset]::UtcNow.ToUnixTimeSeconds())"
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

Write-Host ''
Write-Host '===============================================' -ForegroundColor Magenta
Write-Host '     RODALIES CHAOS 2.0 / WINDOWS' -ForegroundColor Cyan
Write-Host '===============================================' -ForegroundColor Magenta

try {
    if ($PSVersionTable.PSEdition -eq 'Desktop') {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    }
    $browser = Find-ChromiumBrowser
    if (-not $browser) {
        throw 'No se ha encontrado Microsoft Edge o Google Chrome. Instala uno para usar la ventana sin bordes.'
    }
    New-Item -ItemType Directory -Path $workDir -Force | Out-Null
    Write-Host '[1/3] Descargando el HTML...' -ForegroundColor Yellow
    Invoke-WebRequest -Uri $source -OutFile $htmlFile -UseBasicParsing -TimeoutSec 30
    if ((Get-Item -LiteralPath $htmlFile).Length -lt 200) {
        throw 'El archivo descargado esta vacio o no parece un HTML valido.'
    }
    $header = Get-Content -LiteralPath $htmlFile -TotalCount 1
    if ($header -notmatch '<!DOCTYPE html|<html') {
        throw 'GitHub no ha devuelto una pagina HTML valida.'
    }
    # Unique profile forces a NEW Chromium process even if the normal browser is already open.
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
    Write-Host 'Rodalies activado. Cierra con Alt+F4. Pulsa F si necesitas forzar fullscreen.' -ForegroundColor Magenta
} catch {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    throw
}
