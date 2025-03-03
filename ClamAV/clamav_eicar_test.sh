#!/bin/bash

##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
# Description:
# This script creates an EICAR test file, scans it with ClamAV, and then removes the file.
##################################################################################################

# Verify that ClamAV is installed
if ! command -v clamscan &> /dev/null; then
    echo "[ ! ] ClamAV is not installed. Please install ClamAV before running this script."
    exit 1
fi

# Define the EICAR file location and test string
FILE="/tmp/eicar.txt"
EICAR_STRING='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Create the EICAR test file
echo "[ + ] Making EICAR test file"
echo -n "$EICAR_STRING" > "$FILE"

# Scan the EICAR file with ClamAV
echo -e "\n[ + ] Scanning EICAR file with ClamAV"
clamscan "$FILE"

# Remove the EICAR file after scanning
echo -e "\n[ + ] Removing EICAR file"
rm -f "$FILE"

echo -e "\n[ + ] Done!"
