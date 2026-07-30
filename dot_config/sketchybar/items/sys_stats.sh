#!/usr/bin/env bash
#
# Minimal CPU + RAM indicator. Click for a detailed popup. Logic in
# plugins/sys_stats.sh; popup toggle in plugins/popup_toggle.sh.

sketchybar --add item sys_stats right \
           --set sys_stats \
                 update_freq=5 \
                 script="$PLUGIN_DIR/sys_stats.sh" \
                 click_script="$PLUGIN_DIR/popup_toggle.sh sys_stats" \
                 popup.background.color="$ITEM_BG_COLOR" \
                 popup.background.corner_radius=8 \
                 popup.background.border_color="$ACCENT_COLOR" \
                 popup.background.border_width=1 \
                 popup.horizontal=off \
                 popup.align=right \
                 popup.y_offset=4 \
           --subscribe sys_stats mouse.entered mouse.exited

# Detail rows (labels filled in by plugins/sys_stats.sh).
for row in cpu mem disk load; do
  sketchybar --add item sys_stats.$row popup.sys_stats \
             --set sys_stats.$row \
                   icon.color="$ACCENT_COLOR" \
                   label="…" \
                   script="$PLUGIN_DIR/hover.sh" \
             --subscribe sys_stats.$row mouse.entered mouse.exited
done

# Row tags (in the icon slot, accent-colored).
sketchybar --set sys_stats.cpu  icon="CPU " \
           --set sys_stats.mem  icon="RAM " \
           --set sys_stats.disk icon="Disk" \
           --set sys_stats.load icon="Up  "
