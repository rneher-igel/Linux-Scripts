#!/bin/bash
# uncomment set and trap to trace execution
#set -x
#trap read debug

folder=Downloads
file=`date | sed "s/://g" | awk '{print $6"-"$2"-"$3"-"$4}'`-backup.tar.bz2

echo $file

#
# Create ~/Backups folder if it does not exist
#
BACKUPS=~/Backups

if [ ! -d "$BACKUPS" ]; then
  mkdir $BACKUPS
fi

tar cvjf ~/Backups/$file ~/$folder
