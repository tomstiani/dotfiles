#!/usr/bin/env bash
#
# Shows the next upcoming meeting only when it starts within THRESHOLD_MIN
# minutes; hidden otherwise. Reads the event via the bundled EventKit helper.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/interactions.sh"; hover_guard

BIN="$CONFIG_DIR/utils/NextMeeting.app/Contents/MacOS/NextMeeting"
THRESHOLD_MIN=60   # only show within this many minutes of the meeting

out="$("$BIN" 2>/dev/null)"
if [ -z "$out" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

mins="${out%%|*}"
title="${out#*|}"

# Hide if unexpected, already-passed, or further out than the threshold.
case "$mins" in *[!0-9-]*|'') sketchybar --set "$NAME" drawing=off; exit 0 ;; esac
if [ "$mins" -lt 0 ] || [ "$mins" -gt "$THRESHOLD_MIN" ]; then
  sketchybar --set "$NAME" drawing=off; exit 0
fi

# Human-friendly countdown: "now", "45m", "2h", "2h 15m".
if [ "$mins" -le 0 ]; then
  when="now"
elif [ "$mins" -lt 60 ]; then
  when="${mins}m"
else
  h=$(( mins / 60 )); m=$(( mins % 60 ))
  if [ "$m" -eq 0 ]; then when="${h}h"; else when="${h}h ${m}m"; fi
fi

# Truncate long titles.
if [ "${#title}" -gt 24 ]; then
  title="$(printf '%.23s' "$title")…"
fi

# Highlight the icon when the meeting is imminent.
icon_color="$WHITE"
[ "$mins" -le 5 ] && icon_color="$ACCENT_COLOR"

sketchybar --set "$NAME" drawing=on \
           icon=􀐬 \
           icon.color="$icon_color" \
           label="$title · $when"
