#!/bin/bash

################################################################################
# file: install.sh
# author: Donald Isaac
#
# description: Configures a new or existing machine with the dotfiles included
#              in this repository. External tools are optionally downloaded,
#              then dotfiles are symlinked to their respective locations.
#
# license: MIT
# repo: https://github.com/DonIsaac/.dotfiles
################################################################################

# Import utilities
. ./util.sh

files=(conf.json parse.jq)
# List of dependencies. It is assumed that `git` is installed 
# (how would users clone this repo without it?)
deps=(jq node curl)
optional_deps=(nvim tmux fzf fd)

# Installation behavior, controlled with -i,--install flag. By default, tools 
# required for this script to properly run are downloaded, but useful binaries
# and other tools needed for the entire setup to run properly are not.
install_required=true
install_optional=false

brief_usage="Usage: $0 [-h, --help] [-i, --install <lvl=r>] [-l, --list-deps <lvl=all>]"
function usage() {
    echo "Usage: $0 [OPTIONS]                                                             "
    echo "                                                                                "
    echo "  -h, --help               Print this help message.                             "
    echo "                                                                                "
    echo "  -i, --install <lvl>      Set dependency installation behavior. Only missing   "
    echo "                           dependencies are installed. Lvl is one of:           "
    echo "                             no: Do not install any dependencies.               "
    echo "                             r,required: (default) Only install dependencies    "
    echo "                                         needed for this script to run properly."
    echo "                             a,all: Install all dependencies needed for full    "
    echo "                                    setupto work properly.                      "
    echo "                                                                                "
    echo " --no-install              Alias for --install no                               "
    echo "                                                                                "
    echo "                                                                                "
    echo "  -l, --list-deps <lvl>   Display list of binaries that --install <lvl> would   "
    echo "                          download. Defaults to "all".                          "
}

# Colors
# Check if stdout is a terminal
if [ -t 1 ]; then
    # Check if terminal supports colors
    ncolors=$(tput colors)

    if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
        bold="$(tput bold)"
        reset="$(tput sgr0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

function print_info() {
    echo -e "${cyan}${@}${reset}"
}

function print_success() {
    echo -e "${green}${@}${reset}"
}

function print_error() {
    echo -e "${red}${@}${reset}"
}

function print_warn() {
    echo -e "${yellow}${@}${reset}"
}

# Parse the command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        # Print help message
        -h|--help)
            usage
            exit 0
            ;;

        # Set the install behavior
        -i|--install)
            lvl="$2"
            case $lvl in
                r|required)
                    install_required=true
                    install_optional=false
                    ;;
                a|all)
                    install_required=true
                    install_optional=true
                    ;;
                no)
                    install_required=false
                    install_optional=false
                    ;;
                *)
                    echo "Invalid argument '$lvl' for --install. Must be one of: (r)equired,(a)ll,no"
                    exit 1
                    ;;
            esac
            shift # flag
            shift # value
            ;;

        # Do not install any dependencies
        --no-install)
            install_required=false
            install_optional=false
            shift
            ;;

        # Display list of dependencies
        -l|--list-deps)
        {

            lvl="$2"
            case $lvl in
                r|required)
                    echo "Required dependencies:"
                    echo "  ${deps[@]}"
                    ;;
                *)
                    echo "Required dependencies:"
                    echo "  ${deps[@]}"
                    echo "Optional dependencies:"
                    echo "  ${optional_deps[@]}"
                    ;;
            esac
            exit 0
        }
            ;;

        # Unknown option
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
    local dep=$1
    local exit_on_fail=${2:-0}

    # Use homebrew on MacOS
    if [[ "$(uname)" == "Darwin" ]]; then
        # Install homebrew if it's not installed
        if [[ ! -x "$(command -v brew)" ]]; then
            print_info "Installing homebrew..."
            /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi
        print_info "Installing $dep..."
        brew install $dep

    # Use either apt-get or yum on Linux
    elif [[ "$(uname)" == "Linux" ]]; then
        print_info "Installing $dep..."
        if [[ -x "$(command -v apt-get)" ]]; then
            sudo apt-get install -qq -y $dep
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install $dep
        elif $exit_on_fail ; then
            print_error "Unable to install $dep on this platform, please install dependencies manually."
            print_error "Run $0 --list-deps to see a list of dependencies that would be installed."
            exit 1
        else 
            print_warn "Unable to install $dep on this platform, please install dependencies manually."
        fi
    fi
}

