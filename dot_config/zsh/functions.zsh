ldf() {
  lazygit \
    --git-dir="$HOME/.dotfiles" \
    --work-tree="$HOME"
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}
