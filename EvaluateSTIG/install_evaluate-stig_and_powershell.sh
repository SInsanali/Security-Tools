##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script automates the installation of Evaluate-STIG and MOST of its dependencies.

##################################################################################################
##################################################################################################


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

# Display user-friendly message
echo -e "${GREEN}[ ✔ ] Symbolic link created for PowerShell.${RESET}"
echo -e "${GREEN}[ + ] You can now execute PowerShell using: 'pwsh'${RESET}"

# Verify PowerShell installation
if command -v pwsh &>/dev/null; then
    echo -e "${GREEN}[ ✔ ] PowerShell installed successfully!${RESET}"
    echo -e "${GREEN}[ + ] PowerShell version: $(pwsh --version)${RESET}"
else
    echo -e "${RED}[ ✖ ] PowerShell installation failed!${RESET}"
    exit 1
fi

# Install Evaluate-STIG
echo -e "${GREEN}[ + ] Installing Evaluate-STIG...${RESET}"

mkdir -p /opt/Evaluate-STIG
unzip -q ./Evaluate-STIG*.zip -d /opt/Evaluate-STIG  # Quiet extraction

# Add execute permissions
chmod +x /opt/Evaluate-STIG/Evaluate-STIG/Prequisites/*.sh
chmod +x /opt/Evaluate-STIG/Evaluate-STIG/Evaluate-STIG.ps1

echo -e "${GREEN}[ ✔ ] Evaluate-STIG installed successfully!${RESET}"

# Test prerequisites
echo -e "${GREEN}[ + ] Testing prerequisites...${RESET}"
/opt/Evaluate-STIG/Evaluate-STIG/Prequisites/Test-Prequisites.sh

# Check for required packages
echo -e "${GREEN}[ + ] Checking for required packages...${RESET}"

missing_packages=()
for package in libicu lshw; do
    if ! rpm -q "$package" &>/dev/null; then
        missing_packages+=("$package")
    fi
done

# If missing packages were found, display an alert
if [ ${#missing_packages[@]} -ne 0 ]; then
    echo -e "${RED}[ ! ] The following packages are missing: ${missing_packages[*]}${RESET}"
    echo -e "${RED}[ ! ] Run eval_stig_dependency_check.sh to install them.${RESET}"
else
    echo -e "${GREEN}[ ✔ ] All required packages are installed.${RESET}"
fi
