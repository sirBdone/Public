#function update-chromedriver {
    get-Process chromedriver | Stop-Process
    
    $web = Invoke-WebRequest -Uri 'https://googlechromelabs.github.io/chrome-for-testing/'
    $matches = $web.ParsedHtml.body.ihtmlelement_outertext | select-string -Pattern '(?<=stable)(.*)+(?=\b)';$version = ($matches.Matches.value -split 'r')[0];

    write-host "version is: $version"
    write-host "url is $url"

    # Define the URL of the ChromeDriver ZIP file
    $Url = "https://storage.googleapis.com/chrome-for-testing-public/$version/win64/chromedriver-win64.zip"

    # Define the path where the ZIP file will be downloaded
    $DownloadPath = "$env:USERPROFILE\downloads\chromedriver.zip"
    
    # Download the ZIP file
    Invoke-WebRequest -Uri $Url -OutFile $DownloadPath

    # Extract the ZIP file to the download folder
    Expand-Archive -Path $DownloadPath -DestinationPath 'C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies\' -Force
        copy-item 'C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies\chromedriver-win64\chromedriver.exe' -Destination "C:\Program Files\WindowsPowerShell\Modules\Selenium\3.0.1\assemblies\" -force
    Expand-Archive -Path $DownloadPath -DestinationPath 'C:\selenium\' -Force
        copy-item "C:\Selenium\chromedriver-win64\chromedriver.exe" -Destination "C:\Selenium\" -Force

    try{
        # Clean up the downloaded ZIP file
        Remove-Item $DownloadPath
    }
    catch{}


    try{
        start-autoweb_generic google.com
    }
    catch{write-error -Message "Update didn't work, might have to do each step manually to verify it works."}

#}