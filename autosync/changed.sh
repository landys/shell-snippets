#!/bin/bash
# Watch files changing and run a script based on each change, 
# passing the changed absolute file path as parameter to the script.
#
# usage:
#   changed.sh /opt/scripts/sync_codes.sh
#
# wangjinde
# 7/29/2016

watch_dir=/codes/web-commons

if [ $# -lt 1 ]; then
	echo "Usage: $0 script"
	exit 1
fi

if [ ! -f "$1" ]; then
    echo "$1 not exist"
    exit 2;
fi

nohup fswatch -0 "$watch_dir" | xargs -0 -n 1 "$1"&
