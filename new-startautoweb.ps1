function new-startautoweb {

<#

        .SYNOPSIS
        Starts a Chrome browser automatically, with $global:chromedriver to manipulate the page to navigate, fill forms, scrape, etc.

        .DESCRIPTION
        Will check to see if you currently have a $chromedriver window open, then will search for url in current tabs. If a similar url is already open,
        it will open the $url in that tab, otherwise it will open a new tab and navigate to that tab; and finally, if no $chromedriver exists, then 
        it will open up a new browser and assign it to $global:chromedriver, meaning after this fn runs, you will have a scriptable $variable to
        look for DOM objects, and manipulate with .click(), .clear(), .navigate().gotourl("$url"), etc.

        .PARAMETER chromedriver
        The variable that has all of the webbrowser's information in it. Set as $global:chromedriver, it will be available after this fn finishes running.

        .PARAMETER url
        You can assign url as google.com, spotify.com/etc or https://google.com, https://spotify.com/etc/etc

        .EXAMPLE
        new-startautoweb -url google.com
        new-startautoweb spotify.com/etc/etc.html

        .NOTES
        Name: new-startautoweb
        Author: Brandon Carey
        Version 2.3
        LastDateModified: 12/9/2023 4:12am

#>

    [cmdletbinding()]

    param(
    
        [string]$url

    )    

    if($global:chromedriver){
        $chromedriver = $global:chromedriver
    }

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
