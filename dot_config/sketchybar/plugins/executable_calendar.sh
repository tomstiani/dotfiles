#!/bin/bash

source "$CONFIG_DIR/utils/interactions.sh"; hover_guard

# Bar clock + the full date shown inside the popup.
sketchybar --set "$NAME" label="$(date +'%a %d %b %H:%M')"
sketchybar --set calendar.date label="$(date +'%A %d %B %Y')" 2>/dev/null
