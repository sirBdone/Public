function pick-fileFolder {
Add-Type -TypeDefinition @"
    using System;
    using System.Windows.Forms;
"@

    $fileDialog = New-Object Windows.Forms.OpenFileDialog
    $fileDialog.Title = "Select a folder"
    $fileDialog.CheckFileExists = $false
    $fileDialog.ValidateNames = $false
    $fileDialog.FileName = "Folder Selection Placeholder"
    $fileDialog.Filter = "Folders|*.none"

    $result = $fileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $selectedFolder = [System.IO.Path]::GetDirectoryName($fileDialog.FileName)
        #Write-Host "You selected folder: $selectedFolder"
        $global:selectedfolder=$selectedfolder
    } else {
        Write-Host "No folder selected."
    }
}