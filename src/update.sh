#!/bin/bash

log="update.log"

[ -f $log ] && echo > $log || touch $log
echo `date` >> $log
echo "-------------UPDATES---------------" >> $log
pacman -Syyu --noconfirm &>> $log
intUpdateCode=$?
echo "-------------ORPHANS---------------" >> $log
pacman -Rns --noconfirm `pacman -Qdtq` &>> $log
intOrphansCode=$?
echo "-------------DONE---------------" >> $log
echo `date` >>  $log
printf "\n\n" >> $log
strNoUpdates=`cat $log | grep 'nothing to do'`
strNoOrphans=`cat $log | grep 'no targets specified'`

if [ $intUpdateCode = 0 ]; then
  [ -z "$strNoUpdates" ] && echo "got updates" >> $log || echo "no updates" >> $log
else
  printf "_---------- failed to update ERROR CODE: $intUpdateCode\n\n" >> $log
fi
[ $intOrphansCode = 0 ] && echo "removed orphans" >> $log
[ $intOrphansCode = 1 ] && echo "no orphans" >> $log
[ $intOrphansCode -gt 1 ] && printf "_--------- failed to remove orphans ERROR CODE: $intOrphansCode\n" >> $log

if [ $intUpdateCode = 0 -a -z "$strNoUpdates" ]; then
  echo "-- reboot --" >> $log;
  reboot now
fi
