#!/bin/bash
#----------------------------------------
# MySQL Database Size Report
# Date 11th Oct 2014
# Author: friendyogi@gmail.com
#----------------------------------------

# This script will list databases with disk space used and send it to mail

HOSTNAME=`hostname`
MYIP=`hostname --all-ip-addresses`
SUBJECT="MySQL Database Size Report `date +"%Y%m%d"` for $HOSTNAME - $MYIP"
BODY="MySQL Database Size Report `date +"%Y%m%d"` for $HOSTNAME - $MYIP is attached with this mail"
NOTIFY=me@gmail.com
mysql -uroot -psecret -H information_schema -s -e \
"SELECT  table_schema,
         ROUND(SUM(data_length+index_length)/1024/1024,2) AS TOTOL_IN_MB,
         ROUND(SUM(data_length)/1024/1024,2) AS TOTOAL_DATA_IN_MB,
         ROUND(SUM(index_length)/1024/1024,2) AS TOTAL_INDEX_IN_MB,
         COUNT(*) AS TABLES,
         CURDATE() AS TODAY
FROM     information_schema.tables
GROUP BY table_schema
ORDER BY 2 DESC;" > /scripts/dbsizes_`date +"%Y%m%d"`.html
echo $Body | mutt -a /scripts/dbsizes_`date +"%Y%m%d"`.html -s "$SUBJECT" $NOTIFY

## To find log files modified 30days before and delete them ##
find /scripts/dbsizes* -type f -mtime +30 -exec rm -f {} \;
