function select-netadapter {
    $i=1;$netadapter=$null
    $netadapters = Get-NetAdapter | sort status -Descending | %{
        [pscustomobject]@{
            number = $i;
            name = $_.name;
            description = $_.InterfaceDescription
            status = $_.Status
            macaddress = $_.MacAddress
        }
        $i++
    }
    $netadapters | sort status -Descending | ft -AutoSize | out-host
    $choice=$null;[int]$choice = read-host "write the number of your choice.."
    $selection=$null;$selection=$netadapters[[int]$choice - 1];$global:netadapterselection
    write-host "You chose:`r`n" -ForegroundColor Green |out-host
    Get-NetAdapter | ?{$_.name -eq $selection.name} | Tee-Object -Variable answer
}