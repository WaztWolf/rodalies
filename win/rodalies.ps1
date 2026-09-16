$ErrorActionPreference = "Stop"

$HTML_URL = "https://raw.githubusercontent.com/TU_USUARIO/TU_REPO/main/rodalies.html"
$TEMP_HTML = Join-Path $env:TEMP "rodalies-chaos.html"

Write-Host ""
Write-Host "==============================================" -ForegroundColor Magenta
Write-Host "        🚆 RODALIES CHAOS 🚆" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Magenta
Write-Host ""

Write-Host "[+] Descargando Rodalies Chaos..." -ForegroundColor Yellow

try {
    Invoke-WebRequest `
        -Uri $HTML_URL `
        -OutFile $TEMP_HTML `
        -UseBasicParsing
}
catch {
    Write-Host "[!] No se pudo descargar el HTML." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

Write-Host "[+] HTML descargado." -ForegroundColor Green

$browsers = @(
    @{
        Name = "Microsoft Edge"
        Paths = @(
            "$env:ProgramFiles(x86)\Microsoft\Edge\Application\msedge.exe",
            "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
            "$env:LOCALAPPDATA\Microsoft\Edge\Application\msedge.exe"
        )
    },
    @{
        Name = "Google Chrome"
        Paths = @(
            "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
            "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe",
            "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
        )
    }
)

$browser = $null
$browserName = $null

foreach ($candidate in $browsers) {
    foreach ($path in $candidate.Paths) {
        if (Test-Path $path) {
            $browser = $path
            $browserName = $candidate.Name
            break
        }
    }

    if ($browser) {
        break
    }
}

# También probar PATH
if (-not $browser) {
    $edge = Get-Command msedge.exe -ErrorAction SilentlyContinue

    if ($edge) {
        $browser = $edge.Source
        $browserName = "Microsoft Edge"
    }
}

if (-not $browser) {
    $chrome = Get-Command chrome.exe -ErrorAction SilentlyContinue

    if ($chrome) {
        $browser = $chrome.Source
        $browserName = "Google Chrome"
    }
}

if (-not $browser) {
    Write-Host "[!] No encuentro Edge ni Chrome." -ForegroundColor Red
    Write-Host ""
    Write-Host "Abriendo el HTML directamente..." -ForegroundColor Yellow

    Start-Process $TEMP_HTML
    exit 0
}

Write-Host "[+] Navegador encontrado: $browserName" -ForegroundColor Green
Write-Host "[+] Lanzando Rodalies Chaos..." -ForegroundColor Cyan
Write-Host ""

$args = @(
    "--app=`"$TEMP_HTML`"",
    "--start-maximized",
    "--disable-features=Translate"
)

Start-Process `
    -FilePath $browser `
    -ArgumentList $args

Write-Host "🚆 CAOS FERROVIARI ACTIVAT." -ForegroundColor Magenta
Write-Host ""
