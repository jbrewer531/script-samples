#!/bin/sh

baseurl="baseurl"
sastoken="sastoken"

sudo wget $baseurl"/NGT/NGT.zip"$sastoken -O "/tmp/NGT.zip"
sudo unzip /tmp/NGT.zip -d /opt/programs
sudo python3 /opt/programs/NGT/installer/linux/install_ngt.py