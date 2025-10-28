#WorkstationRetirement Script
Start-Transcript -Path c:\Logs\retirement.log -force -Verbose
#Variables
$retired = "-Retired"
$hostname = hostname.exe
$newname = $hostname+$retired

#uninstall Tanium
cmd.exe /c "C:\Program Files (x86)\Tanium\Tanium Client\uninst.exe" /s

#Rename machine and Shutdown
rename-computer $newname 
stop-computer




