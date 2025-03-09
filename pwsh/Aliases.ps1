############### ALIASES ###############
New-Alias df Get-Volume -Force
New-Alias which Get-Command -Force
New-Alias nf nfetch -Force
New-Alias shovel scoop -Force
New-Alias cc cookiecutter -Force

Remove-Alias "ls" -ErrorAction Ignore
New-FunctionAlias "ls" "eza --grid --icons --group-directories-first"
New-FunctionAlias "ll" "eza --long --icons --group-directories-first --git"
New-FunctionAlias "la" "eza --long --icons --group-directories-first --git --all"

New-FunctionAlias ".." { Set-Location ".." }
New-FunctionAlias "..." { Set-Location "..\.." }
New-FunctionAlias "~" { Set-Location "~" }
New-FunctionAlias "pla" { Get-ChildItem @args -Force }
New-FunctionAlias "dl" "dotbot download"

New-FunctionAlias "jq" "jq.ps1 -C"
New-FunctionAlias "reload" "& $profile"
New-FunctionAlias "psconfig" "code $PROFILE"
New-FunctionAlias "configs" "code '$HOME\.config'"

New-FunctionAlias "p10k-rainbow" "& ~\.config\p10k\rainbow.ps1"
New-FunctionAlias "p10k-robbyrussell" "& ~\.config\p10k\robbyrussell.ps1"
New-FunctionAlias "p10k-lean" "& ~\.config\p10k\lean.ps1"

New-FunctionAlias "gmp" "Get-Member -MemberType Properties"
New-FunctionAlias "aliasc" { Get-Alias -Definition $args[0] }
New-FunctionAlias "env" "Get-Item -Path Env:*"
New-FunctionAlias "o" { param($path = "."); Start-Process (Resolve-Path $path) }
New-FunctionAlias "whichp" { Get-Command @args | Select-Object -ExpandProperty Path }
New-FunctionAlias "mkd" { New-Item -ItemType Directory -Path $args[0] && Set-Location $args[0] }
New-FunctionAlias "ipy" "py -m IPython"

# oh-my-zsh encode64 plugin
New-FunctionAlias "encode64" { [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($args[0])) }
New-FunctionAlias "decode64" { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($args[0])) }
New-Alias "e64" "encode64"
New-Alias "d64" "decode64"

# vscode
New-FunctionAlias "vsc" "code ."
New-FunctionAlias "codep" { code (Get-Command @args | Select-Object -ExpandProperty Path) }

# wsl
New-WslAlias "bash"
New-WslAlias "grep" "grep --color=always"
New-WslAlias "zsh"
New-WslAlias "eza"
New-WslAlias "base64"
New-WslAlias "tar"
New-WslAlias "eza-la" "eza --long --icons --group-directories-first --git --all"

# docker
New-FunctionAlias "dc" "docker-compose"
New-FunctionAlias "dcb" "docker-compose build"
New-FunctionAlias "dcl" "docker-compose logs"
New-FunctionAlias "dclf" "docker-compose logs -f"
New-FunctionAlias "dcup" "docker-compose up"
New-FunctionAlias "dcupb" "docker-compose up --build"
New-FunctionAlias "dcupd" "docker-compose up -d"
New-FunctionAlias "dcdn" "docker-compose down"
New-FunctionAlias "dtemp" "docker run --rm -ti -e TZ=Australia/Sydney --name dotfiles ghcr.io/jcwillox/dotfiles:latest"

# go
New-FunctionAlias "gob" "go build"
New-FunctionAlias "gor" "go run ."
New-FunctionAlias "gobr" "go build && go run ."

# uutils
New-Alias u uutils
New-FunctionAlias "urm" "uutils rm"
New-FunctionAlias "uenv" "uutils env"
New-FunctionAlias "utouch" "uutils touch"
