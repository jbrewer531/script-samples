

#disables Windows Store
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name "RemoveWindowsStore" -Value "1" -PropertyType DWord

#removes Windows apps
Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*WebExperience*"} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

#reboot machine
Restart-Computer -Force