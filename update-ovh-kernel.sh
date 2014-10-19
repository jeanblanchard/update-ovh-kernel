#!/bin/bash

# Configuration
INSTALLED_KERNEL_FILE="/var/run/ovh-kernel"
KERNEL_DIR="/boot"
KERNEL_VARIANT="grs-ipv6-64"
KERNEL_CHANNEL="production"
NOTIFY_REBOOT_REQUIRED_COMMAND=/usr/share/update-notifier/notify-reboot-required
UPDATE_GRUB_COMMAND=/usr/sbin/update-grub

#-----------------

# Installed kernel
[ -r "$INSTALLED_KERNEL_FILE" ] && installed=$(cat "$INSTALLED_KERNEL_FILE") || installed="unknown"

# Latest kernel
latest=$(ftp -n ftp.ovh.net<<EOF_FTP|awk -F ' -> ' '{print $2}' | sed 's/\/$//'
user anonymous anonymous
ls /made-in-ovh/bzImage/latest-$KERNEL_CHANNEL*
EOF_FTP
)

# Check and install
if [ "$latest" != "$installed" ]; then
  echo "Found new kernel version $latest (installed version is $installed)"
  echo "Downloading kernel v$latest"
  ftp -i -n ftp.ovh.net<<-EOF_FTP
	user anonymous anonymous
	cd /made-in-ovh/bzImage/latest-$KERNEL_CHANNEL
	lcd $KERNEL_DIR
	mget *-$KERNEL_VARIANT
	EOF_FTP
  if [ -x "$UPDATE_GRUB_COMMAND" ]; then
    echo "Updating grub config"
    export PATH=$PATH:$(dirname $UPDATE_GRUB_COMMAND)
    $UPDATE_GRUB_COMMAND
  fi
  echo "$latest" > "$INSTALLED_KERNEL_FILE"
  if [ -x "$NOTIFY_REBOOT_REQUIRED_COMMAND" ]; then
    echo "Notifying reboot required"
    export DPKG_MAINTSCRIPT_PACKAGE="linux-base"
    $NOTIFY_REBOOT_REQUIRED_COMMAND
  fi
fi

