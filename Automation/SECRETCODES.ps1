<#
 .COMMENTS
    THIS IS SETTING SECRETCODE TO SOMETHING AND ENCRYPTING HOWDY AND THEN DECRYPTING IT TO READ IT USING THE SAME SECRETCODE (CHANGE IT)
    $secretcode = 'cheetahs'

    write-host "The secretmessage is:`r`n" -ForegroundColor Cyan

    encode -messageIn howdy -secretcode $secretcode -OutVariable secretmessage

    write-host "`r`nThe message is:`r`n`r`n" -ForegroundColor Green

    decode -secretmessage $secretmessage -secretcode $secretcode -OutVariable MessageOut

 .EXAMPLE
    THIS IS ENCRYPTING THE CONTENTS OF YOUR CLIPBOARD AND THEN DECODING USING THE STANDARD SECRETCODE (CHANGE IT WITH -SECRETCODE "SOMETHING HERE")
    encode -clipboard
    
    decode -secretmessage $secretmessage

 .OUTPUT
    (base) PS C:\WINDOWS\system32> encode -messageIn hello
    mK63KBa5CplvW3uuVmvmxjN1jjFcMygapYSpyuuHQBdlsyKaMT3+VGdHLAiU4UaOr3xCSOgBh8tcR/CQNOmKc5Kt6vbmc81z+zjZx7cxnCzbamNC/yl

    (base) PS C:\WINDOWS\system32> decode -secretmessage $secretmessage
    hello
#>

function pencrypt {
    <#
        # Example usage:
        $secretmessage = pencrypt -messageToEncrypt "Hello" -secretcode "dolphin"

        $secretmessage | out-host

    #>

    [cmdletbinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string]$messageToEncrypt,
        [Parameter(Mandatory=$true)]
        [string]$secretcode
    )

    . "C:\Users\SirBd0ne\Documents\GitHub\PScode\Automation\make-password.ps1"

    if (-not $messageToEncrypt) {
        Write-Error "Nothing to say"
        return
    }

    if ([string]::IsNullOrEmpty($secretcode)) {
        write-error "`$secretcode can't be empty";
        break
    }

    # Generate a random salt
    $salt = [byte[]]::new(64)
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($salt)

    # Use Rfc2898DerivedBytes class to generate a key
    $keygen = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($secretcode, $salt, 10000)
    $key = $keygen.GetBytes(32)

    # Debugging output
    #Write-Output "Salt: $([BitConverter]::ToString($salt))"
    #Write-Output "Key: $([BitConverter]::ToString($key))"

    # Initialize a new instance of AesGcm passing in the $key to the constructor
    $aesGcm = [System.Security.Cryptography.AesGcm]::new($key)

    # Convert the message to bytes
    $messageBytes = [System.Text.Encoding]::UTF8.GetBytes($messageToEncrypt)

    # Generate the nonce
    $nonce = [byte[]]::new(12)
    [System.Security.Cryptography.RandomNumberGenerator]::Fill($nonce)

    # Debugging output
    #Write-Output "Nonce: $([BitConverter]::ToString($nonce))"

    # Generate the empty byte arrays which will be filled with data during encryption
    $tag = [byte[]]::new(16)
    $assocData = [byte[]]::new(0)
    $cipherText = [byte[]]::new($messageBytes.Length)

    # Encrypt the message
    $aesGcm.Encrypt($nonce, $messageBytes, $cipherText, $tag, $assocData)

    # Combine salt, nonce, tag, and ciphertext into a single byte array
    $result = $salt + $nonce + $tag + $cipherText

    # View the result in Base64
    $secretmessage = ([System.Convert]::ToBase64String($result)).trim()

    return $secretmessage
}

