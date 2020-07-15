#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

# Additional useful packages
apt-get install -y libgtk2.0-0
apt-get install -y conky-all
apt-get install -y aria2

# Install & configure apt-fast
add-apt-repository ppa:apt-fast/stable
apt-get update
apt-get install -y apt-fast
echo debconf apt-fast/maxdownloads string 16 | debconf-set-selections
echo debconf apt-fast/dlflag boolean true | debconf-set-selections
echo debconf apt-fast/aptmanager string apt-get | debconf-set-selections

# install vscodium and create a useful alias
snap install codium --classic
echo alias code=\'codium\' >> .bashrc
