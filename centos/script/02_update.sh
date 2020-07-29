#!/bin/bash -eux
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

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
  echo "==> Performing update"
  $pkg_cmd -y update
  reboot
  sleep 60
fi
