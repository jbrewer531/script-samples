if [ ! -d /opt/hp/hp-flash/ ];then

	echo "Directory does not exist"
	if mokutil --sb-state | grep "^SecureBoot disabled$";then
	echo "Installing HP Flash tools"
	wget https://www.dropbox.com/s/07kayaxvqgsqi5g/sp143035.tgz
	tar -xzf sp143035.tgz
	cd hpflash-3.22/non-rpms/
	tar -xzf hpuefi-mod-3.04.tgz
	cd hpuefi-mod-3.04
	make
	make install
	cd ..
	tar -xzf hp-flash-3.22_x86_64.tgz
	cd hp-flash-3.22_x86_64
	./install.sh
	echo "HP Flash Tools have now been installed. Please rerun script to flash BIOS."
		
		
	else
		echo "Please disable secure boot in the BIOS in order to install HP Flash"
		exit 0
	fi	
else
	cd /opt/hp/hp-flash
	./hp-repsetup -g |stdbuf  -o0 grep -A 1 "System BIOS"  > /opt/hp/hp-flash/version.txt
	isInFile=$(cat /opt/hp/hp-flash/version.txt | grep -c "Ver. 02.20.01")

	if [ $isInFile -eq 0 ]; then

		echo "updating BIOS"
		wget https://www.dropbox.com/s/4lati1ndwxvtbon/Q22_022001.bin
		./hp-flash -y Q22_022001.bin
		process_id=$!
		echo "PID: $process_id"
		wait $process_id
		echo "Exit status: $?"
		reboot

		else

		echo "BIOS is up to date"
		exit 0
	fi
fi			