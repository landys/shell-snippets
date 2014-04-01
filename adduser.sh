#!/bin/bash
# author: tony
# 2008-9-27
# add a linux user

usage()
{
	echo "usage: `basename "$0"` username"
	echo "Add a linux user."
}

if [ $# -lt 1 ]
then
	usage
	exit 0
fi

# initial password as the pattern "hozom123"
/usr/sbin/useradd "$1" -d "/home/$1" -s /bin/bash -p "hoYGoCw2bvwyM"
chage -d 0 "$1"

echo Add user "$1" successfully.
