#!/bin/bash

#kill others!
ps aux | grep 'blogaudit\.Audition' | awk '{print $2}' | xargs kill

export LC_CTYPE=zh_CN.gbk
#dir location preperation
CALLDIR=$(pwd)
FULLPATH=`realpath $0`
RUNDIR=`dirname $FULLPATH`

#enter the bin dir of bin
cd $RUNDIR

#clean log file
rm -f ./log/debug.log


##################
## prepare and run
##################


#prepare class path and lib
export CLASSPATH=.

ANTI_LIB=.
for i in ../lib/*.jar ;
do
	ANTI_LIB=${ANTI_LIB}:$i;
done

#set the heap size
HEAP_SIZE="-Xms512m -Xmx2048m"

#call the main function of NewAccountMonitoring
#echo "Run..." 
RUN_START_TIME=`date +%m%d.%H%M`
java -Djava.library.path=../depends/ -cp $ANTI_LIB $HEAP_SIZE com.netease.space.antispam.blogaudit.Audition $@

echo "BlogAudit Terminated."


##################
## deal with log files
##################

RUN_END_TIME=`date +%H%M`

LOGFILE=${RUN_START_TIME}-${RUN_END_TIME}.audition.info.log
mv ./log/info.log ./log/$LOGFILE
#echo Backup log to $LOGFILE

find ./log/ -mtime +5 -exec rm {} \;
#rm -rf ./.ddblog/
#echo clean old file in ./data/ and ./log/ and ./.ddblog/

cd $CALLDIR
#echo Back to $CALLDIR
#echo Mission End!

