#!/bin/bash
#
#Usage:
#       ./run.sh  [-U username -w password] "

unset USER PASSWORD

args=`getopt U:w: $*`
if [ $# -lt 4 ]; then
        echo " Usage is ./run.sh  [-U username -w password] "
        return 1
fi
set -- $args

for i
do
  case "$i" in
        -U) shift;USER=$1;shift;;
        -w) shift;PASSWORD=$1;shift;;
  esac
done


if [ "$USER" != "" ]; then
        us="-U $USER"
fi

if [ "$PASSWORD" != "" ]; then
        pw="-w $PASSWORD"
fi

/opt/vertica/bin/vsql $us $pw -f ./setup.sql

chmod 711 ./get_all.sh
chmod 711 ./load_all.sh
./get_all.sh

./load_all.sh $us $pw

echo "Done!"

