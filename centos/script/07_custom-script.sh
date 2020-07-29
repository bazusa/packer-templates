#!/usr/bin/env bash

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

# Additional useful packages
$pkg_cmd install -y aria2

# Install codium and set alias to 'code'
rpm --import https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg
printf "[gitlab.com_paulcarroty_vscodium_repo]\nname=gitlab.com_paulcarroty_vscodium_repo\nbaseurl=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/rpms/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg" |sudo tee -a /etc/yum.repos.d/vscodium.repo
$pkg_cmd install -y codium
echo alias code=\'codium\' >> .bashrc
