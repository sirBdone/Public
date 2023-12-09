function pick-folder {
    $ErrorActionPreference = "silentlycontinue"

    Add-Type -TypeDefinition @"
        using System;
        using System.Windows.Forms;
"@

    # Add-Type using the full path
    Add-Type -AssemblyName PresentationFramework
    Add-Type -Assembly $assemblyPath

    $folderBrowser = New-Object Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Select a folder"
    $folderBrowser.RootFolder = [System.Environment+SpecialFolder]::MyComputer

    $result = $folderBrowser.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFolder = $folderBrowser.SelectedPath
        #Write-Host "You selected: $selectedFolder"
        $global:selectedfolder=$selectedfolder
    } else {
        Write-Host "No folder selected."
    }
    return $selectedFolder
}