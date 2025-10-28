#!/bin/bash
sudo apt --fix-broken install -y
# Mark all "manually installed" kernel packages as "automatically installed"
for f in $(apt-mark showmanual | grep linux-); do
    apt-mark auto $f
done
# Remove all packages that are no longer needed
apt-get -y autoremove --purge

for f in $(apt-mark showauto | grep linux-); do
    apt-mark manual $f
done