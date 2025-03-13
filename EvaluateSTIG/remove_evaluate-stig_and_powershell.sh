#!/bin/bash
###########################################################################################################################################
###########################################################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
###########################################################################################################################################
###########################################################################################################################################
# Description:
# This script automates the removal of Evaluate-STIG and PowerShell
###########################################################################################################################################
###########################################################################################################################################

# Define colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Verify script is ran with sudo/ as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n${RED}[ ! ]${RESET} This script must be run as root."
    exit 1
fi

# Trap signals (e.g., CTRL+C or termination) and exit cleanly
trap 'echo -e "\n${RED}[ ! ]${RESET} Script interrupted. Exiting cleanly..."; exit 1' SIGINT SIGTERM

# Verify user wants to proceed
while true; do
    echo -e "\n[ ! ] This script permanently deletes Evaluate-STIG and PowerShell. Do you want you proceed? [y/n]:"
    read -r proceed_with_script
    case "$proceed_with_script" in
        [Yy]* )
            break
            ;;
        [Nn]* )
            echo -e "\n[ ! ] Exiting with no changes."
            exit 0
            ;;
        * )
            echo "Invalid input, please type y or n."
            ;;
    esac
done

# Delete Evaluate-STIG from /opt/
echo -e "\n[ + ] Deleting Evaluate-STIG..."

if [ -d /opt/Evaluate-STIG ]; then
    rm -rf /opt/Evaluate-STIG
    echo -e "\n${GREEN}[ + ]${RESET} Evaluate-STIG removed successfully"
else
    echo -e "\n[ + ] Evaluate-STIG not installed in /opt/; please delete the directory manually"
    echo -e "\n[ ! ] Maybe it's located here?"
    find / -iname 'Evaluate*STIG' 2>/dev/null
fi

# Delete PowerShell from /opt/
echo -e "\n[ + ] Deleting PowerShell..."

if [ -d /opt/powershell ]; then
    rm -rf /opt/powershell
    echo -e "\n${GREEN}[ + ]${RESET} PowerShell removed successfully"

    # Remove PowerShell symbolic link
    if [ -L /usr/bin/pwsh ]; then
        echo -e "\n[ + ] Removing PowerShell symbolic link..."
        rm -f /usr/bin/pwsh
        echo -e "\n${GREEN}[ + ]${RESET} PowerShell symbolic link removed successfully"
    fi
else
    echo -e "\n[ + ] PowerShell is not installed in /opt/; please delete the directory manually"
    echo -e "\n[ ! ] Maybe it's located here?"
    find / -iname 'powershell' 2>/dev/null
fi