function pdecrypt {
    <#
        $decryptedMessage = pdecrypt -secretmessage $secretmessage -secretcode "poodle"

        $decryptedMessage | out-host
    #>

    [cmdletbinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string]$secretmessage,
        [Parameter(Mandatory=$true)]
        [string]$secretcode
    )

    . "C:\Users\SirBd0ne\Documents\GitHub\PScode\Automation\make-password.ps1"

    if(!($secretmessage)){$secretmessage = read-secretcode}

    if ([string]::IsNullOrEmpty($secretcode)) {
        write-error "`$secretcode can't be empty";
        return
    }

    #Write-Output "Using secret code: $secretcode"

    # Convert the Base64-encoded message back to bytes
    $resultBytes = [System.Convert]::FromBase64String($secretmessage)

    # Extract the salt, nonce, tag, and ciphertext from the result bytes
    $salt = $resultBytes[0..63]
    $nonce = $resultBytes[64..75]
    $tag = $resultBytes[76..91]
    $cipherText = $resultBytes[92..($resultBytes.Length - 1)]

    # Debugging output
    #Write-Output "Salt: $([BitConverter]::ToString($salt))"
    #Write-Output "Nonce: $([BitConverter]::ToString($nonce))"
    #Write-Output "Tag: $([BitConverter]::ToString($tag))"
    #Write-Output "CipherText: $([BitConverter]::ToString($cipherText))"

    # Use Rfc2898DerivedBytes class to generate a key, using the same salt as in pencrypt
    $keygen = [System.Security.Cryptography.Rfc2898DeriveBytes]::new($secretcode, $salt, 10000)
    $key = $keygen.GetBytes(32)

    # Debugging output
    #Write-Output "Key: $([BitConverter]::ToString($key))"

    # Initialize a new instance of AesGcm passing in the $key to the constructor
    $aesGcm = [System.Security.Cryptography.AesGcm]::new($key)

    # Prepare the empty byte array that will hold the decrypted message
    $decryptedBytes = [byte[]]::new($cipherText.Length)
    $assocData = [byte[]]::new(0)

    try {
        # Decrypt the cipherText
        $aesGcm.Decrypt($nonce, $cipherText, $tag, $decryptedBytes, $assocData) | out-null

        # Convert the decrypted bytes back into a string
        $decryptedMessage = ([System.Text.Encoding]::UTF8.GetString($decryptedBytes)).trim()

        return $decryptedMessage
    }
    catch {
        Write-Error "Decryption failed. Ensure that the secretcode is correct."
    }
}

function encode {
    
    [cmdletbinding()]
    
    param(
        [Parameter(Mandatory=$true)]
        [string]$messageIn,
        [string]$secretcode,
        [switch]$clipboard
    )

    if ([string]::IsNullOrEmpty($secretcode)) {
        $secretcode = read-secretcode -double
    }

    if ($clipboard) {
        $messageIn = (Get-Clipboard)
    }

    if (-not $messageIn) {
        $messageIn = read-multiline
    }

    if (-not $messageIn) {
        write-error "no message in";
        break
    }


    # Use pwsh to run the pencrypt function in PowerShell 7+
    $pwshCommand = "pwsh -NoProfile -Command `"& { . '$env:userprofile\Documents\GitHub\PScode\Automation\SECRETCODES.ps1'; pencrypt -messagetoEncrypt '$messageIn' -secretcode '$secretcode' }`""

    # Capture the result
    $global:secretmessage = Invoke-Expression $pwshCommand

    if (-not $global:secretmessage) {
        Write-Error "Encryption failed."
        return
    }

    # Store the encrypted message in the clipboard
    $global:secretmessage | Set-Clipboard

    return $global:secretmessage
}

function decode {
    
    [cmdletbinding()]

    param(
        [Parameter(Mandatory=$true)]
        [string]$secretmessage = $null,
        [string]$secretcode = $null,
        [switch]$clipboard
    )


    if ($clipboard) {
        $secretmessage = (Get-Clipboard)
    }

    if (-not $secretmessage) {
        Write-Error "No message to decode."
        return
    }
    
    if ([string]::IsNullOrEmpty($secretcode)) {
        $secretcode = read-secretcode
    }

    # Use pwsh to run the pdecrypt function in PowerShell 7+
    $pwshCommand = "pwsh -NoProfile -Command `"& { . '$env:userprofile\Documents\GitHub\PScode\Automation\SECRETCODES.ps1'; pdecrypt -secretMessage '$secretmessage' -secretcode '$secretcode' }`""

    # Capture the result
    $global:messageOut = Invoke-Expression $pwshCommand

    if (-not $global:messageOut) {
        Write-Error "Decryption failed."
        return
    }

    # Store the decrypted message in the clipboard
    $global:messageOut | Set-Clipboard | Out-Null

    return $global:messageOut
}
