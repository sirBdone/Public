# Check if the script is running with administrator privileges
$isAdmin = ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # If not running with administrator privileges, relaunch the script with elevated permissions
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    
    # Exit the current instance of the script
    Exit
}

# Define the script file path
$scriptFilePath = "$env:USERPROFILE\Documents\windowsPowerShell\scripts\fix_audiodg_exe_glitchy_sound.ps1"

#define the ps1 to fix the issue and save it to a specified location (dynamic)
$snippet = @'
# Get the audiodg.exe process
$audiodgProcess = Get-Process -Name audiodg -ErrorAction SilentlyContinue

if ($audiodgProcess) {
    # Set process priority to high
    $audiodgProcess.PriorityClass = 'High'

    #Un-needed code
    # Get the current CPU affinity mask
    #$currentAffinity = $audiodgProcess.ProcessorAffinity
    #$newAffinity = [System.IntPtr]::Size * 2  # Create a mask with CPU 2

    # Set CPU affinity to use only CPU 2
    $audiodgProcess.ProcessorAffinity = 4 #$newAffinity

} else {
    Write-output "audiodg.exe isn't running"
}

'@

#define filepath
$filePath = "$scriptFilePath"

#save ps1 file to location
$snippet | Set-Content -Path $filePath

# Define the task name and description
$taskName = "fix_audiodg_exe_glitchy_sound_onLogin"
$taskDescription = "Runs a PowerShell script with administrator rights on user login"

# Create a new scheduled task action
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File `"$scriptFilePath`""

# Create a new scheduled task trigger for user logon with a delay of 1 minute
$trigger = New-ScheduledTaskTrigger -AtLogOn
$trigger.Delay = "PT2M"

# Enable the logon trigger
$trigger.Enabled = $true

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$settings.ExecutionTimeLimit = "PT1M"

# Create a new scheduled task principal for running with highest privileges
$principal = New-ScheduledTaskPrincipal -UserID "`" -LogonType S4U -RunLevel Highest

# Register the scheduled task
Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Description $taskDescription -Settings $settings -Force

Write-Host "Scheduled task created successfully."