#!/bin/bash

files=(conf.json parse.jq)
# List of dependency tools
deps=(jq node curl tmux nvim)
# Whether or not dependencies should be installed. Controlled with -i,--install-deps flag.
install_deps= false

brief_usage="Usage: $0 [-h, --help] [-i, --install-deps] [-l, --list-deps]"
function usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "  -h, --help                 Print this help message"
    echo "  -i, --install-deps         Install missing dependency tools. May require sudo"
    echo "  -l, --list-deps            Print list of dependency tools that -i would install"
}

# Parse the command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -h|--help)
            usage
            exit 0
            ;;
        -i|--install-deps)
            install_deps=true
            shift
            ;;
        -l|--list-deps)
            echo "${deps[@]}"
            exit 0
            ;;
        *)
            echo "Unknown option: $key"
			echo "$brief_usage"
            exit 1
            ;;
    esac
done

# =============================================================================

# Installs a dpependency with the appropriate package manager
function install_dep() {
    dep=$1
    # Use homebrew on MacOS
    if [[ "$(uname)" == "Darwin" ]]; then
        # Install homebrew if it's not installed
        if [[ ! -x "$(command -v brew)" ]]; then
            echo "Installing homebrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
		echo "Installing $dep..."
        brew install $dep

    # Use either apt-get or yum on Linux
    elif [[ "$(uname)" == "Linux" ]]; then
		echo "Installing $dep..."
        if [[ -x "$(command -v apt-get)" ]]; then
            sudo apt-get install $dep
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install $dep
        else
            echo "Unable to install $dep on this platform, please install dependencies manually."
            echo "Run $0 --list-deps to see a list of dependencies that would be installed."
            exit 1
        fi
    fi
}

# Checks if a dependency is installed. If not, and $install_deps is true,
# installs it. Otherwise, exits with an error.
function install_or_error() {
    if ! command -v "$1" >/dev/null 2>&1; then
        if $install_deps; then
            echo "Installing $1..."
			install_dep $1
        else
            echo "Error: $1 is not installed. Please install it and re-run this script."
            exit 1
        fi
    fi
}

# =============================================================================

# Update apt repos if on Linux and apt-get is installed
if [[ "$(uname)" == "Linux" ]] && [[ -x "$(command -v apt-get)" ]]; then
	sudo apt-get update
fi

# Install curl if it's not installed and $install_deps is true, otherwise 
# print a warning message
if [[ ! -x "$(command -v curl)" ]] then
	if $install_deps; then
		install_dep curl
	else
		echo "Error: curl is not installed. Some installation steps will fail and will need to"
		echo "be performed manually."
	fi
fi

# Check for curl command
if [[ $(command -v curl) ]] ; then
    has_curl= true
else
    has_curl= false
fi

# Install additional binaries if $install_deps is true
if $install_deps; then
    install_dep nvim
    install_dep tmux
fi

# Make sure JQ is installed
install_or_error jq

# if [ ! $(which jq) ]; then
	# echo "Error: jq is not installed. Please install it before continuing."
	# exit 1
# fi

# coc.nvim won't work without node. If it's not installed and $install_deps is
# true, install nvm and use it to install the latest stable version of node.
# otherwise, print a warning message.
if [ ! $(which node) ]; then
	if $install_deps && $has_curl ; then
		echo "Installing nvm..."
		curl -SL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash	

		echo "Installing node..."
		source ~/.nvm/nvm.sh
		nvm install --lts
		nvm use --lts

	else
		echo "Warning: The coc.nvim plugin requires node, which is not installed."
		echo "You can download it from here: https://nodejs.org/en/download/"
	fi
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
	
    # Array containing [<dotfile-in-repo>, <dotfile-destination>]
	ln_args=(${link/;/ })

    # Make target directory if it doesn't exist
    dir=$(dirname ${ln_args[1]})
    if [[ $dir != "~" ]]; then
        mkdir -p $dir
    fi

    # Link the file
	echo "linking '${ln_args[0]}' to '${ln_args[1]}'..."
	echo ln -fs $(pwd)/${ln_args[0]} ${ln_args[1]}''| bash -s
	# ln -s ${ln_args[@]}
done

# Install vim-plug
if [ -s "$HOME/.vim/autoload/plug.vim" ]; then
    echo "vim-plug is already installed, skipping installation step."
else
	if [[ ! $(command -v vim) ]] && [[ !$(command -v nvim) ]]; then
        echo "vim is not installed, skipping vim-plug installation."

    elif $has_curl then
        echo "installing vim-plug..."
        curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        yes | vim +PlugInstall +qall        
    else
        echo "curl is not installed, cannot install vim-plug. You will need to install it manually."
        echo "You can find installation instructions here: https://github.com/junegunn/vim-plug"
    fi
fi
