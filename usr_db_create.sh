#!/bin/bash
#usr_db_create.sh
#contact:sandra.vahi@khk.ee
#script for creating new database users and databases faster
#
ARGUMENTS=3 		#number of args needed
ER=65 			#error code
MS=`which mysql`	#mysql use from /usr/bin/mysql

#SQL statement
	Q1="CREATE DATABASE IF NOT EXIST $1;"
	Q2="CREATE USER $2@localhost IDENTIFIED BY '$3'"
	Q3="GRANT USAGE ON *.* TO $2@localhost IDENTIFIED BY '$3';"
	Q4="GRANT ALL PRIVILEGES ON $1.* TO $2@localhost;"
	Q5="FLUSH PRIVILEGES"
	SQL="${Q1}${Q2}${Q3}${Q4}${Q5}"
#usage reminder
#display error
	if [ $# -ne $ARGUMENTS ]
	then
		echo "Example usage: $0 dbname dbuser dbpassword"
		exit  $ER
#root query
	$MS -u root -p -e "$SQL"
