#Logging for diskcleanup script
Start-Transcript -Path c:\LCE\Logs\diskcleanup.log -force -Verbose

# Setting variables for Disk Cleanup Program, Windows Temp folder, and Windows.old folder
$cleanmgrPath = "$env:SystemRoot\System32\cleanmgr.exe"
$TempFolder = "C:\Windows\Temp"
$OldWinFolder = "C:\Windows.old"
$UserTempFolder = "C:\users\XXXX\AppData\Local\Temp"
$WinInstallDir = "C:\Windows\installer"

#Function to clean up User Appdata temp folder
function Clean-UserTempFolder {
    if (Get-ChildItem -Path $UserTempFolder -File) {
        Remove-Item "$UserTempFolder\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Temp folder cleaned."
    } else {
        Write-Output "Temp folder is already empty."
    }
}
function Clean-WinInstallDir {
    if (Get-ChildItem -Path $WinInstallDir -File) {
        Remove-Item "$UserTempFolder\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Output "Installer folder cleaned."
    } else {
        Write-Output "Installer folder is already empty."
    }
}
# Function to clean up the Windows Temp folder
function Clean-TempFolder {
    if (Get-ChildItem -Path $TempFolder -File) {
        Remove-Item "$TempFolder\*" -Recurse -Force
        Write-Output "Temp folder cleaned."
    } else {
        Write-Output "Temp folder is already empty."
    }
}

# Function to run DISM cleanup
function Clean-WinSXS {
    Start-Process -FilePath "dism.exe" -ArgumentList '/online /cleanup-image /startcomponentcleanup /ResetBase' -Wait -NoNewWindow
    Write-Output "DISM cleanup completed."
}

# Function to run Disk Cleanup if Windows.old folder exists
function Clean-OldWindows {
    if (Test-Path -Path $OldWinFolder) {
        Start-Process $cleanmgrPath -ArgumentList "/sagerun:1" -Wait
        Write-Output "Disk Cleanup for Windows.old completed."
    } else {
        Write-Output "No Windows.old folder found."
    }
}

# Execute functions
Clean-UserTempFolder
Clean-WinInstallDir
Clean-TempFolder
Clean-WinSXS
Clean-OldWindows
