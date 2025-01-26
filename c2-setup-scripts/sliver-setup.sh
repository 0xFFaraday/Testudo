#!/bin/bash

echo -e "\x1b[1;34m[*] EDITING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

echo -e "\x1b[1;34m[*] INSTALLING SLIVER\x1b[0m"
curl https://sliver.sh/install | sudo bash

echo -e "\x1b[1;34m[*] REVERTING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+NOPASSWD:ALL/%sudo\tALL=(ALL:ALL) ALL/' /etc/sudoers

echo -e "\x1b[1;34m[*] SLIVER READY TO EXECUTE\x1b[0m"
echo -e "\x1b[1;34m[*] Execute: sliver\x1b[0m"