#!/bin/bash
# Starting feh program and opening current picture
qimgv /etc/programs/concept/lce/lce1.jpg &

# Waiting one second before moving picture to other monitor
sleep 1

# Moving picture to other monitor
wmctrl -F -r "lce1.jpg" -e '0,947215,2555,49,720,1029'

# Waiting one second before maximizing picture
sleep 1

# maximizing picture
wmctrl -F -r "lce1.jpg" -b toggle,fullscreen