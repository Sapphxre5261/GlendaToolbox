$mmc = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
$gm  = "$mmc\Tasks\Games"
$pc  = "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl"
$ms  = "HKCU:\Control Panel\Mouse"

# Path, Name, Tweaked, Default
$items = @(
    @($mmc, "SystemResponsiveness",    0,        20)
    @($gm,  "Priority",                6,        2)
    @($gm,  "Scheduling Category",     "High",   "Medium")
    @($gm,  "SFIO Priority",           "High",   "Normal")
    @($pc,  "Win32PrioritySeparation", 38,       2)
    @($ms,  "MouseSpeed",              "0",      "1")
    @($ms,  "MouseThreshold1",         "0",      "6")
    @($ms,  "MouseThreshold2",         "0",      "10")
)

$items | ForEach-Object {
    $v = (Get-ItemProperty -Path $_[0] -Name $_[1] -ErrorAction SilentlyContinue).($_[1])
    $status = if     ($null -eq $v)          { "Not set" }
              elseif ("$v" -eq "$($_[2])")   { "Tweaked" }
              elseif ("$v" -eq "$($_[3])")   { "Default" }
              else                           { "Other" }
    [PSCustomObject]@{ Name = $_[1]; Current = $v; Status = $status }
} | Format-Table -AutoSize 
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