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
echo "******* Starting -- apt-get update; apt-get upgrade"
sudo apt-get update -y
sudo apt-get upgrade -y
echo "******* Ending -- apt-get update; apt-get upgrade"

#
# Basic utils
#
# Required if you are planning to install VirtualBox
# Ref: https://www.virtualbox.org
#
echo "******* Starting -- apt-get install build-essential gcc make perl dkms"
sudo apt-get install build-essential gcc make perl dkms -y
echo "******* Ending -- apt-get install build-essential gcc make perl dkms"

#
# Time Service
#
echo "******* Starting -- apt install chrony"
sudo apt install chrony -y
echo "******* Ending -- apt install chrony"

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
echo "******* Starting -- apt install openssh-server"
sudo apt install openssh-server -y

#
# Allow X11 forwarding
#
SSHCONFIG=/etc/ssh/ssh_config

sudo sed -i "s/#   ForwardX11 no/    ForwardX11 yes/" $SSHCONFIG
sudo sed -i "s/#   ForwardX11Trusted yes/    ForwardX11Trusted yes/" $SSHCONFIG

sudo systemctl start sshd.service
sudo systemctl enable sshd.service
echo "******* Ending -- apt install openssh-server"

#
# Vino for VNC screen sharing (Headless server)
# Ref: https://tinyurl.com/setup-vino
#
# Change PASSWORD to your happy place! ;-)
#
echo "******* Starting -- VNC Vino"
PASSWORD="My!Pa5s$"
PASSWORD64=`echo -n '$PASSWORD' | base64`
sudo apt install vino -y
gsettings set org.gnome.Vino enabled true
gsettings set org.gnome.Vino require-encryption false
gsettings set org.gnome.Vino authentication-methods "['vnc']"
gsettings set org.gnome.Vino vnc-password '$PASSWORD64'
gsettings set org.gnome.Vino prompt-enabled false
echo "******* Ending -- VNC Vino"

#
# Setup Headless with dummy video driver
#
XORGCONFDIR=/usr/share/X11/xorg.conf.d
TMPDIR=/tmp/build-ubuntu-desktop
TMPDIRX11CONF=$TMPDIR/x11-xorg.conf.d

# don't need to be root for mkdir and cp
mkdir -p $TMPDIR/x11-xorg.conf.d
cp $XORGCONFDIR/*.conf $TMPDIRX11CONF

echo "******* Starting -- dummy video driver"
sudo apt-get install xserver-xorg-core -y
sudo apt-get install xorg-video-abi-23 -y
sudo apt-get install xserver-xorg-video-dummy -y
echo "******* Ending -- dummy video driver"

sudo cp $TMPDIRX11CONF/*.conf $XORGCONFDIR

GRUBFILE=/etc/default/grub

sudo sed -i "s/splash\"/splash nomodeset\"/" $GRUBFILE

echo "******* Starting -- update-grub"
sudo update-grub
echo "******* Ending -- update-grub"

#
# Create /usr/share/X11/xorg.conf.d/xorg.conf
#
echo "******* Starting -- xorg.conf setup"
XORGFILE=xorg.conf
DUMMYVIDCONF=/usr/share/X11/xorg.conf.d/xorg.conf

if [ -f "$DUMMYVIDCONF" ]; then
  sudo mv $DUMMYVIDCONF $DUMMYVIDCONF.orig
fi

cat << EOF >> $TMPDIR/$XORGFILE
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

sudo cp $TMPDIR/$XORGFILE $DUMMYVIDCONF
echo "******* Ending -- xorg.conf setup"

#
# Make the VNC user auto-logon
#
echo "******* Starting -- VNC user auto-logon"
VNCUSER=igel
GDM3FILE=/etc/gdm3/custom.conf

sudo sed -i "s/#  AutomaticLoginEnable/AutomaticLoginEnable/" $GDM3FILE
sudo sed -i "s/#  AutomaticLogin = user1/AutomaticLogin = $VNCUSER/" $GDM3FILE
echo "******* Ending -- VNC user auto-logon"

#
# Ready to reboot
#
# From your PC, make sure you can connect from SSH PRIOR to rebooting!
#
# REMOVE Video cable from system / server / PC after issuing reboot
#
#sudo reboot
