#!/bin/bash

files=(conf.json parse.jq)

# Make sure JQ is installed
if [ ! $(which jq) ]; then
	echo "Error: jq is not installed. Please install it before continuing."
	exit 1
fi

# Check that needed files exist
for file in $files; do
	if [ ! -f $file ]; then
		echo "Error: could not find $file. Aborting."
		exit 1
	fi
done

# Get list of files to link (and where they get linked to) 
links=$(jq -rcf parse.jq conf.json)
echo "links:"
echo "$links"
echo "==========================================================="
echo ""

echo "dirname: $(dirname $1)"
echo "pwd: $(pwd)"
echo "ls of home dir:"
ls -la ~

echo "==========================================================="
echo ""

echo "files in directory:"
ls -la

echo "==========================================================="
echo ""

# Create the links
for link in $links; do
	
	ln_args=(${link/;/ })
	echo "linking '${ln_args[0]}' to '${ln_args[1]}'..."
	echo ln -fs $(pwd)/${ln_args[0]} ${ln_args[1]}''| bash -s
	# ln -s ${ln_args[@]}
done

