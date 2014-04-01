#!/bin/sh
# Tony
# Concatenate 2nd line with 1st line as one line.
# exl.sh input output

usage()
{
	echo "usage: `basename "$0"` input_file_name [ouput_file_name]"
	echo "Concatenate 2nd line with 1st line as one line."
}

if [ $# -lt 1 ]
then
	usage
	exit 1
fi
if [ ! -r "$1" ]
then
	echo "The file $1 cannot be read!" >&2
	exit 1
fi

if [ $# -eq 1 ]
then
	sed -n '1~2h;2~2{G;s/\n//g;p}' "$1"
else
	sed -n '1~2h;2~2{G;s/\n//g;p}' "$1" > "$2"
fi
