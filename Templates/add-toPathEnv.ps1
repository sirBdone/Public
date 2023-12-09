# Specify the paths to the script directories
$scriptPaths = @(
    
    #'C:\Users\SirBd0ne\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.10_qbz5n2kfra8p0\LocalCache\local-packages\Python310\Scripts'
    
    'C:\Users\SirBd0ne\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.10_qbz5n2kfra8p0\LocalCache\local-packages\Python310\Scripts'
    
    # Add paths to other script directories if needed
)

# Add each script directory to the PATH environment variable
foreach ($path in $scriptPaths) {
    if (-Not (Test-Path -Path $path)) {
        Write-Host "Directory not found: $path"
        continue
    }

    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)
    if ($currentPath -notlike "*$path*") {
        $newPath = "$currentPath;$path"
        [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Added $path to PATH."
    } else {
        Write-Host "$path is already in PATH."
    }
}

#'C:\Users\SirBd0ne\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.10_qbz5n2kfra8p0\LocalCache\local-packages\Python310\Scripts'