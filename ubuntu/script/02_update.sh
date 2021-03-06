#!/bin/bash -eux

# Disable the release upgrader
echo "==> Disabling the release upgrader"
sed -i.bak 's/^Prompt=.*$/Prompt=never/' /etc/update-manager/release-upgrades

echo "==> Checking version of Ubuntu"
. /etc/lsb-release

echo "==> Disabling periodic apt upgrades"
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic

echo "==> Updating list of repositories"
apt-get -y update

if [[ $UPDATE  =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
  echo "==> Performing dist-upgrade (all packages and kernel)"
  apt-get -y dist-upgrade --force-yes
  reboot
  sleep 60
fi
