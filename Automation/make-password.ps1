function read-secretcode {

    param($secretcode=$null,
    [switch]$double)

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Security

    function Get-SecurePassword {

        $form = New-Object System.Windows.Forms.Form
        $form.Text = "Enter Password"
        $form.Width = 300
        $form.Height = 150
        $form.StartPosition = "CenterScreen"
        $form.TopMost = $true  # Ensures the form is always on top

        $label = New-Object System.Windows.Forms.Label
        $label.Text = "Password:"
        $label.AutoSize = $true
        $label.Top = 20
        $label.Left = 10

        $textbox = New-Object System.Windows.Forms.TextBox
        $textbox.Width = 250
        $textbox.Top = 40
        $textbox.Left = 10
        $textbox.UseSystemPasswordChar = $true

        $buttonOK = New-Object System.Windows.Forms.Button
        $buttonOK.Text = "OK"
        $buttonOK.Top = 70
        $buttonOK.Left = 190
        $buttonOK.DialogResult = [System.Windows.Forms.DialogResult]::OK

        $form.Controls.Add($label)
        $form.Controls.Add($textbox)
        $form.Controls.Add($buttonOK)
        $form.AcceptButton = $buttonOK

        # Ensure the form is frontmost and focused
        $form.Add_Shown({ $form.Activate() })

        if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
            return $textbox.Text
        }
    }

    if($double){
        $try1 = Get-SecurePassword
        $try2 = Get-SecurePassword
        if($try1 -eq $try2){
            $secretcode = $try2
        }
        else{
            read-secretcode -double
        }
    }
    else{
        $secretcode = Get-SecurePassword
    }
    
    return $secretcode

}

function read-secretcode_double {

    $try1 = read-secretcode
    $try2 = read-secretcode
    if($try1 -eq $try2){
        return $try2
    }
    else{
        read-secretcode_double
    }
}

function make-password {
    <#
        .OUTPUT
            (base) PS C:\Users\SirBd0ne\AppData\Local\Programs\Ollama> make-password
            WARNING: The version '2.0' of module 'CredentialManager' is currently in use. Retry the operation after closing the applications.
            what name to save credential under? ie. BC Facebook: pillow
            cmdlet Get-Credential at command pipeline position 1
            Supply values for the following parameters:
            enter a secret word that you will always remember or it will be gone forever..: pillow
            vrUgAMThLp8eukQi1WXuXhtR1qfphCr2RgTJLUI7kMo8wFq7h9+PsmfctGgy8k+oZVLKVlK0Dxk33u6d0K1KV9sUbaHZqk/fqyqjiP0NL18KkE/rcmkCeKP2jWkqEiCQ


            Flags          : 0
            Type           : Generic
            TargetName     : pillow
            Comment        : pillow
            LastWritten    : 9/1/2024 2:22:49 AM
            PaswordSize    : 280
            Password       : vrUgAMThLp8eukQi1WXuXhtR1qfphCr2RgTJLUI7kMo8wFq7h9+PsmfctGgy8k+oZVLKVlK0Dxk33u6d0K1KV9sUbaHZqk/fqyqjiP0NL18KkE/rcmkCeKP2jWkqEiCQ
            Persist        : LocalMachine
            AttributeCount : 0
            Attributes     : 0
            TargetAlias    : 
            UserName       : pillow

        .COMMENTS 
            notice that the password isn't stored in clear text. so if you do get-storedcredential the password still needs the secretcode to retrieve the password in that manner. 
            an added layer of security...
    #>

    param(
        [string]$credentialname,
        [string]$secretcode = $null
    )
    
    try{
        if(!(get-module credentialmanager -ErrorAction SilentlyContinue)){
            Install-Module CredentialManager -force
        }

        $credential = $null
        
        if(!($credentialname)){
            $credentialname = read-host "what name to save credential under? ie. BC Facebook"
            try{
                $credential = (get-storedcredential -Target $credentialname -AsCredentialObject -ea Stop).password
            }catch{write-error $error[0];break}
        }
        
        if(!($credential)){
            $credential = get-credential
        }

        if(!($credential)){write-error "no credential";break}

        if ([string]::IsNullOrEmpty($secretcode)) {
            try{
                $secretcode = read-secretcode -double
            }
            catch{}
        }

        if(!($credential.name)){
            $usernamecred = read-multiline -WindowTitle "enter a username for cred"
        }
        else{
            $usernamecred = $credential.name
        }

        . C:\Users\SirBd0ne\Documents\GitHub\PScode\Automation\SECRETCODES.ps1

        #[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($credential.Password))
        $encryptedpassword = (encode -messageIn $credential.getnetworkcredential().password ) #-secretcode $secretcode)

        start-process powershell.exe -argumentlist "-Command New-StoredCredential -Target $credentialname -UserName $usernamecred -Password $encryptedpassword -Comment $credentialname -Persist LocalMachine -Type Generic -ea Stop" -NoNewWindow -wait
        
    }
    catch{
        write-error "Something happened in main block"
    }
}

function remove-password {
    
    try{
        
        $credentialname = read-host "what is the name of the credential you're looking for?"
        if(!($credentialname)){write-error "no credential name..";break}

        $curcred = Get-StoredCredential -Target $credentialname 
        
        if(!($curcred)){
            write-error "no credential found by that name.."
            break
        }
        elseif($curcred){
            
            write-host "is this it?" | out-host
            $curcred | out-host 
            $answer=$null
            $answer = read-host "yes or no"

            if($answer -match 'yes'){
            
                write-host "removing stored credential" -ForegroundColor Red | out-host
                Remove-StoredCredential -target $credentialname
            }
        }
    }
    catch{
        write-error "there was a problem removing said credential"
    }
}

function get-password {
    
    [cmdletbinding()]
    
    param(
        [string]$credentialname = $null
        ,[string]$secretcode = $null
    )

    if($secretcode -eq $null){
        $secretcode = read-secretcode
    }

    try{

        if(!($credentialname)){
            $credentialname = read-secretcode
        }
        else{
                    
            $password = (decode $(credentialmanager\get-storedCredential -Target $credentialname -AsCredentialObject).Password -secretcode $secretcode)
            #decode $((get-storedcredential | ?{$_.TargetName -match $credentialname}).password | out-null;
            #[System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($curcred.Password))) -secretcode $($secretcode)

            return $password
        
        }
    }catch{
        write-error "the credential was not found"
    }
}

function Set-PersistentSecretCode {
    param (
        [Parameter(Mandatory = $true)]
        [string]$SecretCode
    )

    # Set the environment variable for the current session
    [System.Environment]::SetEnvironmentVariable('secretcode', $SecretCode, [System.EnvironmentVariableTarget]::Process)

    # Set the environment variable permanently for the user
    [System.Environment]::SetEnvironmentVariable('secretcode', $SecretCode, [System.EnvironmentVariableTarget]::User)

    Write-Host "Environment variable 'secretcode' has been set and will persist across sessions."
}
