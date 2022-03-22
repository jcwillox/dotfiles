function o {
    explorer.exe "${1:-.}"
}

function idea {
    powershell.exe -noprofile -ex unrestricted -c \
        "& \$env:LOCALAPPDATA/JetBrains/Toolbox/apps/IDEA-U/ch-0/*/bin/idea64.exe ${1:-.} ${@:2}"
}

function pycharm {
    powershell.exe -noprofile -ex unrestricted -c \
        "& \$env:LOCALAPPDATA/JetBrains/Toolbox/apps/PyCharm-P/ch-0/*/bin/pycharm64.exe ${1:-.} ${@:2}"
}

# forward ssh-agent from windows
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
if ! ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; then
  if [[ -S $SSH_AUTH_SOCK ]]; then
      rm $SSH_AUTH_SOCK
  fi
  (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi
