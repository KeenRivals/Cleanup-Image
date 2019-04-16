# cleanup-image.ps1
# Clean up a Windows image by removing temporary files and superseded updates

Set-StrictMode -Version 2

workflow Cleanup-Image {

	parallel {
		Cleanup-Profiles

		# Cleanup WinSXS
		Start-Process -Wait -File dism -ArgumentList "/online /Cleanup-Image /StartComponentCleanup /ResetBase"

		# Empty Windows temp folders
		Get-ChildItem $env:windir\temp,$env:temp | remove-item -recurse -force -ErrorAction Ignore

		# Compact Windows Installer folder
		Start-Process -Wait -File compact -ArgumentList "/C /EXE:LZX /S:$env:windir\Installer"

		# Remove Appx packages for current user. They frequently prevent Sysprep from succeeding.
		Get-AppxPackage | Remove-AppxPackage -ErrorAction Ignore

		Cleanup-SoftwareDistribution
	}

}

# Remove junk added to the user profiles by application installers.
function Cleanup-Profiles {
	$profilePaths = @(
		"$env:systemdrive\Users\*\Contacts\*",
		"$env:systemdrive\Users\*\Desktop\*",
		"$env:systemdrive\Users\*\Documents\*",
		"$env:systemdrive\Users\*\Music\*",
		"$env:systemdrive\Users\*\Pictures\*",
		"$env:systemdrive\Users\*\Videos\*"
	)

	Get-ChildItem $profilePaths | remove-item -recurse -force

	return 0
}

# Delete downloaded Windows Update files
function Cleanup-SoftwareDistribution {
	Stop-Service "Wuauserv" -ErrorAction Ignore
	Get-ChildItem $env:windir\SoftwareDistribution | remove-item -recurse -force -ErrorAction Ignore
	return 0
}

Cleanup-Image

exit 0
