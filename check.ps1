$mmc      = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
$games    = "$mmc\Tasks\Games"
$priority = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
$mouse    = "HKCU:\Control Panel\Mouse"

if (-not (Test-Path $games)) { New-Item -Path $games -Force | Out-Null }

Write-Host "[1/4] System Responsiveness = 20 (default)..."
Set-ItemProperty -Path $mmc -Name "SystemResponsiveness" -Value 20 -Type DWord

Write-Host "[2/4] Network Throttling = 10 (default)..."
Set-ItemProperty -Path $mmc -Name "NetworkThrottlingIndex" -Value 10 -Type DWord

Write-Host "[3/4] MMCSS Games task -> default..."
Set-ItemProperty -Path $games -Name "GPU Priority"        -Value 8        -Type DWord
Set-ItemProperty -Path $games -Name "Priority"            -Value 2        -Type DWord
Set-ItemProperty -Path $games -Name "Scheduling Category" -Value "Medium" -Type String
Set-ItemProperty -Path $games -Name "SFIO Priority"       -Value "Normal" -Type String

Write-Host "[4/4] Win32PrioritySeparation = 2 (default)..."
Set-ItemProperty -Path $priority -Name "Win32PrioritySeparation" -Value 2 -Type DWord

Write-Host "Mouse -> Windows default (pointer precision on)..."
Set-ItemProperty -Path $mouse -Name "MouseSpeed"      -Value "1"  -Type String
Set-ItemProperty -Path $mouse -Name "MouseThreshold1" -Value "6"  -Type String
Set-ItemProperty -Path $mouse -Name "MouseThreshold2" -Value "10" -Type String

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