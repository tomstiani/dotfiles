#!/usr/bin/env bash
#
# Maps AeroSpace's nsscreen-screens-id to SketchyBar's display (arrangement)
# index. The two orderings differ, so we correlate them through the shared
# CoreGraphics display id (NSScreen's NSScreenNumber == SketchyBar's
# DirectDisplayID). Source this file, then call: ns_to_display <nsscreen-id>.

# nsscreen index -> DirectDisplayID (order matches AeroSpace's nsscreen ids).
NS_TO_DDID="$(swift - <<'EOF' 2>/dev/null
import AppKit
for (i,s) in NSScreen.screens.enumerated() {
  let n=(s.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as! NSNumber).uint32Value
  print("\(i+1) \(n)")
}
EOF
)"

# arrangement id -> DirectDisplayID (this is SketchyBar's display=N index).
ARR_TO_DDID="$(sketchybar --query displays | python3 -c 'import sys,json
try: ds=json.load(sys.stdin)
except Exception: ds=[]
for d in ds: print(d["arrangement-id"], d["DirectDisplayID"])')"

# CGDirectDisplayID of the built-in display (empty if there is none).
BUILTIN_DDID="$(swift - <<'EOF' 2>/dev/null
import CoreGraphics
var count: UInt32 = 0
CGGetOnlineDisplayList(0, nil, &count)
var ids = [CGDirectDisplayID](repeating: 0, count: Int(count))
CGGetOnlineDisplayList(count, &ids, &count)
for d in ids where CGDisplayIsBuiltin(d) != 0 { print(d) }
EOF
)"

# Comma-separated SketchyBar display ids that are NOT the built-in display.
# Echoes "99" (a non-existent display) when only the built-in is present, so an
# item assigned to this list shows nowhere instead of everywhere.
non_builtin_displays() {
  local list
  list="$(echo "$ARR_TO_DDID" | awk -v b="$BUILTIN_DDID" '$2!=b{print $1}' | paste -sd, -)"
  echo "${list:-99}"
}

# nsscreen id -> SketchyBar display, via the shared DirectDisplayID.
ns_to_display() {
  local ddid arr
  ddid=$(echo "$NS_TO_DDID" | awk -v n="$1" '$1==n{print $2}')
  arr=$(echo "$ARR_TO_DDID" | awk -v d="$ddid" '$2==d{print $1}')
  echo "${arr:-$1}"   # fall back to the raw nsscreen id if correlation fails
}
