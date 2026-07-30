#!/usr/bin/env bash
#
# Invisible observer: reloads SketchyBar when displays are added, removed, or
# rearranged, keeping the per-monitor workspace mapping correct on hotplug.

sketchybar --add item display_observer left \
           --set display_observer drawing=off \
                 script="$PLUGIN_DIR/reload.sh" \
           --subscribe display_observer display_change