# Checks if a dependency is installed. If not, and $install_required is true,
# installs it. Otherwise, exits with an error.
function install_or_error() {
    if ! command -v "$1" >/dev/null 2>&1; then
        if [[ "$install_required" = true ]]; then
            # echo "Installing $1..."
            install_dep $1
        else
            print_error "Error: $1 is not installed. Please install it and re-run this script."
            exit 1
        fi
    fi
}

# =============================================================================

# Update apt repos if on Linux and apt-get is installed
if [[ "$install_required" = true ]] && [[ "$(uname)" == "Linux" ]] && [[ -x "$(command -v apt-get)" ]]; then
    print_info "Updating apt repos..."
    sudo apt-get update > /dev/null
fi

# Install curl if it's not installed and $install_required is true, otherwise 
# print a warning message
if [[ ! -x "$(command -v curl)" ]] ; then
    if [[ "$install_required" = true ]] ; then
        install_dep curl
        has_curl=true
    else
        print_warn "curl is not installed. Some installation steps will fail and will need to"
        print_warn "be performed manually."
        has_curl=false
    fi
else
    has_curl=true
fi

# Check for curl command
# if [[ $(command -v curl) ]] ; then
    # has_curl= true
# else
    # has_curl= false
# fi


# Make sure JQ is installed
install_or_error jq

# Install additional binaries if $install_required is true
if [[ "$install_optional" = true ]] ; then
    install_dep neovim
    install_dep tmux
    install_dep fzf
    install_dep bat
    # fd is called fd-find on Linux due to naming conflicts
    if [[ "$(uname)" == "Linux" ]]; then
        install_dep fd-find
    else
        install_dep fd
    fi
fi

# if [ ! $(which jq) ]; then
    # echo "Error: jq is not installed. Please install it before continuing."
    # exit 1
# fi

# coc.nvim won't work without node. If it's not installed and $install_required is
# true, install nvm and use it to install the latest stable version of node.
# otherwise, print a warning message.
if [ ! $(which node) ]; then
    if [[ "$install_required" = true ]] && [[ "$has_curl" = true ]] ; then
        print_info "Installing nvm..."
        curl -SL -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash    

        print_info "Installing node..."
        source ~/.nvm/nvm.sh
        nvm install --lts
        nvm use --lts

    else
        print_warn "Warning: The coc.nvim plugin requires node, which is not installed."
        print_warn "You can download it from here: https://nodejs.org/en/download/"
    fi
fi

# Check that needed files exist
for file in $files; do
    if [ ! -f $file ]; then
        print_error "Error: could not find $file. Aborting."
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
    print_info "Linking '${ln_args[0]}' to '${ln_args[1]}'..."
    # echo ln -fs $(pwd)/${ln_args[0]} ${ln_args[1]}''| bash -s
    ln -fs $(pwd)/${ln_args[0]} ${ln_args[1]}
    # ln -s ${ln_args[@]}
done

# Install vim-plug
if [ -s "$HOME/.vim/autoload/plug.vim" ]; then
    print_info "vim-plug is already installed, skipping installation step."
else
    if [[ ! $(command -v vim) ]] && [[ ! $(command -v nvim) ]]; then
        print_warn "vim is not installed, skipping vim-plug installation."

    elif [[ "$has_curl" = true ]] ; then
        if [[ $(command -v nvim) ]]; then
            print_info "installing vim-plug (neovim)..."
            sh -c 'curl -fsLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
                   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            # yes | nvim +PlugInstall +qall;
        else
            print_info "installing vim-plug (vim)..."
            curl -fsSLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
            # yes | vim +PlugInstall +qall;
        fi
    else
        print_warn "curl is not installed, cannot install vim-plug. You will need to install it manually."
        print_warn "You can find installation instructions here: https://github.com/junegunn/vim-plug"
    fi
fi

print_success "Setup Complete"
print_success "You will need to run :PlugInstall in vim or neovim to install plugins."
exit 0
