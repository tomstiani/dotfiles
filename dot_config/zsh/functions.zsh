ldf() {
  lazygit \
    --git-dir="$HOME/.dotfiles" \
    --work-tree="$HOME"
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}

_repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

_tmux_name() {
  print -r -- "$1" | tr '/.:' '___'
}

_repo_session() {
  _tmux_name "$(basename "$(_repo_root)")"
}

_tmux_go() {
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$1"
  else
    tmux attach -t "$1"
  fi
}

_repo_dashboard() {
  local root session
  root="$(_repo_root)"
  session="$(_repo_session)"

  if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -n dashboard -c "$root" 'gh dash; exec $SHELL'
  elif ! tmux list-windows -t "$session" -F '#W' | grep -Fxq dashboard; then
    tmux new-window -d -t "$session:" -n dashboard -c "$root" 'gh dash; exec $SHELL'
  fi
}

rdash() {
  local target cmd dead

  if [ -n "$TMUX" ]; then
    target="$(tmux display-message -p '#{pane_id}')"
    tmux rename-window -t "$(tmux display-message -p '#{window_id}')" dashboard
    cmd="$(tmux display-message -p -t "$target" '#{pane_current_command}')"
    dead="$(tmux display-message -p -t "$target" '#{pane_dead}')"
    if [ "$dead" = 1 ] || [ "$cmd" != gh ]; then
      tmux respawn-pane -k -t "$target" -c "$(_repo_root)" 'gh dash; exec $SHELL'
    fi
    return
  fi

  _repo_dashboard
  _tmux_go "$(_repo_session):dashboard"
}

_tmux_landscape() {
  local target width height
  target="$1"
  width="$(tmux display-message -p -t "$target" '#{window_width}')"
  height="$(tmux display-message -p -t "$target" '#{window_height}')"

  [ "$width" -ge 120 ] && [ "$width" -ge $((height * 2)) ]
}

_rtask_complete() {
  local target root panes
  target="$1"
  root="$2"
  panes="$(tmux list-panes -t "$target" 2>/dev/null | wc -l | tr -d ' ')"

  if _tmux_landscape "$target"; then
    if [ "$panes" -lt 2 ]; then
      tmux split-window -h -t "$target.0" -c "$root" 'pi; exec $SHELL'
      panes=2
    fi
    if [ "$panes" -lt 3 ]; then
      tmux split-window -v -t "$target.1" -c "$root"
    fi
    tmux select-layout -t "$target" main-vertical
  else
    if [ "$panes" -lt 2 ]; then
      tmux split-window -v -b -t "$target.0" -c "$root" 'pi; exec $SHELL'
      panes=2
    fi
    if [ "$panes" -lt 3 ]; then
      tmux split-window -v -l 20% -t "$target.1" -c "$root"
    fi
  fi
}

_rtask_window() {
  local root session window target
  root="$1"
  session="$2"
  window="$3"
  target="$session:$window"

  if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "$window"; then
    tmux new-window -d -t "$session:" -n "$window" -c "$root" 'nvim .; exec $SHELL'
  fi

  _rtask_complete "$target" "$root"
}

rtask() {
  local root session window
  root="$(_repo_root)"
  session="$(_repo_session)"
  window="${1:-$(git -C "$root" branch --show-current 2>/dev/null)}"
  window="${window:-task}"

  _repo_dashboard
  _rtask_window "$root" "$session" "$window"
  _tmux_go "$session:$window"
}

_rpr_setup() {
  local repo pr session window opener root
  repo="$1"
  pr="$2"
  session="$3"
  window="$4"
  opener="$5"

  root="$(command wt -C "$repo" switch --no-hooks "pr:$pr" --format json | python3 -c 'import json,sys; print(json.load(sys.stdin)["path"])')" || exec $SHELL
  [ -n "$root" ] || exec $SHELL

  _rtask_complete "$session:$window" "$root"
  cd "$root" || exec $SHELL
  if [ "$opener" = tuicr ]; then
    tuicr pr "$pr"
  else
    nvim "$root"
  fi
  exec $SHELL
}

rpr() {
  local repo pr branch author me opener session window legacy target cmd pane0
  repo="${1:-$(_repo_root)}"
  repo="${repo/#\~/$HOME}"
  pr="$2"
  [ -n "$pr" ] || { echo "usage: rpr <repo-path> <pr-number>" >&2; return 2; }

  branch="$(cd "$repo" && gh pr view "$pr" --json headRefName --jq .headRefName 2>/dev/null)"
  author="$(cd "$repo" && gh pr view "$pr" --json author --jq .author.login 2>/dev/null)"
  me="$(gh api user --jq .login 2>/dev/null)"
  opener=nvim
  [ -n "$author" ] && [ -n "$me" ] && [ "$author" != "$me" ] && opener=tuicr

  session="$(_tmux_name "$(basename "$repo")")"
  window="$(_tmux_name "${branch:-pr-$pr}")"
  legacy="pr-$pr"
  target="$session:$window"
  cmd="source ~/.zshrc; _rpr_setup ${(q)repo} ${(q)pr} ${(q)session} ${(q)window} ${(q)opener}"

  if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -n dashboard -c "$repo" 'gh dash; exec $SHELL'
  fi

  if [ "$legacy" != "$window" ] && tmux list-windows -t "$session" -F '#W' | grep -Fxq "$legacy"; then
    tmux kill-window -t "$session:$legacy"
  fi

  if ! tmux list-windows -t "$session" -F '#W' | grep -Fxq "$window"; then
    tmux new-window -d -t "$session:" -n "$window" -c "$repo" "zsh -ic ${(q)cmd}"
  elif [ "$(tmux list-panes -t "$target" | wc -l | tr -d ' ')" -lt 3 ]; then
    pane0="$(tmux display-message -p -t "$target.0" '#{pane_current_command}')"
    if [ "$pane0" = zsh ]; then
      tmux respawn-pane -k -t "$target.0" -c "$repo" "zsh -ic ${(q)cmd}"
    else
      _rtask_complete "$target" "$(tmux display-message -p -t "$target.0" '#{pane_current_path}')"
    fi
  fi

  _tmux_go "$target"
}

rtuicr() {
  if _tmux_landscape "$(tmux display-message -p '#{window_id}')"; then
    tmux split-window -h -l 60% 'tuicr -w; exec $SHELL'
  else
    tmux split-window -v -l 50% 'tuicr -w; exec $SHELL'
  fi
}
