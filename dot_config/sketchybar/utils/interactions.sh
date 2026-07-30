#!/usr/bin/env bash
#
# Shared hover animation. Source this in a plugin and call `hover_guard` near
# the top. On mouse enter/leave it animates the item's background and then
# exits the whole script (so hover events don't fall through to the plugin's
# normal logic). Items must --subscribe to mouse.entered and mouse.exited.

hover_guard() {
  source "$CONFIG_DIR/colors.sh"
  case "$SENDER" in
    mouse.entered)
      sketchybar --animate sin 12 --set "$NAME" background.color="$HOVER_COLOR"
      exit 0 ;;
    mouse.exited|mouse.exited.global)
      sketchybar --animate sin 12 --set "$NAME" background.color="$ITEM_BG_COLOR"
      exit 0 ;;
  esac
}
