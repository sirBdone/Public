# Function to create a simple input form with Enter/Shift+Enter functionality
function Read-MultiLine {
    [cmdletbinding()]
    param (
        [string]$Message="Added as array, 1 item per line",
        [string]$DefaultText,
        [string]$WindowTitle="read-MultiLine"
    )

    # Load required assemblies
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

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
    $okButton.Add_Click({
        $form.Tag = $textBox.Text -split "`n" | Where-Object { $_.Trim() -ne "" }
        $form.Close()
    })

    # Event handler for Cancel button
    $cancelButton.Add_Click({ $form.Tag = $null; $form.Close() })

    # Event handler for the TextBox to handle Enter and Shift+Enter
    $textBox.Add_Keydown({
        param($sender, $e)
        # If Enter is pressed without Shift, click the OK button
        if ($e.KeyCode -eq [System.Windows.Forms.Keys]::Enter -and -not $e.Shift) {
            $e.SuppressKeyPress = $true   # Prevents the beep sound
            $okButton.PerformClick()
        }
        # If Enter is pressed with Shift, add a new line
        elseif ($e.KeyCode -eq [System.Windows.Forms.Keys]::Enter -and $e.Shift) {
            $e.SuppressKeyPress = $true   # Prevents the beep sound
            $textBox.AppendText("`r`n")
        }
    })

    # Show the form
    $form.Add_Shown({ $form.Activate() })
    $form.ShowDialog() > $null

    # Return user input
    return $form.Tag
}

# Example usage:
#$inputText = Read-MultiHostInputDialogBox -Message "Enter something:" -DefaultText "Default text" -WindowTitle "Input Form"
#Write-Host "User input: $inputText"
