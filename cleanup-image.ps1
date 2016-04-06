# cleanup-image.ps1
# Clean up a Windows image by removing temporary files and superseded updates

Set-StrictMode -Version 2

# Remove junk added to the user profiles
$profilePaths = @(
  "$env:systemdrive\*\Contacts\*",
  "$env:systemdrive\*\Desktop\*",
  "$env:systemdrive\*\Documents\*",
  "$env:systemdrive\*\Music\*",
  "$env:systemdrive\*\Pictures\*",
  "$env:systemdrive\*\Videos\*"
)

Get-ChildItem $profilePaths | remove-item -recurse -force

# Cleanup WinSXS
Start-Process -NoNewWindow -Wait -File dism -ArgumentList "/online /Cleanup-Image /StartComponentCleanup /ResetBase"

# Cleanup downloaded Windows update files
net stop wuauserv
Get-ChildItem $env:windir\SoftwareDistribution | remove-item -recurse -force

# Cleanup Windows temp folders
Get-ChildItem $env:windir\temp,$env:temp | remove-item -recurse -force

# Compact Windows Installer folder
Start-Process -NoNewWindow -Wait -File compact -ArgumentList "/C /S:$env:windir\Installer"
