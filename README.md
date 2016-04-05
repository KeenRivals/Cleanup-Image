# Cleanup-Image
Cleanup useless files and prepare a Windows image for capture.

# Requirements

* PowerShell
* DISM

# Process Overview 

* **Delete all data in user directories.** Such as Documents, Videos, Pictures, and Music. Many apps create folders in these directories when they are installed. If you use ``CopyProfile`` in your unattend.xml, you probably don't want users to have these junk directories.
* **Clean up the WinSXS directory using DISM.** Use the /cleanup-image DISM command to remove all superceded files from the WinSXS directory. This can recover quite a bit of space on systems which have had many updates installed. The downside is you can no longer uninstall Windows updates.
* **Delete all downloaded Windows Update files.** Stop the windows update service and delete the contents of ``C:\Windows\SoftwareDistribution``. Once updates are installed you don't need these.
* **Delete all temporary files.** Files in the current user's temp directory and Windows temp directory are deleted. If you use ``CopyProfile`` you especially don't want the current user's temp files in your image.
* **Compact the Windows Installer directory.** The C:\Windows\Installer directory contains MSIs for every piece of software installed. Compacting this directory can recover some space.
