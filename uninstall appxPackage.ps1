# Get a list of all installed Windows apps
$apps = Get-AppxPackage | Select-Object Name | sort name

# Display the list of apps
Write-Host "List of installed Windows apps:"
$index = 1
$apps | ForEach-Object {
    Write-Host "$index. $($_.Name)"
    $index++
}

# Prompt the user to select an app
$selectedIndex = Read-Host "Enter the number of the app you want to uninstall"

# Validate user input
if ($selectedindex -ge 1 -and $selectedindex -le $apps.Count) {
    $selectedApp = $apps[$selectedindex - 1].Name
    Write-Host "You selected: $selectedApp"

    # Prompt the user for confirmation
    $confirmation = Read-Host "Are you sure you want to uninstall $selectedApp? (Y/N)"

    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        # Uninstall the selected app
        Get-AppxPackage -Name $selectedApp | Remove-AppxPackage
        Write-Host "$selectedApp has been uninstalled."
    } else {
        Write-Host "Uninstallation cancelled."
    }
} else {
    Write-Host "Invalid selection. Please enter a valid number."
}
