#!/usr/bin/env bash

SSH_USER=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ virtualbox ]]; then
  echo "==> Installing VirtualBox guest additions"
  apt-get install -y linux-headers-"$(uname -r)" build-essential
  apt-get -y install dkms

  VBOX_VERSION=$(cat /home/"${SSH_USER}"/.vbox_version)
  mount -o loop /home/"${SSH_USER}"/VBoxGuestAdditions_"$VBOX_VERSION".iso /mnt
  sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm /home/"${SSH_USER}"/VBoxGuestAdditions_"$VBOX_VERSION".iso
  rm /home/"${SSH_USER}"/.vbox_version
fi
