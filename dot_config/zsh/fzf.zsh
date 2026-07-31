# fzf shell integration (keybindings + completion)
eval "$(fzf --zsh)"

# Use fd as the default command (respects .gitignore, faster than find)
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Default options: layout, colors, info
export FZF_DEFAULT_OPTS="
  --height 40%
  --layout=reverse
  --border=rounded
  --info=inline
  --prompt='  '
  --pointer='▶'
  --marker='✓'
  --bind='ctrl-/:toggle-preview'
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
"

# CTRL-T: paste selected file path into the command line
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="
  --preview 'bat --color=always --style=numbers --line-range=:200 {}'
  --preview-window 'right:60%:wrap'
"

# ALT-C: cd into selected directory
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="
  --preview 'eza --tree --color=always --icons --level=2 {}'
  --preview-window 'right:50%'
"

# CTRL-R: history search with full command preview
export FZF_CTRL_R_OPTS="
  --preview 'echo {}'
  --preview-window 'down:3:wrap'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --header 'CTRL-Y to copy to clipboard'
"
