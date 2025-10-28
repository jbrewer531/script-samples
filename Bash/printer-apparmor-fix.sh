#!/usr/bin/env bash
sudo apt update
sudo apt install apparmor-utils -y
sudo aa-complain /usr/sbin/cups-browsed
sudo systemctl restart cups-browsed