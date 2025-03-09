# if "eza" command does not exist and exa does exist
if ! (( $+commands[eza] )) && (( $+commands[exa] )); then
  alias ls="exa --grid --icons --group-directories-first"
  alias ll="exa --long --icons --group-directories-first --git"
  alias la="ll --all"
else
  alias ls="eza --grid --icons --group-directories-first"
  alias ll="eza --long --icons --group-directories-first --git"
  alias la="ll --all"
fi