#!/bin/bash
#----------------------------------------
# Disk space usage check script
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will check % of file system used and send mail if it goes beyond THRESHOLD limits

MAILFLG=0
THRESHOLD=80
OUTPUT=/scripts/THRESHOLD.log
NOTIFY=me@gmail.com
HOSTNAME=`hostname`
MYIP=`ifconfig | grep "inet addr" | head -1 | awk '{print $2}' | cut -d: -f2`
SUBJECT="Disk space usage alert! $HOSTNAME Server - IP $MYIP "

# df /dev/ only
for filesystem in `df | awk '{ print $1 }'| grep /dev/`
do
	# df /dev/xvda1 only
	if [ $filesystem = '/dev/xvda1' ]
	then
		usage=`df $filesystem | tail -1 | awk '{ use=int($5); print use}'`
		if [ $usage -gt $THRESHOLD ]
		then
			df -h $filesystem >> $OUTPUT
			echo " " >> $OUTPUT
		fi
	else
		# df all others
		usage=`df $filesystem | tail -1 | awk '{ use=int($4); print use}'`
		if [ $usage -gt $THRESHOLD ]
                then
                        df -h $filesystem >> $OUTPUT
                        echo " " >> $OUTPUT
                fi
	fi
done

if [ -s /scripts/THRESHOLD.log ]
then
	echo " " >> $OUTPUT
	echo "File system usage threshold = " $THRESHOLD "%" >> $OUTPUT
	echo " " >> $OUTPUT
	cat $OUTPUT | mail -s "$SUBJECT" -v $NOTIFY -- -f admin@$HOSTNAME.com
	rm $OUTPUT
fi

