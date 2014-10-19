update-ovh-kernel
=================

Kernel updater script for OVH dedicated servers.

This checks the [OVH FTP](ftp://ftp.ovh.net/made-in-ovh/bzImage/) for new kernel versions, downloads and installs them.

Installation
------------

Clone the repository, and add a root-owned copy of `update-ovh-kernel.sh` to your crontab. I suggest a daily execution.

Configuration
-------------

The script has a few configurable options, at the start of the file.

* `INSTALLED_KERNEL_FILE` is a file where the currently installed kernel version is written. It is updated when a new kernel is found and downloaded.
* `KERNEL_DIR` is the folder where the kernel images are downloaded.
* `KERNEL_VARIANT` is the kernel suffix. See [the FTP](ftp://ftp.ovh.net/made-in-ovh/bzImage/latest-production/) to find what variants are available.
* `KERNEL_CHANNEL` is the kernel channel. At the time of writing, the available options are `experimental`, `production` and `test` See the symlinks in [the FTP](ftp://ftp.ovh.net/made-in-ovh/bzImage/) for the full up-to-date list.
* `NOTIFY_REBOOT_REQUIRED_COMMAND` is the command run to notify the system of a required reboot. Unset it if you do not want this.
* `UPDATE_GRUB_COMMAND` is the command run to reload the boot manager configuration, after the new kernel image has been downloaded. Unset this if want to do a manual install.

