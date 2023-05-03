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
[System.Windows.Forms.Application]::EnableVisualStyles()

$VhpTools                        = New-Object system.Windows.Forms.Form
$VhpTools.ClientSize             = New-Object System.Drawing.Point(250,274)
$VhpTools.text                   = "VhpTools"
$VhpTools.TopMost                = $false
$VhpTools.icon                   = "C:\Users\IT\Desktop\1.ico"
$VhpTools.BackColor              = [System.Drawing.ColorTranslator]::FromHtml("#d7d7ce")

$About                           = New-Object system.Windows.Forms.Button
$About.text                      = "About"
$About.width                     = 100
$About.height                    = 40
$About.location                  = New-Object System.Drawing.Point(13,10)
$About.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',12)
$About.BackColor                 = [System.Drawing.ColorTranslator]::FromHtml("#50e3c2")
$About.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Made by Kesh :D")
})

$Launch                          = New-Object system.Windows.Forms.Button
$Launch.text                     = "LAUNCH"
$Launch.width                    = 100
$Launch.height                   = 40
$Launch.location                 = New-Object System.Drawing.Point(12,56)
$Launch.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Launch.ForeColor                = [System.Drawing.ColorTranslator]::FromHtml("#000000")
$Launch.BackColor                = [System.Drawing.ColorTranslator]::FromHtml("#50e3c2")

# Add a click event to the button
$Launch.Add_Click({
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
    

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "KILL"
$Button2.width                   = 100
$Button2.height                  = 40
$Button2.location                = New-Object System.Drawing.Point(12,105)
$Button2.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button2.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#d0021b")
$Button2.Add_Click({
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

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "RESTART"
$Button3.width                   = 100
$Button3.height                  = 44
$Button3.location                = New-Object System.Drawing.Point(13,151)
$Button3.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button3.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#7fe010")

    $Button3.Add_Click({
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


$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Test Connection"
$Button1.width                   = 100
$Button1.height                  = 42
$Button1.location                = New-Object System.Drawing.Point(12,201)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#bd10e0")
    $Button1.Add_Click({
    $ipAddress = "54.169.69.22"
    if(Test-Connection -ComputerName $ipAddress -Count 3 -Quiet) {
        [System.Windows.Forms.MessageBox]::Show("VHP Connection Status GOOD.", "Test Connection Result")
    }
    else {
        [System.Windows.Forms.MessageBox]::Show("VHP Connection Status BAD.", "Test Connection Result")
    }
})

 
$VhpTools.controls.AddRange(@($About,$Launch,$Button2,$Button3,$Button1))  


#region Logic 

#endregion

[void]$VhpTools.ShowDialog()
