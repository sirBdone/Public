#search for java 

# Check if the Scheduled Task exists, and if not, create it
$taskName = "SearchForJava"
$taskExists = Get-ScheduledTask | Where-Object {$_.TaskName -eq $taskName}

if (-not $taskExists) {
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File 'C:\Path\To\YourScript.ps1'"
    $trigger = New-ScheduledTaskTrigger -At 2:00AM -Daily
    $principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
    $settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -DontStopIfIdle -DontStopIfNetworkAvailable -StartWhenAvailable
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -User "NT AUTHORITY\SYSTEM" -TaskPath "\" -Principal $principal -Settings $settings
}

# Perform the file search and log the results
$date = Get-Date -Format "yyyyMMdd_HHmmss"
$logFile = "C:\temp\java_$date.csv"
$regexPattern = ".*\\.*java.*"

Get-ChildItem -Recurse -File | Where-Object { $_.Name -match $regexPattern } | ForEach-Object {
    Add-Content -Path $logFile -Value "$($_.Name),$($_.FullName),$date"
}

