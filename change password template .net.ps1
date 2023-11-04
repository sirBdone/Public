Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Change Password: length:16-32 Aa1[!@#]"
$form.Size = New-Object System.Drawing.Size(450, 200)
$form.MinimumSize = New-Object System.Drawing.Size(450, 200)
$form.MaximumSize = New-Object System.Drawing.Size(600, 200)

# Disable the ability to resize in the height direction
#$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog

$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Create labels, textboxes, and buttons
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(20, 20)
$label1.Text = "Username:"
$form.Controls.Add($label1)

$textUsername = New-Object System.Windows.Forms.TextBox
$textUsername.Location = New-Object System.Drawing.Point(120, 20)
$textUsername.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$textUsername.Width = 300
$form.Controls.Add($textUsername)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(20, 50)
$label2.Text = "Password:"
$form.Controls.Add($label2)

$textPasswordSecure = New-Object System.Windows.Forms.TextBox
$textPasswordSecure.Location = New-Object System.Drawing.Point(120, 50)
$textPasswordSecure.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$textPasswordSecure.Width = 200
$textPasswordSecure.PasswordChar = "*"
$form.Controls.Add($textPasswordSecure)

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(20, 80)
$label3.Text = "Re-enter Password:"
$form.Controls.Add($label3)

$textPasswordReenteredSecure = New-Object System.Windows.Forms.TextBox
$textPasswordReenteredSecure.Location = New-Object System.Drawing.Point(120, 80)
$textPasswordReenteredSecure.Anchor = [System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Left -bor [System.Windows.Forms.AnchorStyles]::Right
$textPasswordReenteredSecure.Width = 200
$textPasswordReenteredSecure.PasswordChar = "*"
$form.Controls.Add($textPasswordReenteredSecure)

$showTextButton = New-Object System.Windows.Forms.Button
$showTextButton.Location = New-Object System.Drawing.Point(345, 47)
$showTextButton.Anchor = [System.Windows.Forms.AnchorStyles]::Top -band [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$showTextButton.Text = "Show Text"
$form.Controls.Add($showTextButton)

$showTextButton.Add_Click({
    if ($textPasswordSecure.PasswordChar -eq "*") {
        $textPasswordSecure.PasswordChar = $null
        #$textPasswordReenteredSecure.PasswordChar = $null
    } else {
        $textPasswordSecure.PasswordChar = "*"
        #$textPasswordReenteredSecure.PasswordChar = "*"
    }
})

$showTextButton2 = New-Object System.Windows.Forms.Button
$showTextButton2.Location = New-Object System.Drawing.Point(345, 78)
$showTextButton2.Anchor = [System.Windows.Forms.AnchorStyles]::Top -band [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$showTextButton2.Text = "Show Text"
$form.Controls.Add($showTextButton2)

$showTextButton2.Add_Click({
    if ($textPasswordReenteredSecure.PasswordChar -eq "*") {
        #$textPasswordSecure.PasswordChar = $null
        $textPasswordReenteredSecure.PasswordChar = $null
    } else {
        #$textPasswordSecure.PasswordChar = "*"
        $textPasswordReenteredSecure.PasswordChar = "*"
    }
})

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(245, 120)
$button.Text = "Submit"
$button.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$form.Controls.Add($button)

# Add an event handler for the button click
$button.Add_Click({
    $username = $textUsername.Text
    $password = $textPasswordSecure.Text
    $passwordReentered = $textPasswordReenteredSecure.Text

    if ($password -eq $passwordReentered -and $password -match "^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#%^&*(){}|<>?,./\[\]]).{16,32}$") {
        # Password meets the criteria
        # Here, you can make the JSON API call with the $username and $password variables
        # Replace the following line with your API call logic
        Write-Host "Username: $username"
        write-host "Password: $password"
        # (API call would go here)"
        $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
    } else {
        [System.Windows.Forms.MessageBox]::Show("Password does not meet the criteria. Please use 16-32 characters, 1 uppercase letter, 1 lowercase letter, and one of these '!@#$'. ")
    }
})

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(345, 120)
$cancelButton.Anchor = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right
$cancelButton.Text = "Cancel"
$form.Controls.Add($cancelButton)

$cancelButton.Add_Click({
    $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
})

$form.Topmost = $True

$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # User clicked Submit
    # Handle the submission if needed
} else {
    # User clicked Cancel or closed the form
    # Handle the cancellation or form closure if needed
}
