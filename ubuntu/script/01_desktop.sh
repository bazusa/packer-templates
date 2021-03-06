#!/usr/bin/env bash

# Check if script is running as a desktop installation.
# If not, exit without configuring UI
if [[ ! "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

# get version of ubuntu
ubuntu_version=$(lsb_release -r | awk '{ print $2 }')

echo "==> Installing ubuntu-desktop"
apt-get install -y ubuntu-desktop


if [ -d /etc/xdg/autostart/ ]; then
  echo "==> Disabling screen blanking"
  NODPMS_CONFIG=/etc/xdg/autostart/nodpms.desktop
  {
    echo "[Desktop Entry]"
    echo "Type=Application"
    echo "Name=nodpms"
    echo "Comment="
    echo "Exec=xset -dpms s off s noblank s 0 0 s noexpose"
    echo "Hidden=false"
    echo "NoDisplay=false"
    echo "X-GNOME-Autostart-enabled=true"
  } >> "$NODPMS_CONFIG"

  echo "==> Disabling screensaver"
  IDLE_DELAY_CONFIG=/etc/xdg/autostart/idle-delay.desktop
  {
    echo "[Desktop Entry]"
    echo "Type=Application"
    echo "Name=idle-delay"
    echo "Comment="
    echo "Exec=gsettings set org.gnome.desktop.session idle-delay 0"
    echo "Hidden=false"
    echo "NoDisplay=false"
    echo "X-GNOME-Autostart-enabled=true"
  } >> "$IDLE_DELAY_CONFIG"
fi
