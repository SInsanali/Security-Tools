# Windows System Information Collector Script
# Created by Sam Insanali
# GitHub: https://github.com/SInsanali

# Configuration
$homedir = "$env:USERPROFILE\Desktop"
$outputDir = "$homedir\System_Info_Collection"
$zipDir = "$homedir\$($env:COMPUTERNAME)_System_Info"
$zipFile = "$homedir\$($env:COMPUTERNAME)_System_Info.zip"

# Ensure directories exist
New-Item -Path $outputDir -ItemType Directory -Force | Out-Null
New-Item -Path $zipDir -ItemType Directory -Force | Out-Null

Write-Host "`n[ - ] Starting Host Information Collection" -ForegroundColor White
Get-Content "$env:SystemRoot\System32\drivers\etc\hosts" | Out-File "$outputDir\$($env:COMPUTERNAME)_hosts.txt"
Write-Host "[ + ] Completed Host Information Collection" -ForegroundColor Green

Write-Host "`n[ - ] Starting Installed Software Collection" -ForegroundColor White
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Format-Table -AutoSize | Out-File "$outputDir\$($env:COMPUTERNAME)_software.txt"
Write-Host "[ + ] Completed Installed Software Collection" -ForegroundColor Green

Write-Host "`n[ - ] Starting Port Information Collection" -ForegroundColor White
netstat -an | Out-File "$outputDir\$($env:COMPUTERNAME)_ports.txt"
Write-Host "[ + ] Completed Port Information Collection" -ForegroundColor Green

Write-Host "`n[ - ] Starting Running Processes Collection" -ForegroundColor White
Get-Process | Select-Object ProcessName, Id, CPU, StartTime | Format-Table -AutoSize | Out-File "$outputDir\$($env:COMPUTERNAME)_processes.txt"
Write-Host "[ + ] Completed Running Processes Collection" -ForegroundColor Green

Write-Host "`n[ - ] Starting Services Collection" -ForegroundColor White
Get-Service | Select-Object DisplayName, Name, Status | Format-Table -AutoSize | Out-File "$outputDir\$($env:COMPUTERNAME)_services.txt"
Write-Host "[ + ] Completed Services Collection" -ForegroundColor Green

Write-Host "`n[ - ] Starting Network Adapter Information Collection" -ForegroundColor White
Get-NetIPAddress | Format-Table -AutoSize | Out-File "$outputDir\$($env:COMPUTERNAME)_network_adapters.txt"
Write-Host "[ + ] Completed Network Adapter Information Collection" -ForegroundColor Green

Write-Host "`n[ - ] Preparing files for compression" -ForegroundColor White
Move-Item "$outputDir\*.txt" "$zipDir" -Force
Remove-Item "$outputDir" -Force -Recurse
Write-Host "[ + ] File preparation completed" -ForegroundColor Green

Write-Host "`n[ - ] Compressing the collected data" -ForegroundColor White
Compress-Archive -Path "$zipDir\*" -DestinationPath "$zipFile" -Force
Write-Host "[ + ] Data compression completed" -ForegroundColor Green

Write-Host "`n[ - ] Cleaning up temporary files" -ForegroundColor White
Remove-Item "$zipDir" -Force -Recurse
Write-Host "[ + ] Cleanup completed" -ForegroundColor Green

Write-Host "`n[ ! ] System information collection is complete. Check the file: $zipFile" -ForegroundColor Green
