# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -f "~/.dotfiles/theme.zsh" ]] && source ~/.dotfiles/theme.zsh
# Import utilities
. ~/.dotfiles/util.zsh

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# NVM settings
export NVIM_DIR="$HOME/.config/nvim"
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=false
export NVM_AUTO_USE=true # Auto switch node version when entering a folder with .nvmrc

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# append to the history file, don't overwrite it
# shopt -s histappend

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

AUTO_PUSHD="false"
unsetopt autopushd
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  nvm
  z
  zsh-nvm
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='nvim'
# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Use bat for manpages, which gives manpages nice syntax highlighting
# https://github.com/sharkdp/bat
[[ $(which batcat) ]] && export MANPAGER="sh -c 'col -bx | batcat -l man -p'"

# FZF settings (https://github.com/junegunn/fzf)
export FZF_DEFAULT_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:500 {}'"
if has_command fd ; then
    export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude **/node_modules --exclude **/dist"
elif has_command fdfind ; then
    export FZF_DEFAULT_COMMAND="fdfind --type f --hidden --follow --exclude .git --exclude '**/node_modules' --exclude '**/dist'"
fi

# Extend $PATH
has_command yarn &&             export PATH="$PATH:$(yarn global bin)"
[[ "$JAVA_HOME" != "" ]] && [[ -s "$JAVA_HOME/bin" ]] && export PATH="$PATH:$JAVA_HOME/bin"
has_command pdflatex &&         export PATH="$PATH:/usr/local/texlive/2019/bin/x86_64-linux"
[[ -s "$HOME/.deno/bin" ]] &&   export PATH="$PATH:~/.deno/bin"
[[ -s "/usr/local/go/bin" ]] && export PATH="$PATH:/usr/local/go/bin"
[[ -s "$HOME/.local/sonar-scanner/bin" ]] && export PATH="$PATH:/$HOME/.local/sonar-scanner/bin"
[[ -s "$HOME/.bin" ]] &&        export PATH="$PATH:$HOME/.bin"
[[ -s "$HOME/bin" ]] &&         export PATH="$PATH:$HOME/bin"
[[ -s "$HOME/.local/bin" ]] &&        export PATH="$PATH:$HOME/.local/bin"

# Install z command: https://github.com/rupa/z 
[ -s "$HOME/.bin/z/z.sh" ] && \. "$HOME/.bin/z/z.sh"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
. ~/.bash_aliases

# Disable automatic pushd after you've already used pushd.
unsetopt autopushd
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
