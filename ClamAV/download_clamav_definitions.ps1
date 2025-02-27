##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script downloads the latest ClamAV virus definitions and places them in a folder
# with the current date (MM-DD-YYYY) under the current user's Downloads\ClamAV_Updates directory.
##################################################################################################
##################################################################################################

# Define the base URL for ClamAV updates
$baseUrl = "https://database.clamav.net"

# Get the current date in the desired format (MM-DD-YYYY)
$folderName = Get-Date -Format "MM-dd-yyyy"

# Dynamically get the current user's Downloads folder path
$downloadsFolder = "C:\Users\$env:USERNAME\Downloads"

# Debugging: Print the value of $downloadsFolder
Write-Host "Downloads folder is: $downloadsFolder"

# Define the ClamAV_Updates directory path under the Downloads folder
$clamavUpdatesDir = Join-Path -Path $downloadsFolder -ChildPath "ClamAV_Updates"

# Create the ClamAV_Updates directory if it doesn't exist
if (-not (Test-Path -Path $clamavUpdatesDir)) {
    New-Item -ItemType Directory -Path $clamavUpdatesDir -Force | Out-Null
}

# Define the target directory where the updates will be saved (Downloads\ClamAV_Updates\MM-DD-YYYY)
$targetDirectory = Join-Path -Path $clamavUpdatesDir -ChildPath $folderName

# Create the target directory if it doesn't exist
if (-not (Test-Path -Path $targetDirectory)) {
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
}

# Define the files to download
$files = @(
    "main.cvd",
    "daily.cvd",
    "bytecode.cvd"
)

# Download each file and save it to the target directory
foreach ($file in $files) {
    $url = "$baseUrl/$file"
    $destinationPath = Join-Path -Path $targetDirectory -ChildPath $file

    # Output the download process
    Write-Host "Downloading $file to $destinationPath"

    # Download the file
    Invoke-WebRequest -Uri $url -OutFile $destinationPath
}

Write-Host "ClamAV updates downloaded to $targetDirectory"
