#!/bin/bash
baseurl="baseurl"
sastoken="sastoken"
# Updating the APT repos
sudo apt update
#Installing Qimgv Image Viewer and WMCTRL
sudo add-apt-repository --yes ppa:easymodo/qimgv
sudo apt install libmpv-dev -y
sudo apt install qimgv -y
sudo apt install wmctrl -y
sudo apt install xinput -y
# Creating directory for pictures and scripts storage
sudo mkdir -p /etc/programs/concept/lce/tmp
# Downloading scripts and picture from Azure blob 
sudo wget $baseurl"/spe/ConceptStore/lce1.jpg"$sastoken -O "/etc/programs/concept/lce/lce1.jpg"
sudo wget $baseurl"/spe/ConceptStore/concept.sh"$sastoken -O "/etc/programs/concept/concept.sh"
sudo wget $baseurl"/spe/ConceptStore/check-image-hash.sh"$sastoken -O "/etc/programs/concept/check-image-hash.sh"
sudo wget $baseurl"/spe/ConceptStore/qimgv.conf"$sastoken -O "/etc/programs/concept/qimgv.conf"
sudo wget $baseurl"/spe/ConceptStore/tsfix.sh"$sastoken -O "/etc/programs/concept/tsfix.sh"
# Making concept.sh and check-image-hash.sh executable
sudo chmod +x /etc/programs/concept/concept.sh
sudo chmod +x /etc/programs/concept/check-image-hash.sh
sudo chmod +x /etc/programs/concept/tsfix.sh
# Applying permissions so user can access directory and files
sudo chown -R user:user /etc/programs/concept/
# Adding the concept.sh and check-image-hash.sh script to user autostart file
sudo bash -c "echo @/etc/programs/concept/concept.sh >> /home/user/.config/lxsession/Kiosk/autostart"
sudo bash -c "echo @/etc/programs/concept/check-image-hash.sh >> /home/user/.config/lxsession/Kiosk/autostart"
sudo bash -c "echo @/etc/programs/concept/tsfix.sh >> /home/user/.config/lxsession/Kiosk/autostart"
# Making Directory for Qimgv conf file
sudo mkdir -p /home/user/.config/qimgv
# Changing the owner of the qimgv.conf then copy it from /LCE to the user profile
sudo chown user:user /etc/programs/concept/qimgv.conf
sudo cp -rf /etc/programs/concept/qimgv.conf /home/user/.config/qimgv/
