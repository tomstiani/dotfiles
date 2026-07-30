#!/usr/bin/env bash
#
# Reload SketchyBar when the physical display layout changes, so the
# AeroSpace workspace -> monitor mapping (utils/displays.sh) stays correct.
#
# Order matters: macOS fires several display_change events while displays are
# still settling (and `sketchybar --query displays` can be empty mid-change).
# So we DEBOUNCE first - only the last event in a burst proceeds - and only
# THEN query the (now-settled) layout. We compare a signature against the last
# one and reload only on a real change. This also breaks the reload loop, since
# `sketchybar --reload` itself emits display_change (identical signature).

SIG_FILE="/tmp/sketchybar_display_sig"
STAMP="/tmp/sketchybar_display_reload"

# 1. Debounce: record a token, wait for the burst to settle, bail if superseded.
token="$(date +%s%N)"
echo "$token" > "$STAMP"
sleep 1.5
[ "$(cat "$STAMP" 2>/dev/null)" = "$token" ] || exit 0

# 2. Query the settled layout.
raw="$(sketchybar --query displays 2>/dev/null)"
[ -z "$raw" ] && exit 0
sig="$(printf '%s' "$raw" | python3 -c '
import sys, json
try:
    ds = json.load(sys.stdin)
except Exception:
    sys.exit(0)
parts = []
for d in ds:
    f = d["frame"]
    parts.append("%s:%dx%d@%d,%d" % (d["DirectDisplayID"],
                 f["w"], f["h"], f["x"], f["y"]))
print(";".join(parts))')"
[ -z "$sig" ] && exit 0

# 3. Reload only if the layout actually changed.
prev="$(cat "$SIG_FILE" 2>/dev/null)"
echo "$sig" > "$SIG_FILE"
[ "$sig" = "$prev" ] && exit 0
sketchybar --reload
