# Import the Excel files using Import-Excel (replace with your file paths)
$oldExcel = Import-Excel -Path "Path\to\OldExcelFile.xlsx"
$newExcel = Import-Excel -Path "Path\to\NewExcelFile.xlsx"

# Specify the column name for the Description column
$descriptionColumnName = "Description"

# Initialize an array to store the differences
$differences = @()

# Loop through each row in $newExcel
foreach ($newRow in $newExcel) {
    # Get the Description value for the current row in $newExcel
    $newDescription = $newRow.$descriptionColumnName
    
    # Check if the Description value exists in $oldExcel
    $descriptionExistsInOld = $oldExcel | Where-Object { $_.$descriptionColumnName -eq $newDescription }

    # If the Description value is not found in $oldExcel, add it to the differences array
    if (-not $descriptionExistsInOld) {
        $differences += $newRow
    }
}

# Add the new rows from $newExcel to $oldExcel
$oldExcel += $differences

# Apply formatting to the Description column cells in the merged Excel file
$oldExcel | ForEach-Object {
    $_.$descriptionColumnName = @{
        Text = $_.$descriptionColumnName
        Color = "Yellow"  # You can change the color here
    }
}

# Export the merged Excel file with formatting
$oldExcel | Export-Excel -Path "Path\to\MergedExcelFile.xlsx" -AutoSize -Show
