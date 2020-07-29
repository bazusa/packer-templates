#!/usr/bin/env bash

echo "==> Recording box generation date"
date > /etc/vagrant_box_build_date

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

# lsb_release is missing from CentOS, need to install
$pkg_cmd -y install redhat-lsb-core

echo "==> Customizing message of the day"
MOTD_FILE=/etc/motd
PLATFORM_RELEASE=$(lsb_release -sd)
PLATFORM_MSG=$(printf '%s' "$PLATFORM_RELEASE")
BUILT_MSG=$(printf 'built %s' "$(date +%Y-%m-%d)")
{
  printf '%0.1s' "-"{1..64}
  printf '\n'
  printf '%2s%-30s%30s\n' " " "${PLATFORM_MSG}" "${BUILT_MSG}"
  printf '%0.1s' "-"{1..64}
  printf '\n'
} >> ${MOTD_FILE}
