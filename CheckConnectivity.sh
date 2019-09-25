#!/bin/sh

#=====================================================================
# USER SETTINGS
#
# Set multiple ping targets separated by space.  
ALLDEST=" 68.94.156.1 208.67.222.222 1.1.1.1 8.8.8.8 162.237.100.1"
#=====================================================================

FailCOUNT=0
SuccessCOUNT=0

	for DEST in $ALLDEST
	do
 
                ping -c 3 -t 3 "$DEST" > /dev/null
                if [ $? -eq 0 ]; then
                     echo "$DEST is reachable"
                     SuccessCOUNT=`expr $SuccessCOUNT + 1` 
                else
                     echo "$DEST is unreachable"
                     FailCOUNT=`expr $FailCOUNT + 1`
                fi
 	done

	if [ $FailCOUNT -ge $SuccessCOUNT ]
	then
	   logger -s  "Internet connectivity check failed: $SuccessCOUNT site(s) reachable, $FailCOUNT unreachable. Calling ONT re-auth script"
           /CustomScripts/ReAuthATTONT.sh 2>&1 | logger -i -s
        else
           echo "Internet connectivity check success: $SuccessCOUNT site(s) reachable, $FailCOUNT unreachable. Exiting" 

	fi
