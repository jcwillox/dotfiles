if (( ! $+commands[fnm] )); then
  return
fi

eval "$(fnm env --use-on-cd --shell zsh)"
