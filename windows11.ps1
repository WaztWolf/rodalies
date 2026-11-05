# Windows 11 System Cleanup - SIMULADOR DE BROMA
# IMPORTANTE: SOLO EFECTOS VISUALES. No elimina, mueve ni modifica
# archivos, particiones, registro, servicios, BCD ni configuracion.
# No ejecuta comandos de mantenimiento. Ctrl+C cancela la simulacion.

$oldTitle = $null
try { $oldTitle = $Host.UI.RawUI.WindowTitle } catch {}

function Out-Fake {
    param([string]$Message, [string]$Color = "Gray", [int]$Pause = 0)
    Write-Host $Message -ForegroundColor $Color
    if ($Pause -gt 0) { Start-Sleep -Milliseconds $Pause }
}
function Out-Header {
    param([string]$Name)
    Out-Fake ""
    Out-Fake ("  [{0}]" -f $Name) "Cyan" 330
    Out-Fake ("  " + ("-" * 68)) "DarkGray"
}
function Show-Progress {
    param([string]$Name, [int]$Pace = 95, [string]$Color = "Yellow")
    $steps = @(0,2,4,7,10,13,17,21,26,31,35,39,44,48,53,57,61,64,67,69,69,69,72,75,79,82,85,89,92,96,98,100)
    foreach ($pct in $steps) {
        $filled = [int][math]::Floor($pct / 4)
        $bar = ("#" * $filled) + ("." * (25 - $filled))
        Write-Host ([string][char]13 + ("  {0,-23} [{1}] {2,3}%" -f $Name, $bar, $pct)) -NoNewline -ForegroundColor $Color
        if ($pct -eq 69) { Start-Sleep -Milliseconds ($Pace + 135) }
        else { Start-Sleep -Milliseconds $Pace }
    }
    Write-Host ""
}
function Show-Files {
    param([string[]]$Items)
    foreach ($item in $Items) {
        Out-Fake ("  [REMOVED] {0}" -f $item) "DarkRed" 185
    }
}
function Show-Countdown {
    param([int]$From)
    for ($i=$From; $i -ge 1; $i--) {
        Write-Host ([string][char]13 + ("  Restarting system in {0} seconds... " -f $i)) -NoNewline -ForegroundColor Red
        Start-Sleep -Seconds 1
    }
    Write-Host ""
}

