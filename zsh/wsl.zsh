function o {
    /mnt/c/Windows/explorer.exe "${1:-.}"
}

function idea {
    powershell.exe -noprofile -ex unrestricted -c \
        "& \"\$env:LOCALAPPDATA/Programs/IntelliJ IDEA Ultimate/bin/idea64.exe\" ${1:-.} ${@:2}"
}

function pycharm {
    powershell.exe -noprofile -ex unrestricted -c \
        "& \"\$env:LOCALAPPDATA/Programs/PyCharm Professional/bin/pycharm64.exe\" ${1:-.} ${@:2}"
}

# forward ssh-agent from windows
export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
if ! ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; then
  if [[ -S $SSH_AUTH_SOCK ]]; then
      rm $SSH_AUTH_SOCK
  fi
  (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
fi

# facilitate windows executable interop
function exe {
    target=$(wslpath "$(awk -F$'\r' 'NR == 1 {printf "%s", $1}' <<< $(/mnt/c/Windows/System32/cmd.exe /c where $1 2>/dev/null))")
    if [[ "$target" == "." ]]; then
      echo "Command '$1' not found."
    else
        $target ${@:2}
    fi
}