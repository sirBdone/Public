function start-autoweb_generic {

    [cmdletbinding()] 

    param(
         $url='google.com'
        ,$browser="chrome"
        ,[switch]$private = $false
        ,[switch]$kiosk = $false
        ,[string]$search = $null
    )

    switch ($browser){
        "chrome" {
            if($global:chromedriver){
                $global:driver = $global:chromedriver
            }
        }
        "firefox" {
            if($global:geckodriver){
                $global:driver = $global:geckodriver           
            }
        }
        "edge" {
            if($global:edgedriver){
                $global:driver = $global:edgedriver
            }
        }
        default {
            $global:driver = $global:chromedriver
        }
    }

    $driver=@('cat')

    if($driver -ne ""){
        
        #fix url if missing the https:// on the front, otherwise use what $url already is. 
        if ($url -match "^https?://.+") {
            write-host 'http[s]:// is present_testing' -ForegroundColor Green
        }
        else{
            $url = "https://$url"
        }

        write-host $url
        $searchword = ($url -split '//')[1]
        write-host "searchword is: $searchword"

        try{
            #going to try to take over the previous window and add a tab if the url has a different domain name, if not, it will make a new window (which may or may not work).
            try{
                $desiredtab = $null
                $desiredtab=($global:driver.WindowHandles | %{$($global:driver.SwitchTo().window($_) | select url,currentwindowhandle)} | ?{$_.url -match "$searchword"} | select -last 1).currentwindowhandle
                #$global:driver.WindowHandles | ?{$global:driver.SwitchTo().window($_).url -match $(($url -split '\.com')[0])} | select -First 1
                
                if($desiredtab -ne $null){
                    $null = $global:driver.SwitchTo().window($desiredtab)
                    $global:driver.Navigate().gotourl($url)
                }
                else{
                    $global:driver.ExecuteScript("window.open('$($url)', '_blank');")
                    $null=$global:driver.SwitchTo().window($global:driver.WindowHandles[-1])
                }
                
            }
            catch{
                $global:driver.ExecuteScript("window.open('$($url)', '_blank');")
                $null=$global:driver.SwitchTo().window($global:driver.WindowHandles[-1])
                $global:driver.url
            }
        }
        catch{
        
            # Switch statement to execute commands based on the browser
            switch ($browser) {
                "chrome" {
                    Write-Host "Opening Chrome browser..."
                    # Your command for opening Chrome goes here
                    $driver = Start-SeChrome -StartURL $url -Maximized -quiet -DisableAutomationExtension -WebDriverDirectory "C:\Selenium" -ProfileDirectoryPath "$env:userprofile\appdata\local\google\chrome\user data\"
                    set-variable -Scope global -Name chromedriver -Value $driver -Force
                }
                "firefox" {
                    Write-Host "Opening Firefox browser..."
                    # Your command for opening Firefox goes here
                    
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
                                $desiredtab=$global:geckodriver.WindowHandles | ?{$global:geckodriver.SwitchTo().window($_).url -match $(($url -split '//' -split '\.com')[1])} | select -First 1
                                #$desiredtab
                                $null = $geckodriver.SwitchTo().window($desiredtab)
                                $geckodriver.Navigate().gotourl($url)
                            }
                            catch{
                                $geckodriver.ExecuteScript("window.open('$($url)', '_blank');")
                                $null=$geckodriver.SwitchTo().window($geckodriver.WindowHandles[-1])
                                #$geckodriver.url
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
                    if($private -and $kiosk){
                        start-autoweb_firefox -url $url -private -kiosk
                    }
                    elseif ($private){
                        start-autoweb_firefox -url $url -private
                    }
                    elseif($kiosk){
                        start-autoweb_firefox -url $url -kiosk
                    }
                    else{
                        start-autoweb_firefox -url $url
                    }
                    set-variable -Scope global -Name geckodriver -Value $driver -Force
                }
                "edge" {
                    Write-Host "Opening Edge browser..."
                    # Your command for opening Edge goes here
                    $driver = Start-SeEdge -StartURL $url -Quiet -Maximized -AsDefaultDriver #-ProfileDirectoryPath "$env:userprofile\appdata\local\google\\user data\" #-DisableAutomationExtension
                    set-variable -Scope global -Name edgedriver -Value $driver -Force
                }
                default {
                    Write-Host "Unsupported browser specified. Opening Chrome by default..."
                    # Your command for opening Chrome goes here
                    $driver = Start-SeChrome -StartURL $url -Maximized -quiet -DisableAutomationExtension -WebDriverDirectory "C:\Selenium\" #-ProfileDirectoryPath "$env:userprofile\appdata\local\google\chrome\user data\" -Incognito
                    set-variable -Scope global -Name driver -Value $driver -Force
                }
            }
        
            #return $driver
        }
    }

    new-alias saw -Value start-autoweb_generic -Force

    if($searchword -match "google.com"){
        if($search -ne $null -and ($search -eq "")){
            $search = read-host "what do you want to search for?";$div = $chromedriver.FindElementByXPath('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/textarea');$div.clear();$div.sendkeys($search + "`r`n")
        }
        elseif($search -match '\w' -and ($search -ne $null)){
            $div = $chromedriver.FindElementByXPath('/html/body/div[1]/div[3]/form/div[1]/div[1]/div[1]/div/div[2]/textarea');$div.clear();$div.sendkeys($search + "`r`n")
        }
    }

    function close-chromedriver {get-process *chrome* | Stop-Process -Force}
    new-alias -Name ccd -Value close-chromedriver -Force
}

# Specify the path to the Firefox executable
#$firefoxPath = "C:\Program Files\Mozilla Firefox\firefox.exe"
# Start Firefox with the specified profile using Start-Process
#Start-Process -FilePath $firefoxPath -ArgumentList $arguments -PassThru -OutVariable driveredge

#chrome opens with profile
#firefox opens without profile (currently)