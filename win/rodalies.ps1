$ErrorActionPreference = "Stop"

$HTML_URL = "https://raw.githubusercontent.com/WaztWolf/rodalies/main/rodalies.html"
$TEMP_HTML = Join-Path $env:TEMP "rodalies-chaos.html"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Magenta
Write-Host "           RODALIES CHAOS MODE" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Magenta
Write-Host ""

# Descargar HTML
Write-Host "[+] Descargando Rodalies Chaos..." -ForegroundColor Yellow

Invoke-WebRequest `
    -Uri $HTML_URL `
    -OutFile $TEMP_HTML `
    -UseBasicParsing

Write-Host "[+] HTML descargado." -ForegroundColor Green

$browser = $null

$edgePaths = @(
    "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
)

foreach ($path in $edgePaths) {
    if (Test-Path $path) {
        $browser = $path
        break
    }
}

if (-not $browser) {

    $chromePaths = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )

    foreach ($path in $chromePaths) {
        if (Test-Path $path) {
            $browser = $path
            break
        }
    }
}

if (-not $browser) {

    $edge = Get-Command msedge.exe -ErrorAction SilentlyContinue

    if ($edge) {
        $browser = $edge.Source
    }
}

if (-not $browser) {

    $chrome = Get-Command chrome.exe -ErrorAction SilentlyContinue

    if ($chrome) {
        $browser = $chrome.Source
    }
}

if (-not $browser) {

    Write-Host ""
    Write-Host "[!] No se encontró Microsoft Edge ni Google Chrome." -ForegroundColor Red
    Write-Host "[+] Abriendo el archivo normalmente..." -ForegroundColor Yellow

    Start-Process $TEMP_HTML

    exit 0
}

Write-Host "[+] Navegador encontrado:" -ForegroundColor Green
Write-Host "    $browser" -ForegroundColor DarkGray

Write-Host ""
Write-Host "[+] ACTIVANDO RODALIES CHAOS..." -ForegroundColor Cyan
Write-Host ""

Start-Process `
    -FilePath $browser `
    -ArgumentList @(
        "--kiosk",
        "--start-maximized",
        "--disable-infobars",
        "--disable-features=Translate",
        "--no-first-run",
        "--no-default-browser-check",
        "file:///$TEMP_HTML"
    )

Write-Host "==============================================" -ForegroundColor Magenta
Write-Host "       🚆 CAOS FERROVIARI ACTIVAT 🚆" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Magenta
Write-Host ""
