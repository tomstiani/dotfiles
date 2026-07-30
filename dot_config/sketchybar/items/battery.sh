#!/usr/bin/env bash
#
# Battery. Refreshes on power-source changes, on wake, and every 2 min.
# Show/hide + icon logic lives in plugins/battery.sh.

sketchybar --add item battery right \
           --set battery \
                 drawing=off \
                 update_freq=120 \
                 script="$PLUGIN_DIR/battery.sh" \
           --subscribe battery power_source_change system_woke mouse.entered mouse.exited
