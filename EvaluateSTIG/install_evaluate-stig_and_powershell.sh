#!/bin/bash

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

# Define colors for output
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Function to install powershell
install_powershell() {
     # Create directory and extract PowerShell quietly
    mkdir -p /opt/powershell
    tar -xzf ./powershell-7.3.0*.tar.gz -C /opt/powershell &>/dev/null  # Quiet extraction
    chmod 744 /opt/powershell/pwsh
    chown -R root:root /opt/powershell
    # Create a symbolic link to the PowerShell executable
    ln -sf /opt/powershell/pwsh /usr/bin/pwsh
    # Verify PowerShell installation
    if command -v pwsh &>/dev/null; then
        echo -e "\n${GREEN}[ + ]${RESET} PowerShell installed successfully"
        echo -e "\n[ + ] PowerShell version: $(pwsh --version)"
        echo -e '\n[ + ] You can now execute PowerShell using: "pwsh"'
    else
        echo -e "\n${RED}[ ! ] PowerShell installation failed!${RESET}"
        exit 1
    fi
}

# Function to install Evaluate-STIG
install_eval_stig() {
    echo -e "\n[ + ] Installing Evaluate-STIG..."
    mkdir -p /opt/Evaluate-STIG
    unzip -q ./Evaluate-STIG*.zip -d /opt/Evaluate-STIG  # Quiet extraction
    chown -R root:root /opt/Evaluate-STIG

    # Verify Evaluate-STIG proper extraction
    if [ -d /opt/Evaluate-STIG/Evaluate-STIG ]; then
        echo -e "\n${GREEN}[ + ]${RESET} Evaluate-STIG extracted successfully"
    else
        echo -e "\n${RED}[ ! ]${RESET} Evaluate-STIG extraction failed"
        exit 1
    fi

    # Set script permissions
    echo -e "\n[ + ] Updating script permissions..."
    chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/*.sh
    chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/*.ps1
    chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/*.sh
    chmod 700 /opt/Evaluate-STIG/Evaluate-STIG/*.ps1
}

# Function to check dependencies
check_dependencies(){
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
        echo -e "\n${GREEN}[ + ]${RESET} All required packages are installed."
        dependencies_installed=true
    fi
}

# Trying out trap signals, maybe thi works
# Trap signals (e.g., CTRL+C or termination) and exit cleanly
trap 'echo -e "\n${RED}[ ! ]${RESET} Script interrupted. Exiting cleanly..."; exit 1' SIGINT SIGTERM

# Verify script is ran with sudo/ as root
if [[ $EUID -ne 0 ]]; then
    echo -e "\n${RED}[ ! ]${RESET} This script must be run as root."
    exit 1
fi

echo -e "\n[ + ] Installing PowerShell..."

# Check if PowerShell is installed, if not, then install it.
if command -v pwsh &>/dev/null; then
    echo -e "\n${GREEN}[ + ]${RESET} PowerShell already installed"
    echo -e "\n[ + ] PowerShell version: $(pwsh --version)"
else
    install_powershell
fi

# Check if Evaluate-STIG is installed
if [ -d /opt/Evaluate-STIG ]; then
    # Input validation loop for yes/no (y/n) response
    while true; do
        echo -e "\n[ ! ] Evaluate-STIG already installed, proceed with new install? [y/n]:"
        read -r overwrite_answer
        case $overwrite_answer in
            [Yy]* )
                install_eval_stig
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
else
    install_eval_stig 
fi

# TODO: (Maybe)
# if stat -c "%a %n" ps1 and sh files, echo script persission set and echo the 
# Evaluate-STIG installed successfully in /opt/Evaluate-STIG line
# else echo unable to set all permissions, please verify permissions as needed

echo -e "\n${GREEN}[ + ]${RESET} Evaluate-STIG installed successfully in /opt/Evaluate-STIG"

# Check for the installed dependencies
check_dependencies

if [ "$dependencies_installed" = true ]; then
    echo -e "\n[ + ] Be sure to run /opt/Evaluate-STIG/Evaluate-STIG/Prerequisites/Test-Prerequisites.sh to test for other prerequisites" 
fi

