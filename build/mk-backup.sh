#!/bin/bash
# uncomment set and trap to trace execution
#set -x
#trap read debug

FOLDER=~/Downloads
FILE=`date | sed "s/://g" | awk '{print $6"-"$2"-"$3"-"$4}'`-backup.tar.bz2

echo $FILE

#
# Create ~/Backups folder if it does not exist
#
BACKUPS=~/Backups

if [ ! -d "$BACKUPS" ]; then
  mkdir $BACKUPS
fi

tar cvjf $BACKUPS/$FILE $FOLDER
