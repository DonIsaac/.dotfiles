#!/bin/bash

files=(conf.json parse.jq)

# Make sure JQ is installed
if [ ! $(which jq > /dev/null) ]; then
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

# Create the links
for link in $links; do
	
	ln_args=(${link/;/ })
	echo "linking '${ln_args[0]}' to '${ln_args[1]}'..."
	ln ${ln_args[@]}
done

