    function start-autoweb {
    
        [cmdletbinding()]

        param(
            $url,
            [switch]$headless,
            [switch]$withProfile
            #$chromedriver = $global:ChromeDriver
        )

        if($url -match "^https://.+") {
            write-host "dog"        
        }
        else{
            $url = "https://$url"
        }

        # Remove the scheme and authority (http://, https://, and www.) from the URL
        $cleanedUrl = $url -replace '^https?://(www\.)?', ''

        # Get the first word of the URL
        $firstWord = $cleanedUrl.Split('/')[0]

        # Print the first word
        $searchword = $firstWord.replace(".com","")

        try{
            #if there is a chromedriver swich to chatgpt tab
            try{
                # Find the first tab that contains "smule" in its URL
                $desiredtab=$chromedriver.WindowHandles | Where-Object {$chromedriver.SwitchTo().Window($_).Url -match "$($searchword)"} | Select-Object -First 1
                #$desiredtab
                $null=$chromedriver.SwitchTo().Window($desiredtab)
            }
            catch{
                # Open a new tab with smule and login
                $chromedriver.ExecuteScript("window.open('$($url)', '_blank');")
                $null=$chromedriver.SwitchTo().Window($chromedriver.WindowHandles[-1])
                $ChromeDriver.url
            }
        }

        catch{
            
            #if(!($Credential)){$global:credential = get-credential -user "null" -Message "Enter Password"}
            #$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.Password)
            #$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

            # Your working directory
            $workingPath = 'C:\selenium'

            # Add the working directory to the environment path.
            # This is required for the ChromeDriver to work.
            if (($env:Path -split ';') -notcontains $workingPath) {
                $env:Path += ";$workingPath"
            }

            # OPTION 1: Import Selenium to PowerShell using the Add-Type cmdlet.
            Add-Type -Path "$($workingPath)\WebDriver.dll"

            # Create a new ChromeDriver Object instance.
            $ChromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
            if($headless){
                $ChromeOptions.AddArguments(@(
                    #"--disable-extensions",
                    #"--safebrowsing-disable-download-protection",
                    #"--safebrowsing-disable-extension-blacklist",
                    ,"--disable-download-protection"
                    #"--disable-notifications",
                    #"--ignore-certificate-errors",
                    ,"--headless"
                    #"--disable-gpu",
                    #"--no-sandbox",
                    #"--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/537.36"
                    #"--start-maximized",
                    #"--user-data-dir=$chromeProfileDirectory"
                ))
            }
            #else{
                #$ChromeOptions.AddArguments(@(
                    #"--disable-extensions",
                    #"--safebrowsing-disable-download-protection",
                    #"--safebrowsing-disable-extension-blacklist",
                    #"--disable-download-protection",
                    #"--disable-notifications",
                    #"--ignore-certificate-errors",
                    #"--disable-gpu",
                    #"--no-sandbox",
                    #"--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.0.0 Safari/537.36"
                    #"--start-maximized"
                #))
            #}

            if ($withProfile){
                # Set the path to the user data directory containing the default profile
                #$chromeProfileDirectory = "C:\Users\SirBd0ne\AppData\Local\Google\Chrome\User Data\default"  # Adjust the path as needed
                $chromeProfileDirectory = "C:\temp\profile\"

                # Create Chrome options with the UseExistingProfile capability
                #$chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions
                $chromeOptions.AddArgument("user-data-dir=$chromeProfileDirectory")
                #$chromeOptions.AddArgument("--disable-extensions")
                #$chromeoptions.AddArgument("--defaultdownloadpath c:\temp")
                $chromeoptions.AddArgument("--profile-directory=default") #'C:\temp\profile'")
                $ChromeOptions.AddArgument("--disable-infobars")
                #$chromeOptions.AddArgument("--no-startup-window")
                # Set the "excludeSwitches" option

            }

            #$chromeOptions.AddAdditionalCapability("useAutomationExtension", $false)
            $chromeService = [OpenQA.Selenium.Chrome.ChromeDriverService]::CreateDefaultService()
            $chromeService.HideCommandPromptWindow = $true
            $global:chromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeService, $chromeOptions)

            # Start a new Chrome browser session with the configured options
    #$global:chromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromedriverpath, $DesiredCapabilities)



            #maximize window
            #$ChromeDriver.Manage().window.maximize()
            Start-Sleep 5
            # Launch a browser and go to URL
            $url
            $global:ChromeDriver.Navigate().GoToURL($url)
            #start-sleep -Seconds 5
            #return $chromedriver
        } #end catch

    }

