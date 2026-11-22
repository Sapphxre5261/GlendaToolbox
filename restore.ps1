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