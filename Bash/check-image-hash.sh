#!/bin/bash

while true; do
    f1="/lce/programs/concept/lce/lce1.jpg"
	f2="/lce/programs/concept/lce/tmp/lce1.jpg"
	baseurl="baseurl"
    sastoken="sastoken"
	wget $baseurl"blobpath/lce1.jpg"$sastoken -O "/etc/programs/concept/lce/tmp/lce1.jpg"
	sleep 10
    hash=$(md5sum "$f1" "$f2" | awk '{a[$1]}END{print NR==length(a)}')
	if [ "$hash" -ne 0 ]; then
        pkill qimgv
		rm -rf home/user/.config/qimgv/savedState.conf
		rm -rf home/user/.config/qimgv/theme.conf
        rm -rf $f1
        mv $f2 $f1
		bash /etc/programs/concept/concept.sh
	else
        sleep 300
    fi
done