#!/bin/bash 


 lockdir=/tmp/ReAuthATTONT.lock
 if mkdir "$lockdir"
 then
     echo >&2 "Re-authing ONT"

     # Remove lockdir when the script finishes, or when it receives a signal
     trap 'rm -rf "$lockdir"' 0    # remove directory when script finishes
     

     #Shutdown Wan port
     ifconfig igb0 down 
     /etc/rc.linkup stop wan

     #Power cycle ONT
     snmpset
     

     #Power on ATT gateway
     snmpset

     #Wait 3 min for gateway to Auth
     sleep 180

     # Power down gateway
     snmpset

     # Turn on Wan port
     ifconfig igb0 up 
     /etc/rc.linkup start wan

 else
     echo >&2 "cannot acquire lock, another ReAuth script is running"
     exit 0
 fi
