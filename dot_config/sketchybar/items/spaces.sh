#!/usr/bin/env bash
#
# AeroSpace workspace indicators. One item per workspace, pinned to the
# monitor it lives on. The active workspace is highlighted; clicking jumps
# to it. Highlight/app-icon logic lives in plugins/aerospace.sh.

source "$UTIL_DIR/displays.sh"

# Workspace id -> its alt-<key> binding (see ~/.aerospace.toml).
# A case statement is used because macOS bash 3.2 has no associative arrays.
ws_key() {
  case "$1" in
    1) echo q ;; 2) echo w ;; 3) echo e ;; 4) echo a ;; 5) echo s ;; 6) echo d ;;
    7) echo z ;; 8) echo x ;; 9) echo c ;; A) echo r ;; B) echo f ;; C) echo v ;;
    *) echo "$1" ;;
  esac
}

# Workspace -> nsscreen id, resolved to a SketchyBar display via ns_to_display.
WS_NSSCREEN_MAP="$(aerospace list-workspaces --all --format '%{workspace}|%{monitor-appkit-nsscreen-screens-id}')"

for sid in $(aerospace list-workspaces --all); do
  ns=$(echo "$WS_NSSCREEN_MAP" | awk -F'|' -v s="$sid" '$1==s{print $2}')
  display=$(ns_to_display "$ns")
  sketchybar --add item space.$sid left \
             --subscribe space.$sid aerospace_workspace_change front_app_switched \
             --set space.$sid \
                   display="$display" \
                   icon="$(ws_key $sid)" \
                   icon.font="SF Pro:Bold:14.0" \
                   icon.padding_left=10 \
                   icon.padding_right=4 \
                   label.font="sketchybar-app-font:Regular:16.0" \
                   label.padding_left=4 \
                   label.padding_right=10 \
                   label.drawing=off \
                   background.color=$ACCENT_COLOR \
                   background.drawing=off \
                   click_script="aerospace workspace $sid" \
                   script="$PLUGIN_DIR/aerospace.sh $sid"
done
