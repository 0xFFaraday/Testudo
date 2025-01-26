#!/bin/bash

set -e

export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a

echo -e "\x1b[1;34m[*] UPDATING APT\x1b[0m"
sudo apt update

echo -e "\x1b[1;34m[*] INSTALLING ANSIBLE\x1b[0m"
sudo apt install ansible sshpass -y