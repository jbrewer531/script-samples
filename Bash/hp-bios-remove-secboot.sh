#!/bin/bash

if [ ! -d /opt/hp/hp-flash/ ]

then

    echo "Directory does not exist"

	exit 0
else
    echo "Enabling Secure Boot this may take a few moments."
	cd /opt/hp/hp-flash
	wget https://www.dropbox.com/s/wr6lduagpy2115h/g4bios.txt
	./hp-repsetup -S -q g4bios.txt
	echo "Rebooting system please don not unplug during this process"
	process_id=$!
	echo "PID: $process_id"
	wait $process_id
	echo "Exit status: $?"
	reboot
fi
