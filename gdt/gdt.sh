#!/bin/bash
# tony
# generate directory tree.

usage()
{
	echo "usage: `basename "$0"` [-h] [-o [file name]] [-n] [directory]"
	echo "Generate directory tree."
	echo "|-- for file, /-- for empty directory, +-- for non-empty directory."
	echo
	echo "Options:"
	echo " -h help page, any other options ignored."
	echo " -o output results to a file, no file name follwed means output file has a name the same as directory name with .txt."
	echo " -n no screen output, if no file specificed, it redirects to /dev/null."
	echo " All extra arguments will be ignored automatically."
	echo " Only the first directory will be considered if more exist."
}

readonly i_blank=0
readonly i_branch=1
readonly i_dir=2
readonly i_empty_dir=3
readonly i_file=4
# array cannot be readonly
# readonly branch_mark=('   ' '|  ' '+--' '/--' '|--') 
# means value of branch_mark is ('   ' '|  ' '+--' '/--' '|--'), instead of an array definition
branch_mark=('   ' '|  ' '+--' '/--' '|--')

# three variables used: current indent, the file type(i_dir, i_empty_dirr, i_file), file name
print_branch()
{
	# echo "$@" prints all arguments
	# echo "$@"
	   
	one_branch=''
	for ((i=0; i<"$1"; i++))
	do
		if [ "${branches[${i}]}" -gt 0 ]
		then
			one_branch="${one_branch}""${branch_mark[${i_branch}]}"
		else
			one_branch="${one_branch}""${branch_mark[${i_blank}]}"
		fi
	done
	echo "${one_branch}""${branch_mark[$2]}""$fname"
}

# two arguments: directory(an absolute path like "/aaa/bbb/ccc", if), current directory depth
do_gen_dir_tree()
{
	ls -A "${1}/" | 
	while read fname
	do
		branches[$2]=`expr ${branches[$2]} - 1`
		if [ -d "${1}/""${fname}" ]; then
			temp_indent=`expr $2 + 1`
			branches[$temp_indent]="`ls -A1 "${1}/""${fname}" | wc -l`"
			if [ "${branches[$temp_indent]}" -gt 0 ]; then
				print_branch "$2" "$i_dir"
				do_gen_dir_tree "${1}/""${fname}" $temp_indent
			else
				print_branch "$2" "$i_empty_dir"
			fi
		else
			print_branch "$2" "$i_file"
		fi
	done
}

# the argument is a absolute path like "/aaa/bbb/ccc"
gen_dir_tree()
{
	echo "$1"
	
	if [ -d "$1" ]; then
		branches[0]="`ls -A1 "$1" | wc -l`"

		# Take away the end "/" from the first argument if necessary, the second argument must be 0 
		# So if the path is "/", then the first argument will be empty
		do_gen_dir_tree "${1%/}" 0
	fi
}

nflag=0
oflag=0
isready=0
fname=''
dirname=''
for tag
do
	case "$tag" in
	-h)
		usage
		exit 1
		;;
	-n)
		if [ $nflag -eq 0 ]; then
			nflag=1
		else
			usage
			exit 1
		fi
		;;
	-o)
		if [ $oflag -eq 0 ]; then
			oflag=1
		else
			usage
			exit 1
		fi
		;;
	-*)
		usage
		exit 1
		;;
	*)
		if [ $oflag -eq 1 ]; then
			fname="$tag"
			oflag=2
		elif [ $isready -eq 0 ]; then
			dirname="$tag"
			isready=1
		fi
#		isready=`expr $isready + 1`
#		if [ $isready -eq 2 ]; then
#			break;
#		fi
		;;
	esac
done

# change the related path into absolute path
orig_path=`pwd`
cur_path="${dirname:-"."}"
if [ ! -d "${cur_path}" ]; then
	echo "Error: $cur_path is not a directory."
	exit 1
fi
cd "${cur_path}"
cur_path=`pwd`
cd "$orig_path"

if [ $nflag -eq 0 ]; then
	if [ $oflag -eq 0 ]; then
		gen_dir_tree "$cur_path"
	else
		gen_dir_tree "$cur_path" | tee "${fname:-"`basename "$cur_path"`"".txt"}"
	fi
else
	if [ $oflag -eq 0 ]; then
		gen_dir_tree "$cur_path" > /dev/null
	else
		gen_dir_tree "$cur_path" > "${fname:-"`basename "$cur_path"`"".txt"}"
	fi
fi
