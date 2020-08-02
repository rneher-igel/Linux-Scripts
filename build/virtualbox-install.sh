#!/bin/bash
#set -x
#trap read debug

#
# Prep for ability to use apt install
#
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"

#
# Determine VirtualBox version to install
#   set variable VBVERSION to match
#
VBVERSION=6.1.12
sudo apt update -y
sudo apt install virtualbox-$VBVERSION -y

wget https://download.virtualbox.org/virtualbox/6.1.12/Oracle_VM_VirtualBox_Extension_Pack-6.1.12.vbox-extpack
wget https://download.virtualbox.org/virtualbox/$VBVERSION/Oracle_VM_VirtualBox_Extension_Pack-$VBVERSION.vbox-extpack

sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-6.1.12.vbox-extpack
