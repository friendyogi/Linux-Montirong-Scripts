#!/bin/bash
#----------------------------------------
# MySQL Table Size Report
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will list tables with disk space used and send it to mail

HOSTNAME=`hostname`
MYIP=`hostname --all-ip-addresses`
SUBJECT="MySQL Table Size Report `date +"%Y%m%d"` for $HOSTNAME - $MYIP"
BODY="MySQL Table Size Report `date +"%Y%m%d"` for $HOSTNAME - $MYIP is attached with this mail"
NOTIFY=me@gmail.com
mysql -uroot -psecret -H information_schema -s -e \
"SELECT  table_name,
        ROUND(((data_length + index_length) / (1024*1024)),2) AS USAGE_IN_MB,
        table_schema
FROM    information_schema.tables
ORDER BY 2 DESC LIMIT 20;" > /scripts/tablesizes_`date +"%Y%m%d"`.html
echo $BODY | mutt -a /scripts/tablesizes_`date +"%Y%m%d"`.html -s "$SUBJECT" $NOTIFY

## To find log files modifiled 30days before and delete them ##
find /scripts/tablesizes* -type f -mtime +30 -exec rm -f {} \;
