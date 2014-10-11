#!/bin/bash
#----------------------------------------
# CPU usage monitoring script
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will check % of CPU used by a particular process (httpd in below example) and send mail if the its value exceeds THRESHOLD limits

MAILFLG=0
THRESHOLD=90
COUNT=0
CPUOUTPUT=/scripts/cpuTHRESHOLD.log
NOTIFY=me@gmail.com
HOSTNAME=`hostname`
MYIP=`ifconfig | grep "inet addr" | head -1 | awk '{print $2}' | cut -d: -f2`
SUBJECT="CPU Usage Monitor on $HOSTNAME - $MYIP - ProcessID: $PID alert"

for PID in `ps aux | grep httpd | awk '{print $2 }'`
do
	echo "CPU Usage  exceded THRESHOLD value for the process $PID for past 2 minutes: " > $CPUOUTPUT
	echo " " >> $CPUOUTPUT
	echo "THRESHOLD value : $THRESHOLD % " >> $CPUOUTPUT
	echo " " >> $CPUOUTPUT
	cpuusage=`ps --no-heading up $PID | awk '{use=int($3); print use}'`
	COUNT=0
	while [ ${cpuusage:-0} -gt $THRESHOLD ]
	do
		COUNT=$((`expr $COUNT+1`))
		echo "Process ID: $PID at check: $COUNT CPU usage : $cpuusage % " >> $CPUOUTPUT
		#sleep 12
		sleep 12
		if [ $COUNT = 10 ]
		then
			#ps --no-heading up $PID | awk '{print "Process ID: ", $2, "   CPU Usage: ", $3, "%"}' >> $CPUOUTPUT
			MAILFLG=1
			cat $CPUOUTPUT | mail -s "$SUBJECT" -v $NOTIFY
			rm $CPUOUTPUT
			break
		fi
	done
	COUNT=0
done