#!/usr/bin/env bash

# Check if script is running as a desktop installation.
# If not, exit without configuring UI
if [[ ! "$DESKTOP" =~ ^(true|yes|on|1|TRUE|YES|ON])$ ]]; then
  exit
fi

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

# Minimal - gnome + X11
$pkg_cmd install -y gdm gnome-terminal gnome-classic-session gnome-shell-extension-dash-to-dock gnome-tweak-tool gedit
$pkg_cmd install -y xorg-x11-server-Xorg xorg-x11-drivers

# $pkg_cmd groupinstall -y 'GNOME'
# $pkg_cmd groupinstall -y 'x11' # Core Gnome and x11
# $pkg_cmd install -y gnome-shell-extension-dash-to-dock gnome-tweak-tool

echo "==> Set default session as graphical desktop"
systemctl set-default graphical.target

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

echo "==> Disable Wayland"
GDM_CONFIG=/etc/gdm/custom.conf
sed -i 's/#WaylandEnable/WaylandEnable/' $GDM_CONFIG
