#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

export testudo_c2_dir=~/empire

echo -e "\x1b[1;34m[*] EDITING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

echo -e "\x1b[1;34m[*] INSTALLING EMPIRE\x1b[0m"
git clone --recursive https://github.com/BC-SECURITY/Empire.git
cd Empire
./setup/checkout-latest-tag.sh

echo -e "\x1b[1;34m[*] REVERTING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+NOPASSWD:ALL/%sudo\tALL=(ALL:ALL) ALL/' /etc/sudoers

echo -e "\x1b[1;34m[*] EXPORTING FILES\x1b[0m"
mv ~/c2-setup-scripts/Empire $testudo_c2_dir
cd $testudo_c2_dir

echo "Navigate to the directory: '$testudo_c2_dir'."
echo -e "\x1b[1;34m[*] POWERSHELL EMPIRE READY TO INSTALL\x1b[0m"
echo -e "\x1b[1;34m[*] Execute: ./ps-empire install -y\x1b[0m"