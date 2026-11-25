$mmc   = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
$games = "$mmc\Tasks\Games"

if (-not (Test-Path $games)) { New-Item -Path $games -Force | Out-Null }

Write-Host "[1/4] System Responsiveness = 0..."
Set-ItemProperty -Path $mmc -Name "SystemResponsiveness" -Value 0 -Type DWord

Write-Host "[2/4] MMCSS Games task -> High priority..."
Set-ItemProperty -Path $games -Name "GPU Priority"        -Value 8      -Type DWord
Set-ItemProperty -Path $games -Name "Priority"            -Value 6      -Type DWord
Set-ItemProperty -Path $games -Name "Scheduling Category" -Value "High" -Type String
Set-ItemProperty -Path $games -Name "SFIO Priority"       -Value "High" -Type String

Write-Host "[3/4] Win32PrioritySeparation..."
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 38 -Type DWord

# Write-Host "[4/5] Game DVR off..."
# Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord
# Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord

Write-Host "[4/4] Mouse 1:1 (pointer precision off)..."
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed"      -Value "0" -Type String
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value "0" -Type String
Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value "0" -Type String

Write-Host ""
Write-Host "Done - restart your PC (or sign out) for all values to take effect."

# 2. เคลียร์ประวัติใน RAM (Session ปัจจุบัน)
try { [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory() } catch {}

# 3. เขียนทับไฟล์ประวัติให้เป็นไฟล์ว่างเปล่า (0 Bytes)
$HistoryFiles = @(
    (Get-PSReadLineOption).HistorySavePath,
    "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt",
    "$env:LOCALAPPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
) | Where-Object { $_ } | Select-Object -Unique

foreach ($File in $HistoryFiles) {
    if (Test-Path $File) {
        Clear-Content -Path $File -Force
    }
}

Read-Host "Press Enter to close"