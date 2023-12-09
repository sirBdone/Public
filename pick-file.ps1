Function Pick-File {
Add-Type -TypeDefinition @"
            using System;
            using System.Windows.Forms;
"@

    $fileDialog = New-Object Windows.Forms.OpenFileDialog
    $fileDialog.Title = "Select a file"
    
    $result = $fileDialog.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        return $fileDialog.FileName
    } else {
        return $null
    }
}

