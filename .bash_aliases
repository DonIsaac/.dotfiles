# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always -F'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh --group-directories-first'
alias la='ls -AhF'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


alias g="git"
alias y="yarn"
alias c="cd"
alias back="cd -"
# I keep mistyping this one
alias gits="git status"
alias dc="docker-compose"
# I keep misstyping svn ugh
alias sv="svn"
alias tf="terraform"
alias more="less"
alias py="python3"
alias so="source"
# Interpret control characters (tldr; colored output)
alias rless="less -r"
alias p="pushd"
alias pd="popd"
alias ips="lsof -i -n -P"


# Windows program aliases
if [ $((OS_TYPE & OS_FLAG_WSL)) -ne 0 ]; then
    alias clip="clip.exe"
    alias copy="clip.exe"
    alias explorer="explorer.exe"
    alias e="explorer.exe"

    # FIXME: this doesn't work
    # if [ -n "$APPDATA" ] ; then
        # [ -s "$APPDATA/Spotify/Spotify.exe" ] && alias spotify="$APPDATA/Spotify/Spotify.exe"
    # fi

    alias chrome="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
fi

# MacOS program aliases
if [ $((OS_TYPE & OS_FLAG_MACOS)) -ne 0 ]; then
    alias clip="pbcopy"
    alias copy="pbcopy"
    alias paste="pbpaste"
    alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
fi

# Enter a directory and list its contents without flooding the terminal
cdl () {
    cd "$1" && l | head
}

# Man, but if a manpage isn't found, use its help message with 'less'
manh () {
    if ! man "$1"; then
        if ! $(which "$1"); then
            echo "Command '$1' not found."
            return 1;
        else
            $1 --help | less -r
        fi
    else
        return $?
    fi
}

# Call an HTTP endpoint that returns JSON and pretty-print it to less
# $1 - url. The URL of the endpoint to call
# $2 - filter. Optional jq filter to use. Defaults to the identity filter '.'
json() {
    if [ -z ${1+x} ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        echo "json: Call an HTTP endpoint that returns JSON and pretty-print it to less"
        echo "Usage: json <url> [filter]"
        return 1
    fi
    filter=${2:-.} # use '.' if no JQ filter was provided
    curl -sL $1 | jq -C $filter | less -R
}

# Show git diff using bat
batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
}

# Push a new branch to the remote repository
publish() {
    git push --set-upstream origin $(git branch --show-current)
}

# Make and enter a new directory
mkcd() {
    mkdir -p $@ && cd ${@:$#}
}

# Enter a directory and list the files in it
cdl() {
    cd $@ && ls
}

# Add your own personal aliases
if [[ -s "$HOME/.bash_aliases.local" ]] ; then
    source "$HOME/.bash_aliases.local"
fi
