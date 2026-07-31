# Initialize completion system
autoload -Uz compinit

# Only regenerate .zcompdump once per day for faster startup
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' menu select                          # Arrow-key navigable menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'        # Case-insensitive matching
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored file completions
zstyle ':completion:*' group-name ''                        # Group completions by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion::complete:*' use-cache on              # Cache completions
zstyle ':completion::complete:*' cache-path "$HOME/.zcompcache"

# Kill: show process list
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:kill:*' menu yes select

# cd: don't offer . and ..
zstyle ':completion:*:cd:*' ignore-parents parent pwd

# gh CLI completions
if (( $+commands[gh] )); then
  eval "$(gh completion -s zsh)"
fi

# brew completions
if (( $+commands[brew] )); then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi

# docker completions
if (( $+commands[docker] )); then
  source <(docker completion zsh)
fi

# sentry
fpath=("/Users/tom.stian.ingebretson/.local/share/zsh/site-functions" $fpath)

# bun completions
[ -s "/Users/tom.stian.ingebretson/.bun/_bun" ] && source "/Users/tom.stian.ingebretson/.bun/_bun"
