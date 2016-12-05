#!/bin/bash

# darkstar checked out into parameter
DS_DIR=$1

if [ "" == "${DS_DIR}" ]; then
	printf "The first parameter must be the path to the DarkStar Git directory\n"
	exit 1
fi

# db info
DS_DB=dspdb
DS_USR=dspdb
DS_PWD=dspdb

for SQL in `ls -v ${DS_DIR}/sql/*.sql`
do
	echo "executing: ${SQL}"
	cat ${SQL} | mysql -u ${DS_USR} -p${DS_PWD} -h localhost ${DS_DB}
done

