#!/bin/bash
#----------------------------------------
# MySQL replication skip by one position
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script comes handy when MySQL master-slave replication is stopped and you wish to skip the replication by jumping one postion while reading binary log
# This script must be placed on MySQL master server

done=0 
while [ $done -eq 0 ]; 
do 
	# get the status 
	done=$( mysql -uroot -psecret -Be 'show slave status;' | tail -1 | cut -f12 | grep Yes | wc -l ) 
	if [ $done -eq 0 ]; 
	then 
		echo "[`date`] Advancing position past [$(mysql -uroot -psecret -Be 'show slave status;' | tail -1 | cut -f20)]... " >> /scripts/mysql_replication_skip.log 
		mysql -uroot -psecret -Be "SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1; start slave;" 
		sleep 1 
	fi 
done 
