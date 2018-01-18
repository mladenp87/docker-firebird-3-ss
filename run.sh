#!/bin/bash


echo "Setting timezone"
TZ=${TZ:-"Etc/UTC"}

rm /etc/localtime
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure -f noninteractive tzdata

cd /opt/firebird/

echo "Setting SYSDBA's password..."

FIREBIRD_PASSWORD=${FIREBIRD_PASSWORD:-"masterkey"}
IBASE_PASSWORD=`grep -Po '(?<=ISC_PASSWORD=)[^\s]*' ./SYSDBA.password`

./bin/fbguard &

sleep 5

echo "alter user sysdba set password '${FIREBIRD_PASSWORD}';" | ./bin/isql \
    -u sysdba -p ${IBASE_PASSWORD} security3.fdb

pkill fbguard

echo "Starting Firebird..."

./bin/fbguard
