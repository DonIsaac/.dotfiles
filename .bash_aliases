# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias dc="docker-compose"
# I keep misstyping svn ugh
alias sv="svn"
alias chrome="/mnt/c/Program\ Files\ \(x86\)/Google/Chrome/Application/chrome.exe"
alias tf="terraform"
alias more="less"
alias py="python3"
# Interpret control characters (tldr; colored output)
alias rless="less -r"
alias p="pushd"
alias pd="popd"
alias ips="lsof -i -n -P"

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
