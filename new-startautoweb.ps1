function new-startautoweb {

<#

    

#>

    [cmdletbinding()]

    param(
    
        $chromedriver=$global:chromedriver
        ,[string]$url
        ,[switch]$withprofile=$true
        ,[switch]$return
        ,[switch]$se=$false

    )    

    if($url -match "^https?://.+") {
        write-host "URL IS GOOD" -ForegroundColor Green
    }
    else{
        $url = "https://$url"
    }

    if (-not (test-path "C:\temp\chromeprofile\")){
        new-item -Path "c:\temp\" -Name "Chromeprofile" -ItemType Directory
        copy-item -Path "$env:LOCALAPPDATA\Local\Google\Chrome\User Data" -Recurse -Destination c:\temp\chromeprofile\ -Force
        $chromeProfileDirectory = "C:\temp\Chromeprofile\"
    }
            
    try{
        # Find the first tab that contains "smule" in its URL
        $desiredtab=$chromedriver.WindowHandles | Where-Object {$chromedriver.SwitchTo().Window($_).Url -match "$($(($url -split '//' -split ".com")[1]))"} | Select-Object -First 1
        #$desiredtab
        $null=$chromedriver.SwitchTo().Window($desiredtab)
    }
    catch{
        # Open a new tab with smule and login
        $chromedriver.ExecuteScript("window.open('$($url)', '_blank');")
        $null=$chromedriver.SwitchTo().Window($chromedriver.WindowHandles[-1])
        $ChromeDriver.navigate().gotourl($url)
    }

    if($chromedriver -eq $null){
        $chromedriver = $null;$chromedriver = Start-SeChrome -StartURL $url -Arguments '--profile-directory=Default' -ProfileDirectoryPath "c:\temp\chromeprofile" -DisableAutomationExtension -Quiet;$global:chromedriver = $chromedriver
    }

} #end catch
