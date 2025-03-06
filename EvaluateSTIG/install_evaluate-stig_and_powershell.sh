###########################################################################################################################################
##########################################################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
###########################################################################################################################################
###########################################################################################################################################
# Description:
# This script automates the installation of Evaluate-STIG and PowerShell, then checks the system for the required dependencies to run.
###########################################################################################################################################
###########################################################################################################################################

#!/bin/bash

# TODO Check if EvaluateSTIG is already installed/ prompt user to continue or exit cleanly


# Define colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Trying out trap signals, maybe thi works
# Trap signals (e.g., CTRL+C or termination) and exit cleanly
trap 'echo -e "\n${RED}[ ✖ ] Script interrupted. Exiting cleanly...${RESET}"; exit 1' SIGINT SIGTERM

echo -e "\n[ + ] Installing PowerShell..."

# Check if PowerShell is installed, if not, then install it.
if command -v pwsh &>/dev/null; then
    echo -e "\n${GREEN}[ ✔ ]${RESET} PowerShell already installed"
    echo -e "\n[ + ] PowerShell version: $(pwsh --version)"
else
    # Create directory and extract PowerShell quietly
    mkdir -p /opt/powershell
    tar -xzf ./powershell-7.3.0*.tar.gz -C /opt/powershell &>/dev/null  # Quiet extraction
    chmod 744 /opt/powershell/pwsh
    chown -R root:root /opt/powershell
    # Create a symbolic link to the PowerShell executable
    ln -sf /opt/powershell/pwsh /usr/bin/pwsh
    # Verify PowerShell installation
    if command -v pwsh &>/dev/null; then
        echo -e "\n${GREEN}[ ✔ ]${RESET} PowerShell installed successfully"
        echo -e "\n[ + ] PowerShell version: $(pwsh --version)"
        echo -e '\n[ + ] You can now execute PowerShell using: "pwsh"'
    else
        echo -e "\n${RED}[ ✖ ] PowerShell installation failed!${RESET}"
        exit 1
    fi
fi

#TODO place evaluate stig check here.
# if evalstig is installed in /opt, prompt user to overwrite, else exit script cleanly
# echo question, read answer, can use case/esac to verify input

# Install Evaluate-STIG
echo -e "\n[ + ] Installing Evaluate-STIG..."
mkdir -p /opt/Evaluate-STIG
unzip -q ./Evaluate-STIG*.zip -d /opt/Evaluate-STIG  # Quiet extraction
chown -R root:root /opt/Evaluate-STIG

# Verify Evaluate-STIG proper extraction
if [ -d /opt/Evaluate-STIG/Evaluate-STIG ]; then
    echo -e "\n${GREEN}[ ✔ ]${RESET} Evaluate-STIG extracted successfully"
else
    echo -e "\n${RED}[ ✖ ]${RESET} Evaluate-STIG extraction failed"
    exit 1
fi

# Add execute permissions
echo -e "\n[ + ] Updating script permissions..."
chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/*.sh
chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/*.ps1
chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/*.sh
chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/*.ps1

# TODO: (Maybe)
# if stat -c "%a %n" ps1 and sh files, echo script persission set and echo the 
# Evaluate-STIG installed successfully in /opt/Evaluate-STIG line
# else echo unable to set all permissions, please verify permissions as needed

echo -e "\n${GREEN}[ ✔ ]${RESET} Evaluate-STIG installed successfully in /opt/Evaluate-STIG"

# # Test prerequisites
# echo -e "${GREEN}[ + ] Testing prerequisites...${RESET}"
# /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/Test-Prerequisites.sh

# Check for required packages
echo -e "\n[ + ] Checking for required packages..."

missing_packages=()
for package in libicu lshw; do
    if ! rpm -q "$package" &>/dev/null; then
        missing_packages+=("$package")
    fi
done

# If missing packages were found, display an alert
if [ ${#missing_packages[@]} -ne 0 ]; then
    echo -e "\n${RED}[ ! ]${RESET} The following packages are missing: ${missing_packages[*]}"
    echo -e "${RED}[ ! ]${RESET} Run eval_stig_dependency_check.sh to install them."
else
    echo -e "\n${GREEN}[ ✔ ]${RESET} All required packages are installed."
fi

echo -e "\n[ + ] Be sure to run /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/Test-Prerequisites.sh to test for other prerequisites" 
