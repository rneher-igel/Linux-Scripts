# Linux Scripts

***
## Build Folder: Script Name and Description

| Name | Description |
|------|-------------|
|[build-ubuntu-desktop.sh](build/build-ubuntu-desktop.sh)|Script to update and configure a FRESHLY installed version of Ubuntu Desktop 18.04 / 20.04 as a headless system (no attached monitor) that can be accessed via VNC (such as with RealVNC client).<br/><br/> Items installed / configured include:<br/> - Prepped for a VirtualBox install<br/> - Time service (chrony)<br/> - OpenSSH<br/> - VNC (Vino)<br/> - Headless via dummy video driver<br/>|
|[build-ubuntu-igel-icg.sh](build/build-ubuntu-igel-icg.sh)|Setup a hardened ICG server. The script will update and configure a FRESHLY installed version of Ubuntu Server 18.04 / 20.04.<br/><br/> Items installed / configured include:<br/> - Prepped for a IGEL ICG install <br /> - Time service (chrony) <br /> - OpenSSH <br /> - UFW Firewall <br /> - Fail2ban Automatic Banning <br /> - Rootkit Hunter (Rkhunter) <br /> - Port Knocking (Knockd) -- Note: install knock client on PC |
|[virtualbox-install.sh](build/virtualbox-install.sh)|Script to install VirtualBox.<br/> VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use. Not only is VirtualBox an extremely feature rich, high performance product for enterprise customers, it is also the only professional solution that is freely available as Open Source Software under the terms of the GNU General Public License (GPL) version 2.|
|[updateos.sh](build/updateos.sh)|Script to update / upgrade OS.|
|[mk-backup.sh](build/mk-backup.sh)|Script to make a backup of a folder.|

***
## SSH Folder: Script Name and Description
OpenSSH Notes:
```{openssh}
- Generate key pairs in .ssh directory --> ssh-keygen
- Copy public key to remote server --> ssh-copy-id username@remote_host
- Test connection --> ssh -l username hostname
- Forward X11 --> ssh -X -l username hostname
- Forward X11 compressed --> ssh -X -C -l username hostname
- Tunnel VNC --> ssh -l username -f -N -L 5900:localhost:5900 remote_host
    VNC connection
  ```
Ref: https://tinyurl.com/ssh-setup
| Name | Description |
|------|-------------|
|[config](ssh/config)|Sample configuration file for SSH.|
|[ssh-home.sh](ssh/ssh.home.sh)|SSH to an alias (home) in config|
|[ssh-away.sh](ssh/ssh.away.sh)|SSH to an alias (away) in config|
|[vnc-home.sh](ssh/vnc-home.sh)|VNC tunnel connection on home network|
|[vnc-away.sh](ssh/vnc-away.sh)|VNC tunnel connection on internet network|
|[rsync-vb.sh](ssh/rsync-vb.sh)|RSYNC via SSH connection|
***
***
### Revision Summary

| Element<br/>Version | Date | Change Owner | Description |
| ---- | ---- | ---- | ---- |
| 0.2 | 06-August-2020 | Ron Neher | Minor updates based on feedback |
| 0.1 | 02-August-2020 | Ron Neher | Ubuntu headless |

***
***
### Outstanding Issues

| Ref  | Description |
| ---- | ----------- |
| OI.1 | TBD         |

foo:
```{foo}
Hell-o foo
same to you. ;-)
  ```
