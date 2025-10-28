#!/bin/bash
wget https://cdn.geekbench.com/Geekbench-6.3.0-Linux.tar.gz
tar xf Geekbench-6.3.0-Linux.tar.gz
./Geekbench-6.3.0-Linux/geekbench6 --unlock user@domain.com XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
sleep 5
./Geekbench-6.3.0-Linux/geekbench6 --export-csv /home/user/results.csv

