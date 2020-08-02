#!/bin/bash
# uncomment set and trap to trace execution
#set -x
#trap read debug

#
# Run this script after initial install
#
# If you try to run on an existing system, some of the commands,
# such as sed and cp, may not work as expected.
#
# This script will update and configure a FRESHLY installed version
# of Ubuntu Desktop 18.04 / 20.04 as a headless system (no attached
# monitor) that can be accessed via VNC (such as with RealVNC client).
#
# NOTE:  Make sure you can remote connect via a terminal session
#        with ssh ** BEFORE ** disconnecting video display cable and rebooting!
#
# Items installed / configured include:
#
#  - Prepped for a VirtualBox install
#  - Time service (chrony)
#  - OpenSSH
#  - VNC (Vino)
#  - Headless via dummy video driver
#

#
# Ubuntu 18.04 / 20.04 Desktop with:
#
# Lastest update / upgrade
sudo apt-get update -y
sudo apt-get upgrade -y

#
# Basic utils
#
# Required if you are planning to install VirtualBox
# Ref: https://www.virtualbox.org
#
sudo apt-get install build-essential gcc make perl dkms -y

#
# Time Service
#
sudo apt install chrony -y

#
# OpenSSH
#
# Actions after install may include:
#
#   - Generate key pairs in .ssh directory -- ssh-keygen
#   - Copy public key to remote server -- ssh-copy-id username@remote_host
#   - Test connection -- ssh -l username hostname
#   - Tunnel VNC -- ssh -l username -f -N -L 5900:localhost:5900 remote_host
#       VNC connection -- via localhost:5900
# Ref: https://tinyurl.com/ssh-setup
#
sudo apt install openssh-server -y
sudo systemctl start sshd.service
sudo systemctl enable sshd.service

#
# Vino for VNC screen sharing (Headless server)
# Ref: https://tinyurl.com/setup-vino
#
# Change PASSWORD to your happy place! ;-)
#
PASSWORD="My!Pa5s$"
PASSWORD64=`echo -n '$PASSWORD' | base64`
sudo apt install vino -y
gsettings set org.gnome.Vino enabled true
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password '$PASSWORD64'
gsettings set org.gnome.Vino prompt-enabled false

#
# Setup Headless with dummy video driver
#
XORGCONFDIR=/usr/share/X11/xorg.conf.d
TMPDIR=/tmp/build-ubuntu-desktop
TMPDIRX11CONF=$TMPDIR/x11-xorg.conf.d

# don't need to be root for mkdir and cp
mkdir -p $TMPDIR/x11-xorg.conf.d
cp $XORGCONFDIR/*.conf $TMPDIRX11CONF

sudo apt-get install xserver-xorg-core -y
sudo apt-get install xorg-video-abi-23 -y
sudo apt-get install xserver-xorg-video-dummy -y

sudo cp $TMPDIRX11CONFR/*.conf $XORGCONFDIR

GRUBFILE=/etc/default/grub

sudo sed -i "s/splash\"/splash nomodeset\"/" $GRUBFILE

sudo update-grub

#
# Create /usr/share/X11/xorg.conf.d/xorg.conf
#
DUMMYVIDCONF=/usr/share/X11/xorg.conf.d/xorg.conf

if [ -f "$DUMMYVIDCONF" ]; then
  sudo mv $DUMMYVIDCONF $DUMMYVIDCONF.orig
fi

sudo cat << EOF >> $DUMMYVIDCONF
Section "Device"
    Identifier  "Configured Video Device"
    Driver      "dummy"
EndSection

Section "Monitor"
    Identifier  "Configured Monitor"
    HorizSync 31.5-48.5
    VertRefresh 50-70
EndSection

Section "Screen"
    Identifier  "Default Screen"
    Monitor     "Configured Monitor"
    Device      "Configured Video Device"
    DefaultDepth 24
    SubSection "Display"
    Depth 24
    Modes "1024x800"
    EndSubSection
EndSection
EOF

#
# Make the VNC user auto-logon
#
VNCUSER=igel
GDM3FILE=/etc/gdm3/custom.conf

sudo sed -i "s/#  AutomaticLoginEnable/AutomaticLoginEnable/" $GDM3FILE
sudo sed -i "s/#  AutomaticLogin = user1/AutomaticLogin = $VNCUSER/" $GDM3FILE

#
# Ready to reboot
#
# From your PC, make sure you can connect from SSH PRIOR to rebooting!
#
# REMOVE Video cable from system / server / PC after issuing reboot
#
#sudo reboot
