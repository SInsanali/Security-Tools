##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script creates an EICAR test file, scans it with ClamAV, and then removes the file.
##################################################################################################
##################################################################################################

#!/bin/bash

# Define colors
GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"

# Define the EICAR file location and test string
FILE="/tmp/eicar.txt"
EICAR_STRING='X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*'

# Verify that ClamAV is installed
if ! command -v clamscan &> /dev/null; then
    echo -e "\n[ ! ] ClamAV is not installed. Please install ClamAV before running this script."
    exit 1
fi

# Create the EICAR test file
echo -n "$EICAR_STRING" > "$FILE"

if [ -f "$FILE" ]; then
    echo -e "\n[ + ] Making EICAR test file                                          [${GREEN} OK ${RESET}]"
else
    echo -e "\n[ + ] Making EICAR test file                                          [${RED} FAIL ${RESET}]"
    exit 1
fi

# Scan the EICAR file with ClamAV
echo -e "\n[ + ] Scanning EICAR file with ClamAV"
clamscan "$FILE"

# Remove the EICAR file after scanning
rm -f "$FILE"

if [ ! -f "$FILE" ]; then
    echo -e "\n[ + ] Removing EICAR file                                             [${GREEN} OK ${RESET}]"
else
    echo -e "\n[ + ] Removing EICAR file                                             [${RED} FAIL ${RESET}]"
fi

echo -e "\n[ + ] Script execution completed successfully"
