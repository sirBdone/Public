#list files you want to compare
$compare1 = "$env:userprofile\Downloads\7z2301-extra (1).7z"
$compare2 = "$env:userprofile\Desktop\3rd party software\Chrome\ChromeStandaloneSetup64.exe"

#create empty filehash array
$filehashes = @()

# Calculate the checksum of the file
$filehash1 = Get-FileHash -Path $compare1 -Algorithm MD5
$filehash2 = Get-FileHash -path $compare2 -Algorithm MD5

#grab all variables of $file and save as array
$filehashes = get-variable -name filehash* | select -SkipLast 1 

#display table correctly
$filehashes = $filehashes | select @{n='name';e={($_.value.path | split-path -leaf)}},@{n='hash';e={$_.value.hash}},@{n='variable';e={$_.name}} |ft
$filehashes

#compare hashes and return isMatch?
if($filehash1 -eq $filehash2){
    write-host -ForegroundColor Green "They are a Match!!"
    
}
else{
    write-host -ForegroundColor Red "Does Not Match!!"
}
