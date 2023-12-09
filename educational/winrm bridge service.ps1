# Check if running with administrative permissions
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "This script needs to be run as an administrator"
    return
}

# Start the WinRM Bridge service
try {
    $service = Get-Service -Name WMBridge -ea stop
    if ($service.Status -eq "Stopped") {
        Start-Service -Name $service.Name
        Write-Host "WinRM Bridge service started successfully"
    }
    else {
        Write-Host "WinRM Bridge service is already running"
    }
}
catch {
    Write-Host "Failed to start WinRM Bridge service: $_. Please check if you have the permissions to start this service."
}