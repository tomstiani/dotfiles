#!/usr/bin/env bash
#
# Generic animated popup toggle.  Usage: popup_toggle.sh <parent-item>
# Reveals the popup with a small slide-in of its child rows (items named
# "<parent>.something"), or closes it if already open.

parent="$1"
[ -z "$parent" ] && exit 0

drawing="$(sketchybar --query "$parent" | python3 -c 'import sys,json;print(json.load(sys.stdin)["popup"]["drawing"])' 2>/dev/null)"

if [ "$drawing" = "on" ]; then
  sketchybar --set "$parent" popup.drawing=off
  exit 0
fi

children="$(sketchybar --query bar \
  | python3 -c "import sys,json;print('\n'.join(json.load(sys.stdin)['items']))" \
  | grep -E "^${parent}\.")"

pre=(); post=()
for c in $children; do
  pre+=(--set "$c" y_offset=-8)
  post+=(--animate sin 18 --set "$c" y_offset=0)
done

[ ${#pre[@]} -gt 0 ] && sketchybar "${pre[@]}"
sketchybar --set "$parent" popup.drawing=on
[ ${#post[@]} -gt 0 ] && sketchybar "${post[@]}"
