mkdir C:\zabbix
curl  -C - "https://cdn.zabbix.com/zabbix/binaries/stable/7.0/7.0.0/zabbix_agent2-7.0.0-windows-amd64-openssl.msi" -o C:\zabbix\zabbix_agent2-6.4.12-windows-amd64-openssl.msi
msiexec /lv "C:\Logs\zabbix.txt" /i "C:\zabbix\zabbix_agent2-6.4.12-windows-amd64-openssl.msi" TARGETDIR="C:\Program Files" SERVER=x.x.x.x SERVERACTIVE=x.x.x.x HOSTMETADATA=Windows ENABLEPATH=1 TLSACCEPT= /qn
net start Zabbix Agent 2