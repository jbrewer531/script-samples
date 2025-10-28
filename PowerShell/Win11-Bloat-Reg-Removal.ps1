#Reg keys for disabling Microsoft Store
Write-Host "Disabling Microsoft Store"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore' -Name "RemoveWindowsStore" -Value "1" -PropertyType DWord

#Reg keys for PowerShell Policy to unrestricted
Write-Host "Setting Powershell Execution Policy"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Windows\PowerShell'
Set-ItemProperty -Path 'HKLM:\Software\Microsoft\PowerShell\1\Shellids\Microsoft.PowerShell' -Name "ExecutionPolicy" -type String -Value "Unrestricted"

#Reg keys for disabling Windows Updates
Write-Host "Disabling Windows Updates"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name "NoAutoUpdate" -Value "1" -PropertyType DWord -Force

#Reg keys for disabling OneDrive
Write-Host "Disabling Microsoft OneDrive"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive' -Name DisableFileSyncNGSC -Value "1"  -PropertyType DWord -Force

#Turning off Windows Updates
sc.exe config wuauserv start= disabled
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Force
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name "NoAutoUpdate" -Value "1" -PropertyType DWord -Force
New-Item -Path 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Force
New-ItemProperty -Path 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name ActiveHoursStart -Value "9" -PropertyType DWord -Force
New-ItemProperty -Path 'HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name ActiveHoursEnd -Value "3" -PropertyType DWord -Force

#Removing Microsoft store packages for all users
Write-Host "Creating C:\LCE  subfolders"
Get-AppxPackage -AllUsers | Where-Object {$_.Name -like "*WebExperience*"} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

#Removing Widgets from Task Bar
Write-Host "Removing Widgets from Task Bar"
New-Item -Path 'HKLM:\Software\Policies\Microsoft\Dsh'
New-ItemProperty -Path 'HKLM:\Software\Policies\Microsoft\Dsh' -Name "AllowNewsAndInterests" -Value "0" -PropertyType DWord

#Removing Task View button from Task Bar
Write-Host "Removing Task View button from Task Bar"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name "HideTaskViewButton" -Value "1" -PropertyType DWord

#Removing Search Bar from Task Bar
Write-Host "Removing Search Bar from Task Bar"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name "SearchOnTaskbarMode" -Value "0" -PropertyType DWord

#Disabling default pinned apps list
Write-Host "Disabling default pinned apps list"
New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer'
New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer' -Name "TaskbarNoPinnedList" -Value "1" -PropertyType DWord