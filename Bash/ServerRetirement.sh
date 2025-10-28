#!/bin/bash

# Variables
#v1 reads the server_conf.json file and extracts the LOCATION_NUMBER value
v1=$(head -8 /opt/programs/cvng/conf/server_conf.json | tail -1 | cut -b 23-26)
RED="\e[31m"
ENDCOLOR="\e[0m"

# Rename Host to RetiredServer-XXXXX, XXXXX is the location number.
sudo bash -c "echo RetiredServer$v1 > /etc/hostname"

# This will scale the pods downs in Kubernetes
kubectl scale deployment -n namespace --replicas 0 --all

# Complete Tanium Uninstall
# Purge Tanium Certificate
sudo dpkg -P taniumclientconfig || echo taniumclientconfig not installed. No need to remove.

# Purge Tanium Client
sudo dpkg -P taniumclient || echo Error removing taniumclient

# Remove Tanium installation directory
sudo rm -rf /opt/Tanium

# Creating and applying new netplan file that sets the server to DHCP
sudo touch ~/99-custom.yaml

echo "network:" > ~/99-custom.yaml
echo "  version: 2:" >> ~/99-custom.yaml
echo "  renderer: networkd" >> ~/99-custom.yaml
echo "  ethernets:" >> ~/99-custom.yaml
echo "    eno1:" >> ~/99-custom.yaml
echo "      dhcp4: yes" >> ~/99-custom.yaml
echo "      dhcp6: no" >> ~/99-custom.yaml

sudo cp ~/99-custom.yaml /etc/netplan/99-custom.yaml
sudo netplan apply

# Script will wait 20 seconds before progressing
echo "Script is still running please do not power off or shutdown!!!!"
sleep 10
echo -e "${RED}After computer shuts down momentarily please DISCONNECT power plug from the back of the retired server so it does not turn back on.${ENDCOLOR}"
sleep 10

sudo shutdown now

