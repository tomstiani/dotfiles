# ─── zsh-autosuggestions ──────────────────────────────────────────────────────
[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && \
  source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

ZSH_AUTOSUGGEST_STRATEGY=(history completion)  # Use history first, then completion
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20             # Don't suggest for very long commands

# ─── zsh-syntax-highlighting ──────────────────────────────────────────────────
[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && \
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ─── nvm (lazy-loaded) ────────────────────────────────────────────────────────
# Defer loading until first use of node/nvm/npm/npx/yarn/pnpm
_load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}
for _nvm_cmd in nvm node npm npx yarn pnpm; do
  eval "${_nvm_cmd}() { unset -f nvm node npm npx yarn pnpm; _load_nvm; ${_nvm_cmd} \"\$@\"; }"
done
unset _nvm_cmd

# ─── worktrunk longhorn (lazy-loaded) ───────────────────────────────────────────────────────
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

# ─── zoxide ───────────────────────────────────────────────────────────────────
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi
