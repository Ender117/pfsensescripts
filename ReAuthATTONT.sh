    
#!/bin/bash 


 lockdir=/tmp/ReAuthATTONT.lock
 if mkdir "$lockdir"
 then
     echo >&2 "Re-authing ONT"

     # Remove lockdir when the script finishes, or when it receives a signal
     trap 'rm -rf "$lockdir"' INT TERM EXIT    # remove directory when script finishes
     

     #Shutdown Wan port
     /etc/rc.linkup stop wan
     ifconfig igb0 down 


     #Power cycle ONT, ensure gateway is down
     /usr/local/bin/snmpset -v 1 -c community ip .1.3.6.1.4.1.850.100.1.10.2.1.4.10 i 1
     /usr/local/bin/snmpset -v 1 -c community ip .1.3.6.1.4.1.850.100.1.10.2.1.4.9 i 3
     sleep 15

     #Power on ATT gateway
     /usr/local/bin/snmpset -v 1 -c community ip .1.3.6.1.4.1.850.100.1.10.2.1.4.10 i 2

     #Wait 2.5 min for gateway to Auth
     sleep 150

     # Power down gateway
     /usr/local/bin/snmpset -v 1 -c community ip .1.3.6.1.4.1.850.100.1.10.2.1.4.10 i 1
#     sleep 3 

     # Turn on Wan port
     ifconfig igb0 up 
     /etc/rc.linkup start wan

     echo >&2 "ONT re-auth sequence complete, waiting for internet connectivity to reestablish."
     sleep 60

 else
     echo >&2 "cannot acquire lock, another ReAuth script already running"

 fi
