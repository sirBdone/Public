# Import the Excel files using Import-Excel (replace with your file paths)
$oldExcel = Import-Excel -Path "Path\to\OldExcelFile.xlsx"
$newExcel = Import-Excel -Path "Path\to\NewExcelFile.xlsx"

# Specify the column name for the Description column
$descriptionColumnName = "Description"

# Create an empty array to store the merged data
$mergedExcel = @()

# Create a hashtable to track the descriptions from $oldExcel
$oldDescriptions = @{}

# Add rows from $oldExcel to $mergedExcel
foreach ($oldRow in $oldExcel) {
    $oldDescriptions[$oldRow.$descriptionColumnName] = $true
    $mergedExcel += [PSCustomObject]$oldRow.PSObject.Properties | ForEach-Object {
        $propName = $_.Name
        [PSCustomObject]@{ $propName = $oldRow.$propName }
    }
}

# Loop through each row in $newExcel
foreach ($newRow in $newExcel) {
    $newDescription = $newRow.$descriptionColumnName

    # Check if the Description value exists in $oldDescriptions
    if (-not $oldDescriptions.ContainsKey($newDescription)) {
        # Add the new row to $mergedExcel
        $mergedExcel += [PSCustomObject]$newRow.PSObject.Properties | ForEach-Object {
            $propName = $_.Name
            [PSCustomObject]@{ $propName = $newRow.$propName }
        }
    }
}

# Apply formatting to the Description column cells in the merged Excel file
$mergedExcel | ForEach-Object {
    $_.$descriptionColumnName = @{
        Text = $_.$descriptionColumnName
        Color = "Yellow"  # You can change the color here
    }
}

# Export the merged Excel file with formatting
$mergedExcel | Export-Excel -Path "Path\to\MergedExcelFile.xlsx" -AutoSize -Show
