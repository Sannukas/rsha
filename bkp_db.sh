#!/bin/bash
#bkp_db.sh
#contact:sandra.vahi@khk.ee
#script for backing up all the mysql databases
#
#get current date
DT=`date +%Y-%m-%d`
#date factors separately for later use
Y=`date +%Y` M=`date +%m` D=`date +%d` H=`date +%H` MIN=`date +%M`
#database login 
DBUSR="root"
DBPWD=""
DBHOST="localhost"
#list all current databases
mysql -h $DBHOST -u $DBUSR -p $DBPWD -e "SHOW DATABASES;" > /tmp/databases.list
#make new folder with backup time
BKP_DIR=/home/backups/mysql/$Y/$M/$D/$H-$MIN
mkdir --parents --verbose $BKP_DIR
#Excluded databases list (Database is a part of SHOW DATABASES output)
EX=( 'Database' 'performance_schema' 'information_schema' )
NUM_EX=${#EX[@]}
for db in `cat /tmp/databases.list`
do
skip=0
let count=0
while [ $count -lt $NUM_EX ] ; do
#check against exclusions if not exclusion then skip
if [ "$db" = ${EX[$count]} ] ; then
	let skip=1
fi
	let count=$count+1
done
if [ $skip -eq 0 ] ; then
echo "++ $db"
#backup non-excluded databases
cd $BKP_DIR
bkp_name="$Y-$M-$D.$H-$MIN.$db.backup.sql"
bkp_tar_name="$bkp_name.tar.gz"
`/usr/bin/mysqldump -h "$DBHOST" "$db" -u "$DBUSR" > "$bkp_name"`
echo "Backuping $bkp_name"
`/bin/tar -zcf "$bkp_tar_name" "$bkp_name"`
echo "Compressing  $bkp_tar_name"
`/bin/rm "$bkp_name"`
echo "Cleaning up $bkp_name"
fi
done
`/bin/rm /tmp/databases.list`
#echo finishing message
echo "Backup has finished!"
