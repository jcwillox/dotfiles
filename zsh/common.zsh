############### ENVIRONMENT ###############
ZSH_THEME="powerlevel10k/powerlevel10k"

export EDITOR="vim"
export VIMINIT="source ~/.config/vim/vimrc"
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

############### ALIASES ###############
alias zshconfig="vim ~/.zshrc"
alias reload="exec zsh"
alias servedir="python3 -m http.server -b 0.0.0.0 80"

# colorize
alias ip='ip --color=auto'

# optional
[ -x /usr/bin/docker ] && alias dps="docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"

############### KEYBINDS ###############
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line

############### FUNCTIONS ###############
motd() {
  for i in /etc/update-motd.d/*
    do if [ "$i" != "/etc/update-motd.d/98-fsck-at-reboot" ]; then $i; fi
  done
}

function base64d { echo -n "$1" | base64 -d }
function base64e { echo -n "$1" | base64 }

############### MODULES ###############
source $ZSH/oh-my-zsh.sh

if [ "$TERM_PROGRAM" = "vscode" ]; then
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

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
