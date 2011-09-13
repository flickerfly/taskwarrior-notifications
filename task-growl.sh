#!/bin/bash

# For mac users - send notifications to growl. 
# Requires growlnotify which is available in the
# growl Extra install img.
# http://growl.info/extras.php

num=`task active | wc -l`
if [ $num -gt "1" ]
  then
    growlnotify -s -n taskwarrior -t "Active Tasks" -m "`task active | tail -n +3`"
  else
    growlnotify -s -n taskwarrior -t "No Active Tasks"  -m "C'mon! What are you doing?"
fi

