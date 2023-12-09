# Set path variables for PowerShell file types
$Path1 = 'Registry::HKEY_CLASSES_ROOT\.ps1'
$Path2 = 'Registry::HKEY_CLASSES_ROOT\.psm1'
$Path3 = 'Registry::HKEY_CLASSES_ROOT\.psd1'

# Enable preview of those file types
New-ItemProperty -Path $Path1 -Name PerceivedType -PropertyType String  -Value 'text'
New-ItemProperty -Path $Path2 -Name PerceivedType -PropertyType String  -Value 'text'
New-ItemProperty -Path $Path3 -Name PerceivedType -PropertyType String  -Value 'text'