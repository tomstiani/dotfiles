#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/app_icon.sh"

# $1 = the workspace id this item represents.
sid="$1"

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
VISIBLE="$(aerospace list-workspaces --monitor all --visible)"

# --- Build the app-icon label from the windows in this workspace ---------
apps="$(aerospace list-windows --workspace "$sid" --format '%{app-name}' 2>/dev/null | sort -u)"

icons=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  icons+="$(app_icon "$app") "   # unmapped apps fall back to :default:
done <<< "$apps"
icons="${icons% }"   # trim trailing space

# --- Determine state -----------------------------------------------------
is_visible=false
echo "$VISIBLE" | grep -qx "$sid" && is_visible=true

# Hide workspaces that are both empty AND not visible on any monitor.
if [ -z "$apps" ] && ! $is_visible; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Show the label only when there are app icons to render.
if [ -n "$icons" ]; then
  label_args=(label="$icons" label.drawing=on)
else
  label_args=(label.drawing=off)
fi

# Style by state:
#   focused        -> solid accent background
#   visible (other monitor) -> half-transparent accent (derived from ACCENT_COLOR)
#   hidden/inactive -> no background
if [ "$sid" = "$FOCUSED" ]; then
  bg_args=(background.drawing=on background.color="$ACCENT_COLOR"); fg="$BAR_COLOR"
elif $is_visible; then
  bg_args=(background.drawing=on background.color="0x80${ACCENT_COLOR#0xff}"); fg="$BAR_COLOR"
else
  bg_args=(background.drawing=off); fg="$WHITE"
fi

sketchybar --animate sin 8 --set "$NAME" drawing=on \
           "${bg_args[@]}" icon.color="$fg" label.color="$fg" \
           "${label_args[@]}"
