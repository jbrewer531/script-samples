#!/bin/bash
#Renaming Terminal host name
echo "-Retired" >> /etc/hostname

# Complete Tanium Uninstall
# Purge Tanium Certificate
sudo dpkg -P taniumclientconfig || echo taniumclientconfig not installed. No need to remove.

# Purge Tanium Client
sudo dpkg -P taniumclient || echo Error removing taniumclient

# Remove Tanium installation directory
sudo rm -rf /opt/Tanium

sudo shutdown now