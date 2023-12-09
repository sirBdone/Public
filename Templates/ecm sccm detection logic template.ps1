Function Get-FileMetaData {

Param([string[]]$folder)

foreach($sFolder in $folder){
    $a = 0
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.namespace($sFolder)

    foreach ($File in $objFolder.items()){
        $FileMetaData = New-Object PSOBJECT
        for ($a ; $a -le 266; $a++){
            if($objFolder.getDetailsOf($File, $a)){
                $hash += @{$($objFolder.getDetailsOf($objFolder.items, $a)) = $($objFolder.getDetailsOf($File, $a)) }
                $FileMetaData | Add-Member $hash
                $hash.clear()
                } #end if
            } #end for
            $a=0
            $FileMetaData
        } #end foreach $file
    } #end foreach $sfolder
} #end Get-FileMetaData

$TemplateVersions = "5.0.2"

$wordStandards = "C:\Program Files (x86)\Customer\Customer Word Standards"
$wordTemplates = "C:\Program Files (x86)\Microsoft Office\Templates"
$wordTheme = "C:\Program Files (x86)\Microsoft Office\Document Themes 14\Theme Colors"
$excelAddins = "C:\Program Files (x86)\Customer\Customer Excel Addins"
$xlRibbon = "C:\Program Files (x86)\Microsoft Office\Office14\ADDINS"
$PPTribbon = "C:\Program Files (x86)\Customer\PowerPoint Templates"
$PPTtemplates = "C:\Program Files (x86)\Microsoft Office\Templates\Customer"

$strFile1 = "Bridge Template.xlsm"
$strFile2 = "Excel Ribbon.xlam"
$strFile3 = "NormalEmail.dotm"
$strFile4 = "PPT Ribbon.ppam"
$strFile5 = "Client Pitch.potx"
$strFile6 = "Client Presentation.potx"
$strFile7 = "Client Report.potx"
$strFile8 = "Blank.potx"
$strFile9 = "Blocks.dotx"
$strFile10 = "Normal.dotm"

$Path = @()
$Collection = @()

$Path += "$excelAddins\$strfile1"
$Path += "$xlRibbon\$strfile2"
$Path += "$PPTribbon\$strfile3"
$Path += "$PPTtemplates\$strfile4"
$Path += "$PPTtemplates\$strfile5"
$Path += "$PPTtemplates\$strfile6"
$Path += "$wordStandards\$strfile7"
$Path += "$excelAddins\$strfile8"
$Path += "$xlRibbon\$strfile9"
$Path += "$PPTribbon\$strfile10"

if (Test-Path $wordStandards) {
    $fileMD = Get-FileMetaData -folder $wordStandards
    $collection += $fileMD | select path, company
}
if (Test-Path $wordTemplates) {
    $fileMD = Get-FileMetaData -folder $wordTemplates
    $collection += $fileMD | select path, company
}
if (Test-Path $wordTheme) {
    $fileMD = Get-FileMetaData -folder $wordTheme
    $collection += $fileMD | select path, company
}
if (Test-Path $excelAddins) {
    $fileMD = Get-FileMetaData -folder $excelAddins
    $collection += $fileMD | select path, company
}
if (Test-Path $xlRibbon) {
    $fileMD = Get-FileMetaData -folder $xlRibbon
    $collection += $fileMD | select path, company
}
if (Test-Path $PPTribbon) {
    $fileMD = Get-FileMetaData -folder $PPTribbon
    $collection += $fileMD | select path, company
}
if (Test-Path $PPTtemplates) {
    $fileMD = Get-FileMetaData -folder $PPTtemplates
    $collection += $fileMD | select path, company
}
$OKCounter = 0
for ($i=0; $i -lt $Path.length; $i++) {
    foreach ($obj in $collection) {
        If ($Path[$i] -eq $obj.path -and $obj.company -eq $TemplateVersions) {
            $OKCounter++
        }
    }
}
if ($OKCounter -eq $path.length) {
    write-host "all files accounted for!"
}