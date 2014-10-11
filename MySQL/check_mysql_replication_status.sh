#!/bin/bash
#----------------------------------------
# MySQL replication status script
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will send a replication status report to mail
# Place this script in MySQL master server

DONE=0
SUBJECT=''
BODY="Please find $HOSTNAME MySQL Master DB and Slave DB sync status attached with this mail"
NOTIFY=me@gmail.com
HOSTNAME=`hostname`
MYIP=`hostname --all-ip-addresses`
SLAVEIP="IP of remote slave server"
DBSLAVE="hostname of remote slave server"
DBMASTER=$HOSTNAME
HTML=/tmp/replication_status.html

DONE=$( mysql -uroot -psecret -h $DBSLAVE -Be 'show slave status;' | tail -1 | cut -f12 | grep Yes | wc -l )
if [ $DONE -eq 0 ];
then
	SUBJECT='$HOSTNAME: MySQL Master and Slave DB Replication Stopped'
else
	SUBJECT='$HOSTNAME: MySQL Master and Slave DB Replication Running'
fi

echo "<TABLE BORDER=1><TR><TH>$HOSTNAME MySQL DB replication running status:</TH></TR></TABLE>" > $HTML
echo "<p>&nbsp;</p>" >> $HTML
echo "<TABLE BORDER=1><TR><TH>Master Server ($DBMASTER/$MYIP)</TH></TR></TABLE>" >> $HTML
mysql -uroot -psecret -h $DBMASTER -H mysql -s -e \
	"show master status; " >> $HTML
echo "<p>&nbsp;</p>" >> $HTML
echo "<TABLE BORDER=1><TR><TH>Slave Server ($DBSLAVE/$SLAVEIP)</TH></TR></TABLE>" >> $HTML
mysql -uroot -psecret -h $DBSLAVE -H mysql -s -e \
	"show slave status \G; " >> $HTML
echo "<p>&nbsp;</p>" >> $HTML
echo $BODY | mutt -a $HTML -s "$SUBJECT" $NOTIFY 
rm $HTML