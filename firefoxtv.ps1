function close-firefox{
    get-process | ?{$_.Name -match "gecko|firefox"} | Stop-Process -Force
}

new-alias -Name cff -Value close-firefox -Force

function firefox-tv {
    
    [cmdletbinding()]

    param(
        [switch]$clear
    )

    if($clear){
        cff
    }

    $url = "https://thetvapp.to"
    
    if(!($global:tvmenu)){

        if(!($geckodriver.url -match "$url")){
            start-autoweb_firefox -url 'https://thetvapp.to/'
        }
        else{
            $geckodriver.Navigate().gotourl($url)
        }

        

        $i=1;
        $global:tvmenu = ($geckodriver.FindElementsByXPath('/html/body/div/div[1]/div/ol/a')) | %{
            [pscustomobject]@{
                number=$i;
                name=$_.text;
                url=$_.getproperty('href')
            }
        $i++
        };
    
        $global:tvmenu | out-host; #ogv -PassThru -outvariable selection;

        $search = read-host "what number or channel do you want?";

        #if(!$selection){
            $selection = if ($search -match '\d'){
                $global:tvmenu[$search-1]}else{$global:tvmenu | ?{$_ -match $search}
            }
        #}
        #else{
        #    $global:menu=$selection
        #};

        }
        else{
            $global:tvmenu | ogv -PassThru -outvariable selection
        }

        $selection | out-host;

        if($selection.count -gt 1){
            $i=1;$selection|%{$_.number=$i;$i++};
            $selection|out-host;
            $search = read-host "which number";
            if($selection -match "\d"){
                $selection[$search-1]
            }
            else{
                write-error -Message "too many choices left, be more unique, use the numbers if you can..";break
            }
        }
        else{
            $url = $selection.url
        }

        if($url){    
            if($geckodriver.url -match 'https://thetvapp.to'){$geckodriver.Navigate().gotourl($url)}
            else{start-autoweb_firefox -url $url }
        }        


        #start-sleep -Seconds 3
        do{start-sleep -Seconds 1}until(
            $geckodriver.FindElementByXPath('/html/body/div/div/div[1]/div[2]/div[2]/div[13]/div[1]/div/div/div[2]/div').click()
        )

        $geckodriver.FindElementByXPath('/html/body/div/div/div[1]/div[2]/div[2]/div[4]/video').sendkeys('f')

        new-alias fftv -value firefox-tv -force

}