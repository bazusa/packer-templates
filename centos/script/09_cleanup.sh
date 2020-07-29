#!/usr/bin/env bash

SSH_USER=${SSH_USERNAME:-vagrant}
DISK_USAGE_BEFORE_CLEANUP=$(df -h)

echo "==> Cleaning up udev rules"
rm -f /etc/udev/rules.d/70-persistent-net.rules;
mkdir -p /etc/udev/rules.d/70-persistent-net.rules;
rm -f /lib/udev/rules.d/75-persistent-net-generator.rules;
rm -rf /dev/.udev/;

echo "==> Cleaning up leftover dhcp leases"
if [ -d "/var/lib/dhcp" ]; then
  rm /var/lib/dhcp/*
fi

# Add delay to prevent "vagrant reload" from failing
echo "pre-up sleep 2" >> /etc/network/interfaces

echo "==> Cleaning up tmp"
rm -rf /tmp/* /var/tmp/*

# Remove Bash history
unset HISTFILE
rm -f /root/.bash_history
rm -f /home/"${SSH_USER}"/.bash_history

# truncate any logs that have built up during the install
find /var/log -type f -exec truncate --size=0 {} \;

echo "==> Clearing last login information"
>/var/log/lastlog
>/var/log/wtmp
>/var/log/btmp

# CentOS version info - e.g., CentOS 7.8.2003 (v7.8 released March 2020)
# full_version=$(< /etc/centos-release tr -dc '0-9.')
major_version=$(< /etc/centos-release tr -dc '0-9.'|cut -d \. -f1)
# minor_version=$(< /etc/centos-release tr -dc '0-9.'|cut -d \. -f2)
# date_stamp=$(< /etc/centos-release tr -dc '0-9.'|cut -d \. -f3)

if [ "$major_version" -ge 8 ] ; then
  pkg_cmd="dnf"
else
  pkg_cmd="yum"
fi

# remove previous kernels that yum/dnf preserved for rollback
if [ "$major_version" -ge 8 ]; then
  dnf autoremove -y
  dnf remove -y $(dnf repoquery --installonly --latest-limit=-1 -q)
elif [ "$major_version" -gt 5 ]; then # yum-utils isn't in RHEL 5 so don't try to run this
  if ! command -v package-cleanup >/dev/null 2>&1; then
  yum install -y yum-utils
  fi
  package-cleanup --oldkernels --count=1 -y
fi

# Remove development and kernel source packages
$pkg_cmd -y remove gcc cpp kernel-devel kernel-headers;

$pkg_cmd remove -y \
  aic94xx-firmware \
  atmel-firmware \
  bfa-firmware \
  ipw2100-firmware \
  ipw2200-firmware \
  ivtv-firmware \
  iwl1000-firmware \
  iwl3945-firmware \
  iwl4965-firmware \
  iwl5000-firmware \
  iwl5150-firmware \
  iwl6000-firmware \
  iwl6050-firmware \
  kernel-uek-firmware \
  libertas-usb8388-firmware \
  netxen-firmware \
  ql2xxx-firmware \
  rt61pci-firmware \
  rt73usb-firmware \
  zd1211-firmware \
  linux-firmware \
  microcode_ctl

$pkg_cmd -y clean all;

# remove the install log
rm -f /root/anaconda-ks.cfg

# clear the history so our install isn't there
export HISTSIZE=0
rm -f /root/.wget-hsts

# Blank netplan machine-id (DUID) so machines get unique ID generated on boot.
if [ "$major_version" -ge 7 ]; then
  truncate -s 0 /etc/machine-id
fi

echo "==> Disable GRUB"
GRUB_CONFIG=/etc/default/grub
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' $GRUB_CONFIG
echo "GRUB_DISABLE_OS_PROBER=true" >> $GRUB_CONFIG
grub2-mkconfig -o /boot/grub2/grub.cfg

# Whiteout root
count=$(df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count
rm /tmp/whitespace

# Whiteout /boot
count=$(df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}')
let count--
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count
rm /boot/whitespace

# Zero out the free space to save space in the final image
dd if=/dev/zero of=/EMPTY bs=1M  || echo "dd exit code $? is suppressed"
rm -f /EMPTY

# Make sure we wait until all the data is written to disk, otherwise
# Packer might quit too early before the large files are deleted
sync

echo "==> Disk usage before cleanup"
echo "${DISK_USAGE_BEFORE_CLEANUP}"

echo "==> Disk usage after cleanup"
df -h
