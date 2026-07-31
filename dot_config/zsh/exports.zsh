# ─── Editor ───────────────────────────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="most"

# ─── PATH ─────────────────────────────────────────────────────────────────────
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# Python
export PATH="$HOME/Library/Python/3.9/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go
export GOPATH="$(go env GOPATH 2>/dev/null)"
[[ -n "$GOPATH" ]] && export PATH="$PATH:$GOPATH/bin"

# nvm (dir export only — loading happens in plugins.zsh)
export NVM_DIR="$HOME/.nvm"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# pi
export PI_CODING_AGENT_DIR="$HOME/.config/pi"

# Flutter
export PATH="$PATH":"$HOME/.pub-cache/bin"

# Brew
export HOMEBREW_BUNDLE_FILE="$HOME/.config/homebrew/Brewfile"

# ─── Misc ─────────────────────────────────────────────────────────────────────
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"  # bat-powered man pages

