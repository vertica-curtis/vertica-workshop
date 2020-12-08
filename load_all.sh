#!/bin/bash
#
#Usage:
#       ./load_all.sh  [-U username -w password] "

unset USER PASSWORD
echo $?

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

#initialize some variables
curr_path=`pwd`
echo $curr_path

for  data in `ls -1 *.tar`
do
	echo $data
	basename=${data%.*}
	mkdir -p "$curr_path/$basename"
	subfolder="$curr_path/$basename"
	tar -xf $data -C $subfolder

	/opt/vertica/bin/vsql $us $pw -c "copy weather_fact_raw from '$subfolder/*.gz' gzip fixedwidth colsizes(7,7,10,7,4,7,4,7,3,7,3,7,3,7,3,7,7,8,1,7,1,6,1,8,1,1,1,1,1,1) trim ' ' skip 1 ;"
	##cleanup
	cd $subfolder
	rm -f *.gz
	cd ..
	rmdir "$curr_path/$basename"
done

return 0 
