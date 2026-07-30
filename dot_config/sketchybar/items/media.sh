#!/usr/bin/env bash
#
# System-wide now-playing (center). Hidden when nothing is playing.
# Click toggles play/pause; scroll skips tracks. Logic in plugins/media.sh.
# Shown on external displays only (never the built-in laptop screen).

source "$UTIL_DIR/displays.sh"

sketchybar --add item media center \
           --set media \
                 display="$(non_builtin_displays)" \
                 drawing=off \
                 icon.color="$ACCENT_COLOR" \
                 label.width=240 \
                 label.scroll_duration=160 \
                 update_freq=2 \
                 script="$PLUGIN_DIR/media.sh" \
                 click_script="media-control toggle-play-pause; \"$PLUGIN_DIR/media.sh\"" \
           --subscribe media mouse.entered mouse.exited
