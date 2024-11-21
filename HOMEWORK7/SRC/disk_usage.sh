#!/bin/bash

LOGFILE="/var/log/disk.log"
THRESHOLD=$1
USEDISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$USEDISK" -gt "$THRESHOLD" ]; then
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$TIME - Disk usage is at ${USEDISK}%" >> "$LOGFILE"
fi

~                                                                                                                                                                                     
~                                                                                                                                                                                     
~                                        