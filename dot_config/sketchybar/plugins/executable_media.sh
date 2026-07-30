#!/usr/bin/env bash
#
# System-wide now-playing (center), via `media-control` (MediaRemote reader
# that works on macOS 26). Passive read - never activates/steals focus, and
# catches any source: Spotify, Music, browsers, etc.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/interactions.sh"; hover_guard

out="$(media-control get 2>/dev/null | python3 -c '
import sys, json
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit()
title  = (d.get("title")  or "").strip()
artist = (d.get("artist") or "").strip()
if not title and not artist:
    sys.exit()
state = "playing" if d.get("playing") else "paused"
label = title if not artist else f"{artist} \u2013 {title}"
print(state + "\t" + label)
')"

if [ -z "$out" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

state="${out%%$'\t'*}"
label="${out#*$'\t'}"
[ "$state" = playing ] && icon=􀊆 || icon=􀊄   # pause / play (the click action)

sketchybar --set "$NAME" drawing=on icon="$icon" label="$label"
