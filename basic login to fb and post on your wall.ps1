function fbpost{

<#
    created for using new selenium with my start-autoweb script - concept to use read-hostmultilineinputboxdialog 
    to open a browser window, log into facebook, and post -message $string or if you
    use -long it will open read-multi... and allow you to type or paste it there.
    Obviously, this script could be a lot more robust, but it's just to show you how to get
    started. You can modify it to whatever you like, once you learn how to grab xpath and basic 
    web manipulation of the window. 

    Could potentially break, and won't be updated unless I feel like it, but this is a template basically. 
    Treat it like a learning model to see how to enter login, password, type in a box, hit enter and close the browser. 

    Pieces you need is C:\Selenium folder with Webdriver.dll version 3.1.4.1 or the new 4.0+;
    Chromedriver or msedgedriver.exe for your browser verison (updates a lot, so get used to grabbing out of the zip file and drop it in your c:\selenium folder.
    My start-autoweb script in this repository, which I will update shortly with my latest version. 
    
    

#>
    
    [cmdletbinding()]

    param(
        [string]$message = "what AM I thinking?!? UwU",
        [switch]$long #,
        #[switch]$chatgpt,
        #$answer
    )

    if($long){Read-MultiLineInputBoxDialog -Message "Enter FB Post"}
    #if($chatgpt){$message = "ChatGPT Response:`r`n$($answer.question)`r`n$($answer.answer)"}

    if(!($global:chromedriver)){
        
        #open new tab or entire new automated browswer
        start-autoweb -url "https://facebook.com" -headless  
        
        # Launch a browser and go to URL
        $ChromeDriver.Navigate().GoToURL('https://facebook.com/login/')

        # Enter the username in the Username box
        $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="email"]')).SendKeys('$email')
        //*[@id="m_login_email"]

        # Enter the password in the Password box
        $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="pass"]')).SendKeys('$password')

        # Click on the Login button
        $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="loginbutton"]')).click()

        start-sleep -seconds 6

    }
    else{
        try{
            # Find the first tab that contains "smule" in its URL
            $desiredTab = $chromedriver.WindowHandles | Where-Object {$chromedriver.SwitchTo().Window($_).Url -like "*facebook*"} | Select-Object -First 1
            #$ChromeDriver.url
            if(!($ChromeDriver.url -ne "https://www.facebook.com/home.php")){
                $global:ChromeDriver.Navigate().GoToURL('https://www.facebook.com/home.php')
                wait 3
            }
        }catch{}

    }
    # Click on the SEARCH menu item
    $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('/html/body/div[1]/div/div[1]/div/div[3]/div/div/div/div[1]/div[1]/div/div[2]/div/div/div/div[3]/div/div[2]/div/div/div/div[1]/div/div[1]/span')).click()
    start-sleep -Seconds 3
    #send msg
    $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('/html/body/div[1]/div/div[1]/div/div[4]/div/div/div[1]/div/div[2]/div/div/div/form/div/div[1]/div/div/div/div[2]/div[1]/div[1]/div[1]/div/div/div[1]/p')).click()
    Start-Sleep 1
    #//*[@id="jsc_c_5c"]//*[@id="mount_0_0_wg"]/div[1]/div[1]/div/div[5]/div/div[1]/div[2]/span/div
    $element = $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('/html/body/div[1]/div/div[1]/div/div[4]/div/div/div[1]/div/div[2]/div/div/div/form/div/div[1]/div/div/div/div[2]/div[1]/div[1]/div[1]/div/div/div[1]/p'))
    $element.sendkeys("$message")
    start-sleep 2
    #$ChromeDriver.SwitchTo($element)
    #$element.SendKeys([OpenQA.Selenium.Keys]::down)
    $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('/html/body/div[1]/div/div[1]/div/div[4]/div/div/div[1]/div/div[2]/div/div/div/form/div/div[1]/div/div/div/div[2]/div[1]/div[1]/div[1]/div/div/div[1]/p')).SendKeys([OpenQA.Selenium.Keys]::enter)
    Start-Sleep 1
    #$chromedriver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="mount_0_0_wg"]/div[1]/div[1]/div/div[5]/div/div[1]/div[1]/div/div/div/div/div/div[2]/div[2]/div/div[2]/div/div/div/div[4]/div[2]/div/div/div[1]/p')).SendKeys('damn, i finally got this working')
    #$chromedriver.FindElement([OpenQA.Selenium.By]::XPath('//*[@id="mount_0_0_wg"]/div[1]/div[1]/div/div[5]/div/div[1]/div[1]/div/div/div/div/div/div[2]/div[2]/div/div[2]/div/div/div/div[4]/div[2]/div/div/div[1]/p')).SendKeys([OpenQA.Selenium.Keys]::enter)
    $chromedriver.FindElement([OpenQA.Selenium.By]::XPath('/html/body/div[1]/div/div[1]/div/div[4]/div/div/div[1]/div/div[2]/div/div/div/form/div/div[1]/div/div/div/div[3]/div[2]/div/div')).click()

}


