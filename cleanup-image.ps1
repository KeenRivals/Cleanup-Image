# cleanup-image.ps1
# Clean up a Windows image by removing temporary files and superseded updates

Set-StrictMode -Version 2

# Remove junk added to the user profiles
$profilePaths = @(
  "$env:systemdrive\Users\*\Contacts\*",
  "$env:systemdrive\Users\*\Desktop\*",
  "$env:systemdrive\Users\*\Documents\*",
  "$env:systemdrive\Users\*\Music\*",
  "$env:systemdrive\Users\*\Pictures\*",
  "$env:systemdrive\Users\*\Videos\*"
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
Start-Process -NoNewWindow -Wait -File compact -ArgumentList "/C /EXE:LZX /S:$env:windir\Installer"
