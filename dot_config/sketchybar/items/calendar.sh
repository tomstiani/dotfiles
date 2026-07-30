#!/usr/bin/env bash
#
# Clock / date on the right side. Refreshes every 10s via plugins/calendar.sh.
# Clicking it toggles a popup with the full date + a quick action.

sketchybar --add item calendar right \
           --set calendar icon=􀉉 \
                          update_freq=10 \
                          script="$PLUGIN_DIR/calendar.sh" \
                          click_script="$PLUGIN_DIR/popup_toggle.sh calendar" \
                          popup.background.color="$ITEM_BG_COLOR" \
                          popup.background.corner_radius=8 \
                          popup.background.border_color="$ACCENT_COLOR" \
                          popup.background.border_width=1 \
                          popup.horizontal=off \
                          popup.align=right \
                          popup.y_offset=4 \
           --subscribe calendar mouse.entered mouse.exited

# --- popup children ------------------------------------------------------
# Full date (populated by plugins/calendar.sh).
sketchybar --add item calendar.date popup.calendar \
           --set calendar.date icon=􀉭 \
                               label="…" \
                               script="$PLUGIN_DIR/hover.sh" \
                               click_script="sketchybar --set calendar popup.drawing=off" \
           --subscribe calendar.date mouse.entered mouse.exited

# Quick action: open Google Calendar.
sketchybar --add item calendar.gcal popup.calendar \
           --set calendar.gcal icon=􀉤 \
                               label="Open Google Calendar" \
                               click_script="open https://calendar.google.com; sketchybar --set calendar popup.drawing=off" \
                               script="$PLUGIN_DIR/hover.sh" \
           --subscribe calendar.gcal mouse.entered mouse.exited
