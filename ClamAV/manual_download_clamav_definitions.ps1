##################################################################################################
##################################################################################################
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali
##################################################################################################
##################################################################################################
# Description:
# This script opens the latest ClamAV virus definitions URLs in Google Chrome, 
# allowing the user to manually download them.
##################################################################################################
##################################################################################################

# Define the base URLs for ClamAV updates
$urls = @(
    "https://database.clamav.net/main.cvd",
    "https://database.clamav.net/daily.cvd",
    "https://database.clamav.net/bytecode.cvd"
)

# Path to Chrome (this might vary depending on your installation)
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

# Loop through each URL and open it in Google Chrome
foreach ($url in $urls) {
    Write-Host "Opening $url in Chrome"
    Start-Process $chromePath -ArgumentList $url
}
