KEYTIMEOUT=1                   # Reduce ESC delay to 10ms

# ─── Insert mode (emacs-style) ────────────────────────────────────────────────
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^p' up-line-or-history
bindkey '^n' down-line-or-history
bindkey '^w' backward-kill-word
bindkey '^u' kill-whole-line
bindkey '^k' kill-line
bindkey '^r' history-incremental-search-backward  # overridden by fzf if loaded
bindkey '^?' backward-delete-char                 # Fix backspace in insert mode
bindkey '^h' backward-delete-char

# ─── Normal mode ──────────────────────────────────────────────────────────────
# v opens $EDITOR to edit the command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# ─── Cursor shape ─────────────────────────────────────────────────────────────
# Show vi mode in right prompt (overridden by starship if it supports it)
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'   # block cursor
  else
    echo -ne '\e[5 q'   # beam cursor
  fi
}
zle -N zle-keymap-select

# Start with beam cursor
zle-line-init() { echo -ne '\e[5 q' }
zle -N zle-line-init
