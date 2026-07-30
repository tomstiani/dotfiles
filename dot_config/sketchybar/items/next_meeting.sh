#!/usr/bin/env bash
#
# Next meeting heads-up. Hidden unless a meeting is imminent (see plugin).
# Checks every minute. Logic in plugins/next_meeting.sh.

sketchybar --add item next_meeting right \
           --set next_meeting \
                 drawing=off \
                 update_freq=60 \
                 script="$PLUGIN_DIR/next_meeting.sh" \
                 click_script="open https://calendar.google.com" \
           --subscribe next_meeting mouse.entered mouse.exited
