# List all available monitors
$monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorBasicDisplayParams

# Set monitors 1 and 4 to extend, while disabling the others
foreach ($monitor in $monitors) {
    $monitorID = $monitor.InstanceName -replace "DISPLAY\\", ""
    $monitorNumber = $monitorID

    if ($monitorNumber -eq 1 -or $monitorNumber -eq 4) {
        Set-DisplayConfig -Path @($monitorID) -Mode Extend
    } else {
        Set-DisplayConfig -Path @($monitorID) -Mode Disconnect
    }
}

# Apply the display configuration
Start-Process -FilePath "DisplaySwitch.exe" -ArgumentList "/extend"

# Sleep for a few seconds to allow the changes to take effect
Start-Sleep -Seconds 5



# Get the list of all available displays
$displays = Get-WmiObject -Namespace "root\cimv2" -Class Win32_DesktopMonitor

# Disable all displays except the second one
for ($i = 0; $i -lt $displays.Count; $i++) {
    if ($i -ne 1) {
        $displays[$i].SetDeviceState(4)
    }
}

# Refresh the desktop to apply the changes
rundll32.exe user32.dll,UpdatePerUserSystemParameters


# Get the list of active monitors
$monitors = Get-WmiObject -Namespace "root\wmi" -Class WmiMonitorID

# Define the display number you want to keep enabled (index 1 for the second display)
$enabledDisplayNumber = 1

# Loop through all monitors and disable those that are not the specified index
for ($i = 0; $i -lt $monitors.Count; $i++) {
    if ($i -ne $enabledDisplayNumber) {
        $monitors[$i].Active = $false
        $monitors[$i].Put()
    }
}

# Trigger the display switch to apply the changes
Start-Process -FilePath "DisplaySwitch.exe" -ArgumentList "/internal"

Write-Host "Only Monitor $enabledDisplayNumber is enabled."


#============================================#

# Mirror the second monitor (index 1) to other monitors
$displaySettings = (New-Object -ComObject shell.application).Namespace(0x7)

# Select the second monitor (index 1) as the main display
$displaySettings.Items() | ForEach-Object {
    if ($_.Name -eq "Monitor 2") {
        $_.InvokeVerb("Set as Main Monitor")
    }
}

# Mirror the second monitor to other displays
$displaySettings.Items() | ForEach-Object {
    if ($_.Name -ne "Monitor 2") {
        $_.InvokeVerb("Duplicate")
    }
}

Write-Host "Monitor 2 is the only one enabled."








