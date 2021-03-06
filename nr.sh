#!/bin/bash
# tony
# nr = name reset
# rename certain files under a path to 1, 2, 3, ... with the given postfix

usage()
{
	echo "usage: `basename "$0"` path expression(no space) postfix"
	echo "rename certain files under a path to 1, 2, 3, ... with the given postfix"
	echo "i.e. ./nr.sh \"/cygdrive/e/codes/ForFlex201/FlexDemo/images\" \"*.jpg\" \"abc\""
}

if [ $# -lt 3 ]; then
	usage
	exit 0
fi

cd "$1"

i=1
# if file name has " ", then wrong
# for a file "gloomy sunday.jpg", which will be treated as two files "gloomy" and "sunday.jpg"
#for file in `find . -name "$2" -type f`
#ls "../a/*.txt" # wrong
#ls ../a/*.txt	# right, but the path cannot has space(" ")
#ls -A $2 |	# OK, but feel not so robust, if no $2, will an error
find . -name "$2" -type f | 
while read file
do
	#echo "$file"
	mv "$file" "${i}.${3}"
	i=`expr $i + 1`	
done
