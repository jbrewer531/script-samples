#!/bin/bash

# Get the Ubuntu release version
release=$(lsb_release -rs)

# Check the release version and install the corresponding .deb file
if [ "$release" == "22.04" ]; then
    echo "Ubuntu 22.04 detected. Installing package for 22.04..."
    sudo wget "https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb" -O "/tmp/zabbix-release_latest_7.0+ubuntu22.04_all.deb"
    sudo dpkg -i /tmp/zabbix-release_latest_7.0+ubuntu22.04_all.deb
	##Refreshing APT package list after adding Zabbix Repo
	sudo apt update
	##Installing Zabbix Agent
	sudo apt install zabbix-agent2 zabbix-agent2-plugin-*
	##Removing default conf file and copying the Azure conf file.
	sudo cp -f /opt/conf/zabbix/zabbix_agent2.conf /etc/zabbix/
	sudo cp -f /opt/conf/zabbix/zabbix.psk /etc/zabbix/
	sudo chown zabbix:zabbix /etc/zabbix/zabbix.psk
	## Restarting Zabbix Agent Services
	sudo systemctl restart zabbix-agent2
	sudo systemctl enable zabbix-agent2
elif [ "$release" == "20.04" ]; then
    echo "Ubuntu 20.04 detected. Installing package for 20.04..."
    sudo wget "https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu20.04_all.deb" -O "/tmp/zabbix-release_latest_7.0+ubuntu20.04_all.deb"
	sudo dpkg -i /tmp/zabbix-release_latest_7.0+ubuntu20.04_all.deb
	##Refreshing APT package list after adding Zabbix Repo
	sudo apt update
	##Installing Zabbix Agent
	sudo apt install zabbix-agent2 zabbix-agent2-plugin-*
	sudo cp -f /opt/conf/zabbix/zabbix_agent2.conf /etc/zabbix/
	sudo cp -f /opt/conf/zabbix/zabbix.psk /etc/zabbix/
	sudo chown zabbix:zabbix /etc/zabbix/zabbix.psk
	## Restarting Zabbix Agent Services
	sudo systemctl restart zabbix-agent2
	sudo systemctl enable zabbix-agent2
else
    echo "Unsupported Ubuntu version: $release"
    exit 1
fi