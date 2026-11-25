
# ==========================================
# Windows Event Logs Cleaner
# Run as Administrator
# ==========================================

Write-Host "==================================" -ForegroundColor Cyan
Write-Host " Windows Event Logs Cleaner" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Check Administrator privilege
$currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($currentUser)

if (-not $principal.IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)) {
    Write-Host "Please run as Administrator!" -ForegroundColor Red
    exit
}

# Get all enabled Event Logs
$logs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue |
    Where-Object { $_.RecordCount -gt 0 }

foreach ($log in $logs) {
    try {
        [System.Diagnostics.Eventing.Reader.EventLogSession]::GlobalSession.ClearLog(
            $log.LogName
        )

        Write-Host "[CLEARED] $($log.LogName)" -ForegroundColor Green
    }
    catch {
        Write-Host "[FAILED] $($log.LogName) : $($_.Exception.Message)" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Event Logs cleaning completed!" -ForegroundColor Cyan
