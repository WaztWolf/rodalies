# Rodalies Chaos 2.1 - Windows launcher (PowerShell 5.1+)
# The fallback HTML is compressed and embedded in this script.
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

function Write-BundledHtml([string]$path) {
    $embedded = @'
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
Xxg9KscXpcvyf5fx352xzI8/QwAA
'@
    $bytes = [Convert]::FromBase64String(($embedded -replace '\s', ''))
    $inputStream = [System.IO.MemoryStream]::new($bytes)
    $gzip = [System.IO.Compression.GZipStream]::new($inputStream, [System.IO.Compression.CompressionMode]::Decompress)
    $outputStream = [System.IO.MemoryStream]::new()
    try {
        $gzip.CopyTo($outputStream)
        [IO.File]::WriteAllBytes($path, $outputStream.ToArray())
    } finally {
        $outputStream.Dispose()
        $gzip.Dispose()
        $inputStream.Dispose()
    }
}

Write-Host ''
Write-Host '===============================================' -ForegroundColor Magenta
Write-Host '     RODALIES CHAOS 2.1 / WINDOWS' -ForegroundColor Cyan
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
    $useFallback = $false
    try {
        # Ensure a stale version can never be mistaken for a successful download.
        if (Test-Path -LiteralPath $htmlFile) { Remove-Item -LiteralPath $htmlFile -Force }
        Invoke-WebRequest -Uri $htmlUrl -OutFile $htmlFile -UseBasicParsing -TimeoutSec 12 -Headers @{ 'Cache-Control'='no-cache' }
        if (-not (Test-RodaliesHtml $htmlFile)) {
            Write-Host '[AVISO] El HTML remoto no tiene el formato esperado. Uso la copia integrada.' -ForegroundColor Yellow
            $useFallback = $true
        }
    } catch {
        Write-Host ("[AVISO] No se pudo descargar el HTML: " + $_.Exception.Message) -ForegroundColor Yellow
        $useFallback = $true
    }
    if ($useFallback) {
        Write-BundledHtml $htmlFile
        Write-Host '[OK] Copia de Rodalies integrada en el script.' -ForegroundColor Green
    }
    if (-not (Test-RodaliesHtml $htmlFile)) {
        throw 'No se pudo preparar el HTML ni desde GitHub ni desde la copia integrada.'
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
