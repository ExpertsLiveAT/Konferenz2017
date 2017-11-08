# processes to start
$psw = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
$notepad = "C:\Windows\notepad.exe"

# start the processes, use PassThru to get the process object back!
$pswProcess = (Start-Process -FilePath $psw -PassThru)
$notepadProcess = (Start-Process -FilePath $notepad -PassThru)

# attention: wait for the window handles to be available!

# get the MainWindowHandle (HWND)
$pswHwnd = $pswProcess.MainWindowHandle
$notepadHwnd = $notepadProcess.MainWindowHandle

Write-Host PowerShell Window Handle: $pswHwnd
Write-Host Notepad Window Handle $notepadHwnd

# magic starts here:
# SetWindowPos: https://msdn.microsoft.com/en-us/library/windows/desktop/ms633545%28v=vs.85%29.aspx
# pinvoke.net:  http://pinvoke.net/default.aspx/user32/SetWindowPos.html
$source = @" 
    using System; 
    using System.Runtime.InteropServices;

    namespace GodMode
    {
        public static class Win32Interop
        {
            [DllImport("user32.dll", EntryPoint = "SetWindowPos")]
            public static extern IntPtr SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int x, int Y, int cx, int cy, int wFlags);
                    
            public const int SWP_SHOWWINDOW = 0x40;
            public static readonly IntPtr NoTopMost = new IntPtr(-2);
            public static readonly IntPtr TopMost = new IntPtr(-1);

            public static void SetWindowPosition(IntPtr handle, int x, int y, int width, int height, bool topMost)
            {
                if (topMost)
                {
                    SetWindowPos(handle, TopMost, x, y, width, height, SWP_SHOWWINDOW);
                }
                else
                {
                    SetWindowPos(handle, NoTopMost, x, y, width, height, SWP_SHOWWINDOW);
                }
            }
        }
    }
"@ 

Add-Type -TypeDefinition $source -Language CSharp

# play god!
[GodMode.Win32Interop]::SetWindowPosition($pswHwnd, 0, 0, 320, 240, $false);
[GodMode.Win32Interop]::SetWindowPosition($notepadHwnd, 320, 0, 320, 240, $false);

# make them always on top
[GodMode.Win32Interop]::SetWindowPosition($pswHwnd, 0, 0, 320, 240, $true);
[GodMode.Win32Interop]::SetWindowPosition($notepadHwnd, 320, 0, 320, 240, $true);

# back to normal
[GodMode.Win32Interop]::SetWindowPosition($pswHwnd, 0, 0, 320, 240, $false);
[GodMode.Win32Interop]::SetWindowPosition($notepadHwnd, 320, 0, 320, 240, $false);
