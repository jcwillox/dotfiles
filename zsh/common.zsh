############### ENVIRONMENT ###############
ZSH_THEME="powerlevel10k/powerlevel10k"

DISABLE_MAGIC_FUNCTIONS=true
zle_highlight=('paste:none')

# include local completions
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)

export EDITOR="vim"
export VIMINIT="source ~/.config/vim/vimrc"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export LESS='-R'
export PAGER='less -F'
export FNM_COREPACK_ENABLED="true"

if [ -d "$HOME/go/bin" ] ; then
  export PATH="$HOME/go/bin:$PATH"
fi

if [ -d "$HOME/.bun" ] ; then
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"
fi

if [[ -v LC_COLORTERM ]]; then
  export COLORTERM=$LC_COLORTERM
fi

if [[ -v WT_SESSION ]]; then
  export COLORTERM="truecolor"
fi

############### ALIASES ###############
alias zshconfig="vim ~/.zshrc"
alias reload="exec zsh"
alias servedir="python3 -m http.server -b 0.0.0.0 80"
alias mkd=take
alias xx="chmod +x"
alias ipy="ipython"
alias dl="dotbot download"
alias envc="env | bat -l ini"

# colorize
alias ip='ip --color=auto'

# optional
alias dps="docker ps -a --format 'table $(printf '\e[92m'){{.Names}}\t$(printf '\e[93m'){{.Image}}\t$(printf '\e[95m'){{.Status}}$(printf '\033[0m')'"

if (( $+commands[dpkg] )); then
  alias dia="sudo dpkg -i ./*.deb"
  alias di="sudo dpkg -i"
fi

if (( $+commands[node-alias] )); then
  alias n="node-alias"
  alias b="NODE_ALIAS_MANAGER=bun node-alias"
  alias ni="node-alias install"
  alias nr="node-alias run"
fi

############### KEYBINDS ###############
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

############### FUNCTIONS ###############
motd() {
  for i in /etc/update-motd.d/*
    do if [ "$i" != "/etc/update-motd.d/98-fsck-at-reboot" ]; then $i; fi
  done
}

7zx() {
  7z x "$1" -o\*
}

vimw() {
  vim $(which "$1")
}

batw() {
  bat $(which "$1")
}

codew() {
  code $(which "$1")
}

############### MODULES ###############
source $ZSH/oh-my-zsh.sh

if [ "$TERM_PROGRAM" = "vscode" ] ||
   [ "$TERM_PROGRAM" = "Jetbrains.Fleet" ] ||
   [ "$TERMINAL_EMULATOR" = "JetBrains-JediTerm" ]; then
  source ~/.config/p10k/robbyrussell.zsh
elif [ "$ZSH_NO_THEME" != "true" ]; then
  source ~/.config/p10k/rainbow.zsh
fi

############### OTHER ###############
# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Compilation flags
# export ARCHFLAGS="-arch x86_64"
