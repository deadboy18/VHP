# Hide the console window
Add-Type -Name Window -Namespace ConsoleApp -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
public static void Hide()
{
    IntPtr hWnd = GetConsoleWindow();
    if(hWnd != IntPtr.Zero)
    {
        ShowWindow(hWnd, 0);
    }
}'
[ConsoleApp.Window]::Hide()


<# 
.NAME
    Untitled
#>

Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "VHP Control Panel"
$form.Size = New-Object System.Drawing.Size(300, 250)
$form.StartPosition = "CenterScreen"

# Set the icon for the form
$iconPath = "C:\Users\IT\Desktop\1.ico"  # Replace with the path to your icon file
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($iconPath)

# Create buttons
$buttonRestart = New-Object System.Windows.Forms.Button
$buttonRestart.Location = New-Object System.Drawing.Point(20, 20)
$buttonRestart.Size = New-Object System.Drawing.Size(100, 30)
$buttonRestart.Text = "Restart"
$ButtonRestart.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$buttonRestart.BackColor = "LightGreen"
$form.Controls.Add($buttonRestart)

$buttonLaunch = New-Object System.Windows.Forms.Button
$buttonLaunch.Location = New-Object System.Drawing.Point(20, 60)
$buttonLaunch.Size = New-Object System.Drawing.Size(100, 30)
$buttonLaunch.Text = "Launch"
$buttonLaunch.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$buttonLaunch.BackColor = "LightBlue"
$form.Controls.Add($buttonLaunch)

$buttonKill = New-Object System.Windows.Forms.Button
$buttonKill.Location = New-Object System.Drawing.Point(20, 100)
$buttonKill.Size = New-Object System.Drawing.Size(100, 30)
$buttonKill.Text = "Kill"
$buttonKill.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$buttonKill.BackColor = "LightSalmon"
$form.Controls.Add($buttonKill)

$buttonTestConnection = New-Object System.Windows.Forms.Button
$buttonTestConnection.Location = New-Object System.Drawing.Point(20, 140)
$buttonTestConnection.Size = New-Object System.Drawing.Size(100, 50)
$buttonTestConnection.Text = "Test Connection"
$buttonTestConnection.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$buttonTestConnection.BackColor = "LightYellow"
$form.Controls.Add($buttonTestConnection)

$buttonClose = New-Object System.Windows.Forms.Button
$buttonClose.Location = New-Object System.Drawing.Point(150, 20)
$buttonClose.Size = New-Object System.Drawing.Size(100, 30)
$buttonClose.Text = "Close"
$buttonClose.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Italic)
$buttonClose.BackColor = "LightGray"
$form.Controls.Add($buttonClose)

# Create label
$labelMadeBy = New-Object System.Windows.Forms.Label
$labelMadeBy.Text = "Made by Kesh"
$labelMadeBy.AutoSize = $true
$labelMadeBy.Font = New-Object System.Drawing.Font("MV Boli", 8, [System.Drawing.FontStyle]::Italic::Bold)
$labelMadeBy.Location = New-Object System.Drawing.Point(200, 190)
$form.Controls.Add($labelMadeBy)

# Event handlers
$buttonRestart.Add_Click({
    # Handle Restart button click event
    # Put your restart logic here
# Kill the VHPPrintService.exe process
    $process1 = Get-Process "VHPPrintService"
    if ($process1 -ne $null) {
        $process1.Kill()
    }

    # Kill the prowin32.exe process
    $process2 = Get-Process "prowin32"
    if ($process2 -ne $null) {
        $process2.Kill()
    }

    # Wait for a few milliseconds
    Start-Sleep -Milliseconds 10

    # Change to the C:\e1-vhp\VHPPRINT directory and launch VHPPrintService.exe as a job
    Start-Job -ScriptBlock {
        Set-Location "C:\e1-vhp\VHPPRINT"
        Start-Process ".\VHPPrintService.exe" -Wait
    }

    # Change to the \OpenEdge\bin directory and launch the prowin32.exe program as a job
    Start-Job -ScriptBlock {
        Set-Location "C:\OpenEdge\bin"
        $params = "-pf c:\e1-vhp\config\vhpAS.pf -ini c:\e1-vhp\config\vhpAS.ini -p e1-vhpstart.p -Wa -wpp _mprosrv C:\e1-vhp\localDB\vhp -N TCP -H localhost -S 2600"
        Start-Process "C:\OpenEdge\bin\prowin32.exe" $params -Wait
    }
})

$buttonLaunch.Add_Click({
    # Handle Launch button click event
    # Put your launch logic here
# Change to the C:\e1-vhp\VHPPRINT directory and launch VHPPrintService.exe as a job
    Start-Job -ScriptBlock {
        Set-Location "C:\e1-vhp\VHPPRINT"
        Start-Process ".\VHPPrintService.exe" -Wait
    }

    # Change to the \OpenEdge\bin directory and launch the prowin32.exe program as a job
    Start-Job -ScriptBlock {
        Set-Location "C:\OpenEdge\bin"
        $params = "-pf c:\e1-vhp\config\vhpAS.pf -ini c:\e1-vhp\config\vhpAS.ini -p e1-vhpstart.p -Wa -wpp _mprosrv C:\e1-vhp\localDB\vhp -N TCP -H localhost -S 2600"
        Start-Process "C:\OpenEdge\bin\prowin32.exe" $params -Wait
    }
})

$buttonKill.Add_Click({
    # Handle Kill button click event
    # Put your kill logic here
 # Kill the VHPPrintService.exe process
    $process1 = Get-Process "VHPPrintService"
    if ($process1 -ne $null) {
        $process1.Kill()
    }

    # Kill the prowin32.exe process
    $process2 = Get-Process "prowin32"
    if ($process2 -ne $null) {
        $process2.Kill()
    }
})

$buttonTestConnection.Add_Click({
    # Handle Test Connection button click event
    # Put your test connection logic here
$ipAddress = "54.169.69.22"
    if(Test-Connection -ComputerName $ipAddress -Count 3 -Quiet) {
        [System.Windows.Forms.MessageBox]::Show("VHP Connection Status GOOD.", "Test Connection Result")
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("VHP Connection Status BAD.", "Test Connection Result")
    }
})


$buttonClose.Add_Click({
    # Handle Close button click event
    $form.Close()
})

# Show the form
[void]$form.ShowDialog()
