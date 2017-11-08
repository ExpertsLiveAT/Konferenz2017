# tell PowerShell that we want to use classes from System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# create a new form
$Form = New-Object System.Windows.Forms.Form

# create and setup the listbox
$ListBox = New-Object System.Windows.Forms.ListBox
$ListBox.Dock = [System.Windows.Forms.DockStyle]::Fill
$ListBox.Items.Add("Europe") | Out-Null
$ListBox.Items.Add("Switzerland") | Out-Null
$ListBox.Items.Add("Austria") | Out-Null

# create and setup the button
$Button = New-Object System.Windows.Forms.Button
$Button.Dock = [System.Windows.Forms.DockStyle]::Bottom
$Button.Text = "Click Me!"
$Button.Add_Click({ [System.Windows.MessageBox]::Show($ListBox.SelectedItem) })

# add listbox and button to the form
$Form.Controls.Add($ListBox)
$Form.Controls.Add($Button)

# show the form
$Form.ShowDialog()