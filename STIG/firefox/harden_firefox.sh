##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script applies the policy configuration needed to harden Firefox to DISA STIG requirements.
##################################################################################################
##################################################################################################

#!/bin/bash

# Define colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Check if policies.json is in the current directory
if [ ! -f ./policies.json ]; then
    # File doesn't exist, display message and exit with error status
    echo -e "\n${RED}[ + ]${RESET} The policies.json file is not in this directory"
    echo -e "\n${RED}[ + ]${RESET} Please make sure the install script and the policies.json file are in the same directory"
    exit 1
fi

# Make "policies" directory if it does not exist
echo "[ + ] Checking for /etc/firefox/policies"

if [ -d /etc/firefox/policies ]; then
    echo -e "\n[ + ] The /etc/firefox/policies directory already exists, skipping this step"
else
    mkdir -p /etc/firefox/policies
    chown root:root /etc/firefox/policies
    chmod 755 /etc/firefox/policies
    echo -e "\n${GREEN}[ + ]${RESET} /etc/firefox/policies directory created"
fi

echo "\n[ + ] Applying policies.json configuration file"

if [ -f /etc/firefox/policies/policies.json ]; then
    # Input validation loop for yes/no (y/n) response
    while true; do
        echo -e "\n[ + ] The /etc/firefox/policies.json file already exists, do you want to overwrite it? [y/n]"
        read choice
        case "$choice" in
            [yY] ) 
                cp ./policies.json /etc/firefox/policies/
                chown root:root /etc/firefox/policies/policies.json
                chmod 644 /etc/firefox/policies/policies.json
                echo -e "\n${GREEN}[ + ]${RESET} policies.json file has been overwritten."
                echo -e "\n[ + ] Verify with firefox by typing 'about:policies' in the URL bar."
                break
                ;;
            [nN] ) 
                echo -e "\n[ + ] Skipping policies.json configuration"
                break
                ;;
            * ) 
                echo -e "\n${RED}[ + ]${RESET} Invalid choice. Please enter 'y' or 'n'."
                ;;
        esac
    done
else
    cp ./policies.json /etc/firefox/policies/
    chown root:root /etc/firefox/policies/policies.json
    chmod 644 /etc/firefox/policies/policies.json
    echo -e "\n${GREEN}[ + ]${RESET} policies.json file has been created."
    echo -e "\n[ ! ] Verify enterprise policies are enabled with firefox by typing 'about:policies' in the URL bar."
fi
