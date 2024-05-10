function start-autoweb_firefox {

    [cmdletbinding()] 

    param(
        $url
        ,$geckodriver=$global:geckodriver
        ,[switch]$private=$false
        ,[switch]$kiosk=$false
    )

    if ($url -match "^https?://.+") {
        write-host 'http[s]:// is present_testing' -ForegroundColor Green
    }
    else{
        $url = "https://$url"
    }
    $global:url = $url
    if($global:geckodriver.url -ne $null){
        try{
            $desiredtab = $null
            $desiredtab=($global:geckoglobal:geckodriver.WindowHandles | %{$($global:geckoglobal:geckodriver.SwitchTo().window($_) | select url,currentwindowhandle)} | ?{$_.url -match "$searchword"} | select -last 1).currentwindowhandle
            #$global:geckodriver.WindowHandles | ?{$global:geckodriver.SwitchTo().window($_).url -match $(($url -split '\.com')[0])} | select -First 1
                
            if($desiredtab -ne $null){
                $null = $global:geckodriver.SwitchTo().window($desiredtab)
                $global:geckodriver.Navigate().gotourl($url)
            }
            else{
                $global:geckodriver.ExecuteScript("window.open('$($url)', '_blank');")
                $null=$global:geckodriver.SwitchTo().window($global:geckodriver.WindowHandles[-1])
            }
                
        }
        catch{
            $global:geckodriver.ExecuteScript("window.open('$($url)', '_blank');")
            $null=$global:geckodriver.SwitchTo().window($global:geckodriver.WindowHandles[-1])
            $global:geckodriver.url
        }
    }
    else{
       
        #Start-SeFirefox -Quiet -Arguments "-profile 'C:\\Users\\SirBd0ne\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\jgujttcu.default-release'" #-WebDriverDirectory "c:\selenium"
                
        # Import the Selenium module
        Import-Module Selenium

        # Set the path to the Firefox binary
        $firefoxBinaryPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'

        # Set the path to the custom Firefox profile
        $firefoxProfilePath = 'C:\\Users\\SirBd0ne\\AppData\\Roaming\\Mozilla\\Firefox\\Profiles\\jgujttcu.default-release'

        # Create Firefox options with the specified binary path and profile
        $firefoxOptions = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
        $firefoxOptions.BrowserExecutableLocation = $firefoxBinaryPath
        $firefoxOptions.Profile = $firefoxProfilePath
        if($private){
            $firefoxOptions.AddArgument("-private-window")
        }
        if($kiosk){
            $firefoxOptions.AddArgument("-kiosk")
        }
        # Create the Firefox WebDriver with the specified options
        $geckodriver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($firefoxOptions)

        # Navigate to the Google website
        $geckodriver.Navigate().GoToUrl($url)

        #set global variable
        $global:geckodriver = $geckodriver
        #return $geckodriver
    }

}