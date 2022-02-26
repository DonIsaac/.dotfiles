# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Color variables for the prompt. Used for readability
if tput setaf 1 &> /dev/null; then
  tput sgr0; # reset colors
  bold=$(tput bold);
  reset=$(tput sgr0);
  # Oceanic Next colors
  black=$(tput setaf 16);
  blue=$(tput setaf 68);
  cyan=$(tput setaf 73);
  green=$(tput setaf 114);
  orange=$(tput setaf 209);
  magenta=$(tput setaf 176);
  red=$(tput setaf 203);
  white=$(tput setaf 66);
  yellow=$(tput setaf 221);
else
  bold='';
  reset="\e[0m";
  black="\e[1;30m";
  blue="\e[1;34m";
  cyan="\e[1;36m";
  green="\e[1;32m";
  orange="\e[1;33m";
  magenta="\e[1;35m";
  red="\e[1;31m";
  white="\e[1;37m";
  yellow="\e[1;33m";
fi;

function parse_git_dirty() {
  [[ $(git status 2> /dev/null | tail -n1) != *"nothing to commit"* ]] && echo "*"
}

function parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\1$(parse_git_dirty)/"
}

if [ "$color_prompt" = yes ]; then
    # display datetime
    PS1="\[${bold}\]\[$orange\][\[$magenta\]\d \t\[$orange\]] "
    # user@host:path
    PS1+="\[$magenta\]\u\[$white\]@"
    PS1+="\[$magenta\]\h\[$white\]:"
    PS1+="\[$green\]\w\[$white\]"
    # git branch (if available)
    PS1+="\$([[ -n \$(git branch 2> /dev/null) ]] && printf \" \xee\x9c\xa5 \")\[$magenta\]\$(parse_git_branch)\[$white\]\$ \[$reset\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Make directories an easier color to see
export LS_COLORS=$LS_COLORS:'di=0;33:'

# Add VSCode's 'code' command to the path
[ -s "/mnt/c/Program Files/Microsoft VS Code/bin" ] && export PATH="$PATH:/mnt/c/Program Files/Microsoft VS Code/bin" 

# Try to use NeoVIM, VIM, or VSCode (in that order) as default editor
if [[ $(which nvim) ]] ; then
    export EDITOR=nvim
elif [[ $(which vim) ]] ; then
    export EDITOR=vim
elif [[ $(which code) ]] ; then
    export EDITOR=code
fi
# [[ $(which vim) ]] && export EDITOR=vim

# Env variables for "home" directory of different programs
[ -s "$HOME/.nvm" ] &&               export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] &&          \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export JAVA_HOME='/usr/java/jdk-11.0.6+10'
export JUNIT_HOME="$HOME/lib/junit4.10"
export CLASSPATH=".:$JUNIT_HOME/junit-4.10.jar"
# export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0 # was :3
export LIBGL_ALWAYS_INDIRECT=1

# Extend $PATH
[[ $(which yarn) ]] &&          export PATH="$PATH:$(yarn global bin)"
[[ "$JAVA_HOME" != "" ]] && [[ -s "$JAVA_HOME/bin" ]] && export PATH="$PATH:$JAVA_HOME/bin"
[[ $(which pdflatex) ]] &&      export PATH="$PATH:/usr/local/texlive/2019/bin/x86_64-linux"
[[ -s "$HOME/.deno/bin" ]] &&   export PATH="$PATH:~/.deno/bin"
[[ -s "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"
[[ -s "$HOME/.bin" ]] &&        export PATH="$PATH:$HOME/.bin"
[[ -s "$HOME/bin" ]] &&         export PATH="$PATH:$HOME/bin"
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[[ $(which rvm) ]] &&           export PATH="$PATH:$HOME/.rvm/bin"

# Install z command: https://github.com/rupa/z 
[ -s "$HOME/.bin/z/z.sh" ] && \. "$HOME/.bin/z/z.sh"

# Go home path. Needs to come after path setup.

# Start, and register private keys with, ssh-agent
eval `ssh-agent -s` > /dev/null 2> /dev/null
ssh-add ~/.ssh/*.pem > /dev/null 2> /dev/null
ssh-add ~/.ssh/*.key > /dev/null 2> /dev/null

# opam configuration
test -r /home/donisaac/.opam/opam-init/init.sh && . /home/donisaac/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
[[ $(which opam) ]] && eval $(opam env)

# Add autocompletion support for the Stripe CLI
[[ -s "$HOME/.stripe/stripe-completion.bash" ]] && source ~/.stripe/stripe-completion.bash
# terraform -install-autocomplete

complete -C /usr/bin/terraform terraform


# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true
[ -f "/home/donisaac/.ghcup/env" ] && source "/home/donisaac/.ghcup/env" # ghcup-env
