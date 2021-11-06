#!/bin/bash

files=(conf.json parse.jq)

# Make sure JQ is installed
if [ ! $(which jq) ]; then
	echo "Error: jq is not installed. Please install it before continuing."
	exit 1
fi

# coc.nvim won't work without node, emit a warning if not installed
if [ ! $(which node) ]; then
    echo "Warning: The coc.nvim plugin requires node, which is not installed."
    echo "You can download it from here: https://nodejs.org/en/download/"
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

# Install vim-plug
if [ -s "$HOME/.vim/autoload/plug.vim" ]; then
    echo "vim-plug is already installed, skipping installation step."
else
    if [ ! $(which vim) ]; then
        echo "vim is not installed, skipping vim-plug installation."

    elif [ $(which curl) ]; then
        echo "installing vim-plug..."
        curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        yes | vim +PlugInstall +qall        
    else
        echo "curl is not installed, cannot install vim-plug. You will need to install it manually."
        echo "You can find installation instructions here: https://github.com/junegunn/vim-plug"
    fi
fi
