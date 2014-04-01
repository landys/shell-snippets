#!/bin/sh
# Tony
# Used to delete/modify Html/Xml tags.
# It outputs results to console.
# It supports one tag in multiline such as
# "<hello
# d=1
# b=2>"

usage()
{
	echo "usage: `basename "$0"` input_file_name [-o ouput_file_name] [-n] [[option] tag]..."
	echo "Delete/modify Html/Xml tags."
	echo
	echo "Options:"
	echo "  -o out_file_name, also output results to the file named output_file_name, only the first \"-o\" won't be ignored"
	echo "  -n no screen output"
	echo "  -d delete tag, default, affect all arguments after it"
	echo "  -r delete tag attributes but not tag itself, affect all arguments after it"
	echo "  -R replace current tag with the next tag, affect all arguments after it"
}

if [ $# -lt 2 ]
then
	usage
	exit 1
fi
if [ ! -r "$1" ]
then
	echo "The file $1 cannot be read!" >&2
	exit 1
fi

count=0
tempText=`cat "$1"`
# mark current tag
tagFlag=0
# 0-no screen output, 1-screen output
screen_output=1
# 0-no file output, 2-file output
output_file_flag=0
output_file_name=''
for tag
do
	count=`expr $count + 1`
	# first argument is input file name
	if [ $count -gt 1 ]
	then
		case "$tag" in
		-n)
			screen_output=0
			;;
		-o)
			if [ "$output_file_flag" -eq 0 ]
			then
				output_file_flag=1
			fi
			;;
		-d)
			tagFlag=0
			;;
		-r)
			tagFlag=1
			;;
		-R)
			tagFlag=2
			# used for -R
			RFlag=0
			;;
		*)
			if [ "$output_file_flag" -eq 1 ]
			then
				output_file_name="$tag"
				output_file_flag=2
				if [ -f "$output_file_name" -a ! -w "$output_file_name" ]
				then
					echo "The file $output_file_name cannot be written!" >&2
					exit 1
				fi
				continue
			fi
		
			if [ $tagFlag -eq 0 ]
			then
				# delete the tags. 
				# \> -- used for exact match, BTW \b -- used for a break of a word
				# h/H -- copy/append pattern space to hold space, and H will append \n to hold space first
				# H;1h -- just used for copy all text to hold space, 1 match the first line
				# g/G -- copy/append hold space to pattern space
				# the g in "s/.../.../g" is different from the former g, is a mark for a global match
				# the i in "s/.../.../i" is a case-insensitive match
				# p -- print the current pattern space
				# ${...} -- $ match the last line
				# "$tempText" -- " is needed for: "echo $tempText" always replace "\n" or "\t" with backspace,
				#     and it also reduces several neighboured backspace to one backspace 
				#     and eliminates the beginning and ending backspace
				tempText=`echo "$tempText" | sed -ne 'H;1h;${g;s/<'"$tag"'\>[^>]*>//ig;s/<\/'"$tag"'>//ig;p}'`
			elif [ $tagFlag -eq 1 ]
			then
				# replace "<tag ...>" with "<tag>", "<tag ... />" with "<tag />"
				tempText=`echo "$tempText" | sed -ne 'H;1h;${g;s/<'"$tag"'\>[^>]*[^\/]>/<'"$tag"'>/ig;s/<'"$tag"'\>[^>]*\/>/<'"$tag"' \/>/ig;p}'`
			elif [ $tagFlag -eq 2 ]
			then
				if [ $RFlag -eq 0 ]
				then
					last_tag="$tag"
					RFlag=1
				elif [ $RFlag -eq 1 ]
				then
					RFlag=0
					# replace "<last_tag ...>" with "<tag>", "<last_tag ... />" with "<tag />"
					tempText=`echo "$tempText" | sed -ne 'H;1h;${g;s/<'"$last_tag"'>/<'"$tag"'>/ig;s/<\/'"$last_tag"'>/<\/'"$tag"'>/ig;s/<'"$last_tag"'\>[^>]*[^\/]>/<'"$tag"'>/ig;s/<'"$last_tag"'\>[^>]*\/>/<'"$tag"' \/>/ig;p}'`
				fi
			fi
			;;
		esac
	fi
done

case `expr $screen_output + $output_file_flag` in
1)
	echo "$tempText"
	;;
2)
	echo "$tempText" > "$output_file_name"
	;;
3)
	echo "$tempText" | tee "$output_file_name"
	;;
esac
