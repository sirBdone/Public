$uninstallKeyPath = "Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall"

$uninstallKeys = Get-ChildItem -Path $uninstallKeyPath

$output = @()

$output = foreach ($key in $uninstallKeys) {
    $displayName = (Get-ItemProperty -Path $key.PSPath).DisplayName
    $installdate = (Get-ItemProperty -Path $key.PSPath).installdate
    $uninstallstring = (Get-ItemProperty -Path $key.PSPath).uninstallstring
    $versionmajor = (Get-ItemProperty -Path $key.PSPath).versionmajor
    $versionminor = (Get-ItemProperty -Path $key.PSPath).versionminor

    if ($displayName) {
        $customObject = New-Object -TypeName PSObject -Property @{
            displayname = "$displayName"
            installdate = "$installdate"
            uninstallstring = "$uninstallstring"
            versionmajor = "$versionmajor"
            versionminor = "$versionminor"
        }

    } #endif
    
    $customObject | select displayname,installdate,uninstallstring,versionmajor,versionminor

}#end foreach

$output | ft -AutoSize
