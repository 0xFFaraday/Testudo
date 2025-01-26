#!/bin/bash

banner() {
cat << EOF                      
    
  ______          __            __    
 /_  __/__  _____/ /___  ______/ /___ 
  / / / _ \/ ___/ __/ / / / __  / __ \\
 / / /  __(__  ) /_/ /_/ / /_/ / /_/ /
/_/  \___/____/\__/\__,_/\__,_/\____/ 
            Created By: 0xFFaraday             

EOF
}

banner

usage() {
    echo "Usage: $0 {empire|sliver|havoc}"
    exit 1
}

if [ $# -lt 1 ]; then
    echo "Error: No argument provided."
    usage
fi

c2_choice=$1

# Check the provided argument
case "$c2_choice" in
    empire)
        ./empire-setup.sh
        ;;
    sliver)
        ./sliver-setup.sh
        ;;
    havoc)
        ./havoc-setup.sh
        ;;
    *)
        echo "Error: Invalid argument '$c2_choice'."
        usage
        ;;
esac