#!/bin/bash -eux

DISK_USAGE_BEFORE_MINIMIZE=$(df -h)

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

echo "==> Removing packages"
$pkg_cmd remove -y epel-release flex fprintd gnome-getting-started-docs gnome-initial-setup gnome-screenshot gnome-software gnome-user-docs gnome-weather initial-setup libvirt-daemon

echo "==> Removing man pages"
rm -rf /usr/share/man/*
echo "==> Removing any docs"
rm -rf /usr/share/doc/*
echo "==> Removing caches"
find /var/cache -type f -exec rm -rf {} \;

echo "==> Disk usage before minimize"
echo "${DISK_USAGE_BEFORE_MINIMIZE}"

echo "==> Disk usage after minimize"
df -h
