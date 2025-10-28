$test = (Get-WmiObject -query 'select * from SoftwareLicensingService').OA3xOriginalProductKey

if ($test -eq $null) {
    exit
} else {
    ## Copying second script that will run after reboot to activate Windows with an Enterprise Key.
	Copy-Item -Path ".\WindowsKeyActivation.ps1" -Destination "C:\scripts\"  
	## Setting Registy value to run WindowsActivation.ps1 after reboot
	New-ItemProperty -Path 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Run' -Name WindowsActivation -Value '%systemroot%\System32\WindowsPowerShell\v1.0\powershell.exe -executionpolicy bypass -file c:\scripts\WindowsEnterprise2.ps1' -PropertyType ExpandString
	## Removes current product key and puts Windows in an unlicensed state
	slmgr /upk
	## Removes the current key from the registry if it is still populated there.
	slmgr /cpky
	## This resets the Windows Activation process and will set the system back to a pre-key state
	slmgr /rearm
	## Rebooting system
	Restart-Computer -Force
}
