# Function to create a simple input form
function Read-MultiHostInputDialogBox {
    
    <#
        .SYNOPSIS
        Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.

        .DESCRIPTION
        Prompts the user with a multi-line input box and returns the text they enter, or null if they cancelled the prompt.

        .PARAMETER Message
        The message to display to the user explaining what text we are asking them to enter.

        .PARAMETER WindowTitle
        The text to display on the prompt window's title.

        .PARAMETER DefaultText
        The default text to show in the input box.

        .EXAMPLE
        $userText = Read-MultiLineInputDialog "Input some text please:" "Get User's Input"

        Shows how to create a simple prompt to get mutli-line input from a user.

        .EXAMPLE
        # Setup the default multi-line address to fill the input box with.
        $defaultAddress = @'
        John Doe
        123 St.
        Some Town, SK, Canada
        A1B 2C3
        '@

        $address = Read-MultiLineInputDialog "Please enter your full address, including name, street, city, and postal code:" "Get User's Address" $defaultAddress
        if ($address -eq $null)
        {
            Write-Error "You pressed the Cancel button on the multi-line input box."
        }

        Prompts the user for their address and stores it in a variable, pre-filling the input box with a default multi-line address.
        If the user pressed the Cancel button an error is written to the console.

        .EXAMPLE
        $inputText = Read-MultiLineInputDialog -Message "If you have a really long message you can break it apart`nover two lines with the powershell newline character:" -WindowTitle "Window Title" -DefaultText "Default text for the input box."

        Shows how to break the second parameter (Message) up onto two lines using the powershell newline character (`n).
        If you break the message up into more than two lines the extra lines will be hidden behind or show ontop of the TextBox.

        .NOTES
        Name: Show-MultiLineInputDialog
        Author: Brandon Carey (originally based on the code shown at http://technet.microsoft.com/en-us/library/ff730941.aspx)
        Version: 1.0
    #>
    
    [cmdletbinding()]

    param (
        [string]$Message,
        [string]$DefaultText,
        [string]$WindowTitle
    )

    # Load required assemblies
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName System.Windows.Forms

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $WindowTitle
    $form.Size = New-Object System.Drawing.Size(640, 400)
    $form.StartPosition = 'CenterScreen'
    $form.Topmost = $true

    # Create the Label
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Size = New-Object System.Drawing.Size(280, 20)
    $label.Text = $Message
    $form.Controls.Add($label)

    # Create the TextBox
    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10, 40)
    $textBox.Size = New-Object System.Drawing.Size(600, 250)
    $textBox.Multiline = $true
    $textBox.ScrollBars = 'Vertical'
    $textBox.Text = $DefaultText
    $textBox.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
    $form.Controls.Add($textBox)

    # Create the OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(415, 310)
    $okButton.Size = New-Object System.Drawing.Size(75, 25)
    $okButton.Text = "OK"
    $okButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $form.Controls.Add($okButton)

    # Create the Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(510, 310)
    $cancelButton.Size = New-Object System.Drawing.Size(75, 25)
    $cancelButton.Text = "Cancel"
    $cancelButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
    $form.Controls.Add($cancelButton)

    # Event handler for OK button
    $okButton.Add_Click({ $form.Tag = $textBox.Text; $form.Close() })

    # Event handler for Cancel button
    $cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })

    # Show the form
    $form.Add_Shown({ $form.Activate() })
    $form.ShowDialog() > $null

    # Return user input
    return $form.Tag
}

# Example usage:
#$inputText = Read-MultiHostInputDialogBox -Message "Enter something:" -DefaultText "Default text" -WindowTitle "Input Form"
#Write-Host "User input: $inputText"
