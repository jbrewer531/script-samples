##Zabbix for Windows install script


$file= "C:\Program Files\Zabbix Agent 2\zabbix_agent2.conf"
$URL= "Your URL"
if(Test-Path -Path $file){
   write-host("Zabbix is already installed please uninstall and run the script again.")
}else {
   New-Item -ItemType Directory -Path C:\Scripts\zabbix
   wget $URL -O C:\Scripts\zabbix\zabbix-install.bat
   Start-Process C:\Scripts\zabbix\zabbix-install.bat -Wait
   #exit
}