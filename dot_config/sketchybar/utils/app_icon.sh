#!/usr/bin/env bash
#
# app_icon "App Name" -> echoes the :glyph: token for the sketchybar-app-font,
# applying local overrides on top of the upstream icon map. Used by both the
# workspace items and the front-app item so icons stay consistent.

source "$CONFIG_DIR/utils/icon_map.sh"

app_icon() {
  case "$1" in
    Ghostty) echo ":terminal:" ;;
    Zen*)    echo ":firefox:" ;;   # Zen is Firefox-based
    *)       __icon_map "$1"; echo "$icon_result" ;;
  esac
}
