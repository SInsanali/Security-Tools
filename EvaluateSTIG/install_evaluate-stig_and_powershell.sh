###########################################################################################################################################
###########################################################################################################################################

# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
###########################################################################################################################################
###########################################################################################################################################

# Description:
# This script automates the installation of Evaluate-STIG and PowerShell, then checks the system for the required dependencies to run.

###########################################################################################################################################
###########################################################################################################################################


#!/bin/bash

# Define colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

echo -e "${GREEN}[ + ] Installing PowerShell...${RESET}"

# Create directory and extract PowerShell quietly
mkdir -p /opt/powershell
tar -xzf ./powershell-7.3.0*.tar.gz -C /opt/powershell &>/dev/null  # Quiet extraction
chmod +x /opt/powershell/pwsh

# Create a symbolic link to the PowerShell executable
ln -sf /opt/powershell/pwsh /usr/bin/pwsh

# Verify PowerShell installation
if command -v pwsh &>/dev/null; then
    echo -e "\n${GREEN}[ ✔ ] PowerShell installed successfully!${RESET}"
    echo -e "\n${GREEN}[ + ] PowerShell version: $(pwsh --version)${RESET}"
    echo -e "\n${GREEN}[ + ] You can now execute PowerShell using: 'pwsh'${RESET}"
else
    echo -e "${RED}[ ✖ ] PowerShell installation failed!${RESET}"
    exit 1
fi

# Install Evaluate-STIG
echo -e "\n${GREEN}[ + ] Installing Evaluate-STIG...${RESET}"

mkdir -p /opt/Evaluate-STIG
unzip -q ./Evaluate-STIG*.zip -d /opt/Evaluate-STIG  # Quiet extraction

# Add execute permissions
chmod +x /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/Test-Prerequisites.sh
chmod +x /opt/Evaluate-STIG/Evaluate-STIG/Evaluate-STIG.ps1

echo -e "${GREEN}[ ✔ ] Evaluate-STIG installed successfully!${RESET}"

# # Test prerequisites
# echo -e "${GREEN}[ + ] Testing prerequisites...${RESET}"
# /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/Test-Prerequisites.sh

# Check for required packages
echo -e "\n${GREEN}[ + ] Checking for required packages...${RESET}"

missing_packages=()
for package in libicu lshw; do
    if ! rpm -q "$package" &>/dev/null; then
        missing_packages+=("$package")
    fi
done

# If missing packages were found, display an alert
if [ ${#missing_packages[@]} -ne 0 ]; then
    echo -e "\n${RED}[ ! ] The following packages are missing: ${missing_packages[*]}${RESET}"
    echo -e "${RED}[ ! ] Run eval_stig_dependency_check.sh to install them.${RESET}"
else
    echo -e "\n${GREEN}[ ✔ ] All required packages are installed.${RESET}"
fi
