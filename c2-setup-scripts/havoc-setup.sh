#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

export testudo_c2_dir=~/havoc

echo -e "\x1b[1;34m[*] EDITING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+ALL/%sudo\tALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

echo -e "\x1b[1;34m[*] INSTALLING PREREQS\x1b[0m"
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install python3.10 python3.10-dev -y
sudo apt install git build-essential apt-utils cmake libfontconfig1 libglu1-mesa-dev libgtest-dev libspdlog-dev libboost-all-dev libncurses5-dev libgdbm-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev libbz2-dev mesa-common-dev qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5websockets5 libqt5websockets5-dev qtdeclarative5-dev golang-go qtbase5-dev libqt5websockets5-dev python3-dev libboost-all-dev mingw-w64 nasm -y

echo -e "\x1b[1;34m[*] CLONING HAVOC REPO\x1b[0m"
git clone https://github.com/HavocFramework/Havoc.git
cd Havoc

echo -e "\x1b[1;34m[*] INSTALLING GO DEPENDENCIES\x1b[0m"
cd teamserver
go mod download golang.org/x/sys
#go mod download github.com/ugorji/go
cd ..

echo -e "\x1b[1;34m[*] BUILDING TEAMSERVER\x1b[0m"
make ts-build

echo -e "\x1b[1;34m[*] BUILDING CLIENT\x1b[0m"
make client-build

echo -e "\x1b[1;34m[*] EXPORTING FILES\x1b[0m"
mv ~/c2-setup-scripts/Havoc $testudo_c2_dir
cd $testudo_c2_dir

echo -e "\x1b[1;34m[*] REVERTING SUDOERS FILE\x1b[0m"
sudo sed -i 's/%sudo\tALL=(ALL:ALL)\s\+NOPASSWD:ALL/%sudo\tALL=(ALL:ALL) ALL/' /etc/sudoers

echo "Navigate to the directory: '$testudo_c2_dir'."
echo -e "\x1b[1;34m[*] EXECUTE ./havoc client\x1b[0m"
echo -e "\x1b[1;34m[*] OR ./havoc server --profile ./profiles/havoc.yaotl -v --debug\x1b[0m"