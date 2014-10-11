#!/bin/bash
#----------------------------------------
# Load Average check
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script check Load Average for last 5 minutes and sends mail alert if it crosses threshold limits

HOSTNAME=`hostname`
MYIP=`ifconfig | grep "inet addr" | head -1 | awk '{print $2}' | cut -d: -f2`
SUBJECT="High Load Average on $HOSTNAME - $MYIP"
NOTIFY=me@gmail.com
MAILFLG=0
# Modify Threshold as per server hardware configuration
THRESHOLD=12.0
OUTPUT=/scripts/loadavg.log
echo "CPU and IO Load Average for last 5 minutes exceeded threshold value" > $OUTPUT
echo " " >> $OUTPUT
LOADAVG1=`cat /proc/loadavg | awk '{print $1}'`
LOADAVG5=`cat /proc/loadavg | awk '{print $2}'`
LOADAVG15=`cat /proc/loadavg | awk '{print $3}'`

# Using BC for FLOAT value comparison #

COMPARE=`echo "$LOADAVG5 > $THRESHOLD" | bc`

if [ $COMPARE -eq 1 ];
then
        echo "Threshold value : $THRESHOLD" >> $OUTPUT
        echo "Last 1 minute Load Average is : $LOADAVG1" >> $OUTPUT
        echo "Last 5 minute Load Average is : $LOADAVG5" >> $OUTPUT
        echo "Last 15 minute Load Average is : $LOADAVG15" >> $OUTPUT
        MAILFLG=1
fi

if [ $MAILFLG = 1 ]
then
        cat $OUTPUT | mail -s "$SUBJECT" -v $NOTIFY -- -f admin@$HOSTNAME.com
        rm $OUTPUT
fi