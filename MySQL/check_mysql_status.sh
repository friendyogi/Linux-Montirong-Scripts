#!/bin/bash
#----------------------------------------
# Check MySQL service status
# Date 18th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will capture number of PIDs of mysql service and if not found send an email alert

COUNT_PID=`pgrep mysql | wc -l`

if [ $COUNT_PID -lt 1 ]
then
	echo "Problem, $COUNT_PID"
else
	echo $COUNT_PID
fi

