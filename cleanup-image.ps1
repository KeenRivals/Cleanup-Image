# cleanup-image.ps1
# Clean up a Windows image by removing temporary files and superseded updates

Set-StrictMode -Version 2

# Remove junk added to the user's profile
$profilePaths = @(
  "$env:userprofile\Contacts",
  "$env:userprofile\Desktop",
  "$env:userprofile\Documents",
  "$env:userprofile\Music",
  "$env:userprofile\Pictures",
  "$env:userprofile\Videos"
)

Get-ChildItem $profilePaths | remove-item -recurse -force

# Cleanup WinSXS
Start-Process -NoNewWindow -Wait -File dism -ArgumentList "/online /Cleanup-Image /StartComponentCleanup /ResetBase"

# Cleanup downloaded Windows update files
net stop wauserv
Get-ChildItem C:\Windows\SoftwareDistribution | remove-item -recurse -force

# Cleanup Windows temp folders
Get-ChildItem C:\Windows\temp,$env:temp | remove-item -recurse -force

# Compact Windows Installer folder
Start-Process -NoNewWindow -Wait -File compact -ArgumentList "/C /S:$env:windir\Installer"
