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
VBVERSIONB=6.1
VBVERSIONF=6.1.12
sudo apt update -y
sudo apt install virtualbox-$VBVERSIONB -y

wget https://download.virtualbox.org/virtualbox/$VBVERSIONF/Oracle_VM_VirtualBox_Extension_Pack-$VBVERSIONF.vbox-extpack

sudo VBoxManage extpack install Oracle_VM_VirtualBox_Extension_Pack-$VBVERSIONF.vbox-extpack
