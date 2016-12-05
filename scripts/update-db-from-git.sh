#!/bin/bash

# darkstar checked out into parameter
DS_DIR=$1

if [ "" == "${DS_DIR}" ]; then
        printf "The first parameter must be the path to the DarkStar Git directory\n"
        exit 1
fi

# create temp dir for sql
TMP_SQL_DIR=`mktemp -d`

# db info
DS_DB=dspdb
DS_USR=dspdb
DS_PWD=dspdb

# copy contents of SQL dir to tmp dir
cp ${DS_DIR}/sql/*.sql ${TMP_SQL_DIR}/

# remove files that will delete player data
rm -f ${TMP_SQL_DIR}/auction_house.sql
rm -f ${TMP_SQL_DIR}/chars.sql
rm -f ${TMP_SQL_DIR}/accounts.sql
rm -f ${TMP_SQL_DIR}/accounts_banned.sql
rm -f ${TMP_SQL_DIR}/char_effects.sql
rm -f ${TMP_SQL_DIR}/char_equip.sql
rm -f ${TMP_SQL_DIR}/char_exp.sql
rm -f ${TMP_SQL_DIR}/char_inventory.sql
rm -f ${TMP_SQL_DIR}/char_jobs.sql
rm -f ${TMP_SQL_DIR}/char_look.sql
rm -f ${TMP_SQL_DIR}/char_pet.sql
rm -f ${TMP_SQL_DIR}/char_pet_name.sql
rm -f ${TMP_SQL_DIR}/char_points.sql
rm -f ${TMP_SQL_DIR}/char_profile.sql
rm -f ${TMP_SQL_DIR}/char_skills.sql
rm -f ${TMP_SQL_DIR}/char_spells.sql
rm -f ${TMP_SQL_DIR}/char_stats.sql
rm -f ${TMP_SQL_DIR}/char_storage.sql
rm -f ${TMP_SQL_DIR}/char_vars.sql
rm -f ${TMP_SQL_DIR}/char_weapon_skill_points.sql
rm -f ${TMP_SQL_DIR}/chars.sql
rm -f ${TMP_SQL_DIR}/conquest_system.sql
rm -f ${TMP_SQL_DIR}/delivery_box.sql
rm -f ${TMP_SQL_DIR}/linkshells.sql

# execute update
for SQL in `ls -v ${TMP_SQL_DIR}/*.sql`
do
	echo "executing: ${SQL}"
	cat ${SQL} | mysql -u ${DS_USR} -p${DS_PWD} -h localhost ${DS_DB}
done

# delete temp folder
rm -rf ${TMP_SQL_DIR}
