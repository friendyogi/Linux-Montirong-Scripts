#!/bin/bash
#----------------------------------------
# JVM Memory check script
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will send mail if any Java process is consuming more than TRHESHOLD limit of memory

HOSTNAME=`hostname`
MYIP=`ifconfig | grep "inet addr" | head -1 | awk '{print $2}' | cut -d: -f2`
SUBJECT="JVM Resident Memory Monitor $HOSTNAME - $MYIP"
MAILFLG=0
THRESHOLD=921600
JVMOUTPUT=/scripts/jvmthreshold.log
NOTIFY=me@gmail.com

echo "JVM Resident Memory exceeded threshold value for following processes: " > $JVMOUTPUT
echo " " >> $JVMOUTPUT

for PID in `ps aux | grep /usr/java | awk '{print $2 }'`
do
	usage=`ps --no-heading up $PID | awk '{use=int($6); print use}'`
	if [ ${usage:-0} -gt $THRESHOLD ]
	then
		echo "Threshold value : $THRESHOLD KBytes" >> $JVMOUTPUT
		ps --no-heading up $PID | awk '{print "Process ID: ", $2, "   Resident Memory: ", $6, "K Bytes"}' >> $JVMOUTPUT
		THRESHOLD=921600
		MAILFLG=1
	fi
	THRESHOLD=921600
done
if [ $MAILFLG = 1 ]
then
	cat $JVMOUTPUT | mail -s "$SUBJECT" -v $NOTIFY -- -f admin@$HOSTNAME.com
	rm $JVMOUTPUT
fi
