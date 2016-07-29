#!/bin/bash
# Watch files changing and run a script based on each change, 
# passing the changed absolute file path as parameter to the script.
#
# usage:
#   changed.sh /opt/scripts/sync_codes.sh
#
# wangjinde
# 7/29/2016

if [ ! -f "$1" ]; then
    echo "Usage: $0 script"
    exit -1;
fi

nohup fswatch -0 /codes/web-commons | xargs -0 -n 1 "$1"&
