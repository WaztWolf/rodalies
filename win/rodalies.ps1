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
