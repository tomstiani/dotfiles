#!/usr/bin/env bash
#
# Battery indicator. Visible only when unplugged OR not at 100% charge;
# hidden when plugged in and fully charged.

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/interactions.sh"; hover_guard

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')"
ON_AC="$(echo "$BATT" | grep -c 'AC Power')"   # 1 when plugged in

# No reading available (e.g. desktop Mac) -> hide.
if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

# Hide only when plugged in AND fully charged.
if [ "$ON_AC" -gt 0 ] && [ "$PERCENTAGE" -eq 100 ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

case "$PERCENTAGE" in
  100|9[0-9]) ICON=􀛨 ;;
  [6-8][0-9]) ICON=􀺸 ;;
  [3-5][0-9]) ICON=􀺶 ;;
  [1-2][0-9]) ICON=􀛩 ;;
  *)          ICON=􀛪 ;;
esac

COLOR="$WHITE"
if [ "$ON_AC" -gt 0 ]; then
  ICON=􀢋                       # charging bolt
elif [ "$PERCENTAGE" -le 20 ]; then
  COLOR="$RED"                 # low battery, on battery power
fi

sketchybar --set "$NAME" drawing=on \
           icon="$ICON" \
           icon.color="$COLOR" \
           label="${PERCENTAGE}%"
