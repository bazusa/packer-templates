#!/usr/bin/env bash

SSH_USER=${SSH_USERNAME:-vagrant}

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

echo "==> Installing prerequirements"
# dnf -y install bzip2 elfutils-libelf-devel epel-release gcc kernel-devel-`uname -r` kernel-headers perl tar
# dnf -y install dkms

$pkg_cmd -y install bzip2 elfutils-libelf-devel epel-release gcc kernel-devel kernel-headers perl

if [ "$major_version" -eq 7 ] ; then
  echo "==> Fix epel-release repo issue on CentOS 7"
  EPEL_REPO=/etc/yum.repos.d/epel.repo
  sed -i 's/#baseurl/baseurl/' $EPEL_REPO
  sed -i 's/metalink/#metalink/' $EPEL_REPO
fi

$pkg_cmd -y install dkms

echo "==> Installing VirtualBox guest additions"
VBOX_VERSION=$(cat /home/"${SSH_USER}"/.vbox_version)
mount -o loop /home/"${SSH_USER}"/VBoxGuestAdditions_"$VBOX_VERSION".iso /mnt
sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm /home/"${SSH_USER}"/VBoxGuestAdditions_"$VBOX_VERSION".iso
rm /home/"${SSH_USER}"/.vbox_version
