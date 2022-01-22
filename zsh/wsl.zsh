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
