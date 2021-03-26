############### ALIASES ###############
# HTB
alias htbstart="openvpn ~/.config/htb.ovpn"

# NMAP
alias nmapq="nmap -sC -sV -oA quick"
alias nmapa="nmap -p1-65535 -sC -sV --min-parallelism 100 -oA full"

# GOBUSTER
alias gobustera="gobuster dir -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 200 -x .php,.html"

# NETCAT
alias ncl="rlwrap -r nc -lvnp"  # enter port
alias nclp="rlwrap -r nc -lvnp 1234"  # default port

# SSH
alias sshq="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

############### FUNCTIONS ###############
os-version() {
    grep VERSION /etc/os-release
    uname -rv
}

os-update() {
    sudo apt update && sudo apt -y full-upgrade
    [ -f /var/run/reboot-required ] && sudo reboot -f
}
