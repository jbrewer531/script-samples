Stop-VM -Name cvng-server-virt -Force
Set-VMNetworkAdapter -VMName cvng-server-virt -StaticMacAddress $('00155D'+((0..2 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join ''))
Start-VM -Name cvng-server-virt
