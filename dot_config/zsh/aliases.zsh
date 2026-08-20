# ─── General ──────────────────────────────────────────────────────────────────
alias c='clear'
alias q='exit'
alias mkdir='mkdir -p'          # Create parent dirs automatically
alias cp='cp -iv'               # Interactive + verbose
alias mv='mv -iv'               # Interactive + verbose
alias rm='rm -iv'               # Interactive + verbose
alias gg='lazygit'

# ─── Editor ───────────────────────────────────────────────────────────────────
alias vim='nvim'
alias vi='nvim'

alias oc='opencode --port'

# ─── Navigation ───────────────────────────────────────────────────────────────
alias h='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'               # Go back to previous directory

# ─── eza (modern ls) ──────────────────────────────────────────────────────────
alias ls='eza --icons --group-directories-first'
alias ll='eza --icons --long --group-directories-first'
alias la='eza --icons --long --all --group-directories-first'
alias lt='eza --icons --tree --level=2'
alias lta='eza --icons --tree --level=2 --all'

# ─── bat (modern cat) ─────────────────────────────────────────────────────────
alias cat='bat --paging=never'
alias bat='bat --paging=never'
alias catp='bat'                # bat with paging

# ─── ripgrep ──────────────────────────────────────────────────────────────────
alias grep='rg'

# ─── fd ───────────────────────────────────────────────────────────────────────
alias find='fd'

# ─── Git ──────────────────────────────────────────────────────────────────────
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate'

# ─── Worktrunk ─────────────────────────────────────────────────────────────────
alias wts='wt switch'
alias wtc='wt switch --create'
alias wtl='wt list'
alias wtr='wt remove'
