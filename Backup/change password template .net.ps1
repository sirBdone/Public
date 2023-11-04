Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Change Password: length:16-32 Aa1[!@#]"
$form.Size = New-Object System.Drawing.Size(300, 200)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

# Create labels, textboxes, and buttons
$label1 = New-Object System.Windows.Forms.Label
$label1.Location = New-Object System.Drawing.Point(20, 20)
$label1.Text = "Username:"
$form.Controls.Add($label1)

$textUsername = New-Object System.Windows.Forms.TextBox
$textUsername.Location = New-Object System.Drawing.Point(120, 20)
$form.Controls.Add($textUsername)

$label2 = New-Object System.Windows.Forms.Label
$label2.Location = New-Object System.Drawing.Point(20, 50)
$label2.Text = "Password:"
$form.Controls.Add($label2)

$textPassword = New-Object System.Windows.Forms.TextBox
$textPassword.Location = New-Object System.Drawing.Point(120, 50)
$form.Controls.Add($textPassword)
$textPassword.PasswordChar = '*'

$label3 = New-Object System.Windows.Forms.Label
$label3.Location = New-Object System.Drawing.Point(20, 80)
$label3.Text = "Re-enter Password:"
$form.Controls.Add($label3)

$textPasswordReentered = New-Object System.Windows.Forms.TextBox
$textPasswordReentered.Location = New-Object System.Drawing.Point(120, 80)
$form.Controls.Add($textPasswordReentered)
$textPasswordReentered.PasswordChar = '*'

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(100, 120)
$button.Text = "Submit"
$form.Controls.Add($button)

# Add an event handler for the button click
$button.Add_Click({
    $username = $textUsername.Text
    $password = $textPassword.Text
    $passwordReentered = $textPasswordReentered.Text

    if ($password -eq $passwordReentered -and $password -match "^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#]).{16,32}$") {
        # Password meets the criteria
        # Here, you can make the JSON API call with the $username and $password variables
        # Replace the following line with your API call logic
        Write-Host "Username: $username, Password: $password (API call would go here)"
    } else {
        [System.Windows.Forms.MessageBox]::Show("Password does not meet the criteria. Please use 16-32 characters, 1 uppercase letter, 1 lowercase letter, and one of these '!@#$'. ")
    }
})

$form.Topmost = $True

# Display the form
$form.ShowDialog()
