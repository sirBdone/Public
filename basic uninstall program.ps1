
# Get the list of all installed software
$InstalledSoftwareList = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName

# Create a numbered list
$Counter = 0
Foreach ($Software in $InstalledSoftwareList) {
    $Counter++
    Write-Host "$Counter. $($Software.DisplayName)"
}

# Ask the user to select an application
$SelectedSoftware = Read-Host "Select the number of the application you would like to remove"

# Get the display name of the selected software
$SelectedSoftwareDisplayName = $InstalledSoftwareList[$SelectedSoftware - 1].DisplayName

# Get the uninstall string for the selected software
$SelectedSoftwareUninstallString = (Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -eq $SelectedSoftwareDisplayName}).UninstallString
# Get the uninstall string for the selected software
$SelectedSoftwareUninstallString2 = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object {$_.DisplayName -eq $SelectedSoftwareDisplayName}).UninstallString

#command array
$commandsuninstaller= @()
# Uninstall the selected software
#$UninstallOutput = Invoke-Expression 
$commandsuninstaller += $SelectedSoftwareUninstallString
#$UninstallOutput = Invoke-Expression 
$commandsuninstaller += $SelectedSoftwareUninstallString

#run uninstall
$commandsuninstaller | select -Unique | %{Invoke-Expression $_}