try {
    try { $Host.UI.RawUI.WindowTitle = "Administrator: Windows System Maintenance" } catch {}
    Clear-Host

    Out-Fake "Microsoft Windows [Version 10.0.26100.1]" "Gray" 350
    Out-Fake "(c) Microsoft Corporation. All rights reserved." "Gray" 350
    Out-Fake ""
    Out-Fake "C:\Windows\System32> system-maintenance.exe /purge /online /no-restore" "White" 1200
    Out-Fake ""
    Out-Fake "Windows Deployment and Recovery Environment" "White" 350
    Out-Fake "System component maintenance utility v10.0.26100" "Gray" 300
    Out-Fake ""
    Out-Fake "Initializing servicing stack..." "Gray" 600
    Out-Fake "Loading volume descriptors..." "Gray" 500
    Out-Fake "Resolving system image: C:\Windows" "Gray" 500
    Out-Fake "Target volume: \\?\Volume{A4F0-21B3-8C22}\ (NTFS)" "DarkGray" 300
    Out-Fake "System image version: 10.0.26100.1" "Gray" 400
    Out-Fake ""
    Out-Fake "  [OK] Windows installation detected" "Green" 280
    Out-Fake "  [OK] System32 component inventory loaded" "Green" 280
    Out-Fake "  [OK] Boot Configuration Data located" "Green" 280
    Out-Fake "  [OK] EFI System Partition mounted (virtual)" "Green" 400
    Out-Fake "  [WARN] Restore checkpoint not configured" "Yellow" 650
    Out-Fake "  [WARN] Interactive confirmations disabled" "Yellow" 650

    Out-Header "PHASE 01 / 05 - SYSTEM INVENTORY"
    Show-Progress "Checking system files" 75
    Out-Fake "  84,219 objects indexed. 6,307 protected resources detected." "Gray" 500
    Out-Fake "  Estimated reclaimable space: 26.7 GB" "Gray" 350
    Out-Fake "  WinRE status: unavailable after cleanup" "Yellow" 450

    Out-Header "PHASE 02 / 05 - ACCESS CONTROL"
    Out-Fake "  Requesting NT SERVICE\TrustedInstaller token..." "Gray" 700
    Out-Fake "  ERROR 0x80070005: Access is denied." "Red" 700
    Out-Fake "  Retrying with maintenance override..." "Yellow" 1050
    Show-Progress "Acquiring permissions" 70
    Out-Fake "  [OK] File ownership checks bypassed (simulated)" "Green" 550
    Out-Fake "  [WARN] Windows Resource Protection: offline" "Yellow" 550

    Out-Header "PHASE 03 / 05 - COMPONENT REMOVAL"
    Out-Fake "  Beginning recursive removal of system components..." "Gray" 600
    Show-Files @(
        "C:\Windows\System32\drivers\disk.sys",
        "C:\Windows\System32\drivers\acpi.sys",
        "C:\Windows\System32\drivers\ntfs.sys",
        "C:\Windows\System32\kernel32.dll",
        "C:\Windows\System32\user32.dll",
        "C:\Windows\System32\winlogon.exe",
        "C:\Windows\System32\csrss.exe",
        "C:\Windows\System32\ntdll.dll",
        "C:\Windows\System32\ntoskrnl.exe"
    )
    Show-Progress "Purging System32" 105 "Red"
    Out-Fake "  [WARN] Active image now missing required runtime components." "Yellow" 700
    Out-Fake "  [ERROR] 0xc000000f - Required device is inaccessible." "Red" 750
    Out-Fake "  Removing residual packages..." "Gray" 450
    Show-Progress "Component store" 75 "Red"
    Out-Fake "  [OK] Windows servicing inventory: EMPTY" "Green" 600

    Out-Header "PHASE 04 / 05 - BOOT CONFIGURATION"
    Out-Fake "  Enumerating EFI boot entries..." "Gray" 600
    Out-Fake "  Windows Boot Manager  {bootmgr}" "Gray" 450
    Out-Fake "  Default loader: \Windows\system32\winload.efi" "Gray" 450
    Show-Files @(
        "C:\Windows\Boot\EFI\bootmgfw.efi",
        "C:\Windows\System32\winload.efi",
        "C:\Boot\BCD"
    )
    Show-Progress "Clearing boot records" 115 "Red"
    Out-Fake "  [ERROR] BCD status: 0xc0000098" "Red" 650
    Out-Fake "  [CRITICAL] No bootable Windows installation detected." "Red" 1000

    Out-Header "PHASE 05 / 05 - FINAL VERIFICATION"
    Out-Fake "  Attempting automatic repair..." "White" 900
    Show-Progress "Startup repair" 90 "Yellow"
    Out-Fake "  [FAILED] Windows Recovery Environment not found." "Red" 900
    Out-Fake "  [FAILED] System image integrity: 0%" "Red" 900
    Out-Fake "  [CRITICAL] BOOT DEVICE UNAVAILABLE" "Red" 1000
    Out-Fake ""
    Out-Fake "  Cleanup completed. A system restart is mandatory." "White" 900
    Out-Fake "  Do not turn off your computer." "Yellow" 550
    Show-Countdown 6
    Start-Sleep -Milliseconds 1200

    Clear-Host
    Out-Fake " " "White"
    Out-Fake "  =============================================================" "Green"
    Out-Fake "                     JAJAJA ERA BROMA XD" "Green"
    Out-Fake "  =============================================================" "Green"
    Out-Fake ""
    Out-Fake "  NO se ha borrado Windows 11." "White"
    Out-Fake "  No se ha eliminado ni modificado NINGUN archivo." "White"
    Out-Fake "  No se han tocado discos, arranque, registro ni servicios." "White"
    Out-Fake "  Todas las rutas, operaciones y porcentajes eran inventados." "Cyan"
    Out-Fake ""
    Out-Fake "  Has sobrevivido al 'borrado' de System32. :)" "Green"
    Out-Fake "  Puedes cerrar esta ventana sin problema." "Gray"
    Out-Fake ""
}
finally {
    if ($null -ne $oldTitle) {
        try { $Host.UI.RawUI.WindowTitle = $oldTitle } catch {}
    }
}
