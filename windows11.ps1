# Windows 11 cleanup simulator - harmless prank.
# This script ONLY prints text and sleeps. It does not read, delete, move,
# or change any real files, registry keys, services, boot settings or disks.

$previousTitle = $null
try { $previousTitle = $Host.UI.RawUI.WindowTitle } catch {}

function Fake-Line([string]$Text, [string]$Color = "Gray") {
    Write-Host $Text -ForegroundColor $Color
}

function Fake-Progress([string]$Title, [int]$Delay = 75) {
    for ($pct = 0; $pct -le 100; $pct += 5) {
        $blocks = [int]($pct / 5)
        $bar = ("#" * $blocks) + ("." * (20 - $blocks))
        Write-Host (([char]13) + ("{0,-24} [{1}] {2,3}%" -f $Title, $bar, $pct)) -ForegroundColor Yellow -NoNewline
        Start-Sleep -Milliseconds $Delay
    }
    Write-Host ""
}

try {
    try { $Host.UI.RawUI.WindowTitle = "Microsoft Windows - System Maintenance" } catch {}
    Clear-Host
    Fake-Line "Microsoft Windows [Version 10.0.26100.1]" "Gray"
    Fake-Line "(c) Microsoft Corporation. All rights reserved." "Gray"
    Fake-Line ""
    Fake-Line "C:\Windows\System32> win11clean /force /deep /norestore" "White"
    Start-Sleep -Milliseconds 850
    Fake-Line ""
    Fake-Line "Windows 11 System Cleanup Utility" "White"
    Fake-Line "Build 26100 | Target: %SystemDrive% | Mode: FULL WIPE" "Gray"
    Start-Sleep -Milliseconds 600
    Fake-Line "[OK] System volume detected: C:\" "Green"
    Start-Sleep -Milliseconds 450
    Fake-Line "[OK] BCD store located." "Green"
    Start-Sleep -Milliseconds 500
    Fake-Line "[WARN] Recovery environment will be unavailable." "Yellow"
    Start-Sleep -Milliseconds 750
    Fake-Line "[WARN] Proceeding without confirmation..." "Yellow"
    Start-Sleep -Milliseconds 850
    Fake-Line ""
    Fake-Progress "Preparing cleanup" 80
    Fake-Line ""
    Fake-Line "[DELETE] C:\Windows\System32\kernel32.dll" "Red"
    Start-Sleep -Milliseconds 300
    Fake-Line "[DELETE] C:\Windows\System32\winload.efi" "Red"
    Start-Sleep -Milliseconds 300
    Fake-Line "[DELETE] C:\Windows\System32\drivers\disk.sys" "Red"
    Start-Sleep -Milliseconds 300
    Fake-Line "[DELETE] C:\Windows\System32\ntoskrnl.exe" "Red"
    Start-Sleep -Milliseconds 400
    Fake-Progress "Removing System32" 100
    Fake-Line ""
    Fake-Line "[CRITICAL] Protected operating system components flagged for removal." "Red"
    Start-Sleep -Milliseconds 900
    Fake-Line "[BYPASS] TrustedInstaller protection overridden (simulated)." "Yellow"
    Start-Sleep -Milliseconds 550
    Fake-Line "[DELETE] C:\Windows\Boot\EFI\bootmgfw.efi" "Red"
    Start-Sleep -Milliseconds 550
    Fake-Line "[DELETE] C:\Boot\BCD" "Red"
    Start-Sleep -Milliseconds 550
    Fake-Progress "Erasing boot records" 115
    Fake-Line ""
    Fake-Line "[ERROR] Windows Boot Manager not found." "Red"
    Start-Sleep -Milliseconds 850
    Fake-Line "[ERROR] Recovery partition inaccessible." "Red"
    Start-Sleep -Milliseconds 700
    Fake-Line "[CRITICAL] No bootable operating system detected." "Red"
    Start-Sleep -Milliseconds 900
    Fake-Line ""
    Fake-Line "A restart is required to complete the operation." "White"
    for ($seconds = 5; $seconds -ge 1; $seconds--) {
        Fake-Line ("Restarting computer in {0}..." -f $seconds) "Yellow"
        Start-Sleep -Seconds 1
    }
    Clear-Host
    Fake-Line "============================================================" "Green"
    Fake-Line "                        ERA BROMA XD" "Green"
    Fake-Line "============================================================" "Green"
    Fake-Line ""
    Fake-Line "NO se ha borrado Windows 11 ni se ha tocado NINGUN archivo." "White"
    Fake-Line "Todo lo anterior era una simulacion en PowerShell." "White"
    Fake-Line "Puedes cerrar esta ventana sin problema :)" "Cyan"
    Fake-Line ""
} finally {
    if ($null -ne $previousTitle) {
        try { $Host.UI.RawUI.WindowTitle = $previousTitle } catch {}
    }
}