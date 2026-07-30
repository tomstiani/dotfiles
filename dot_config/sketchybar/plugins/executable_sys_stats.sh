#!/usr/bin/env bash
#
# Minimal CPU + RAM indicator in the bar, with a detailed popup
# (CPU/RAM/Disk/Uptime + top processes).

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/utils/interactions.sh"; hover_guard

# One top sample feeds both CPU (idle) and the PhysMem line.
TOP="$(top -l 2 -n 0)"
cpu_idle="$(echo "$TOP" | grep -E 'CPU usage' | tail -1 | sed -E 's/.* ([0-9.]+)% idle.*/\1/')"
cpu="$(awk -v i="${cpu_idle:-100}" 'BEGIN{printf "%.0f", 100 - i}')"

free="$(memory_pressure 2>/dev/null | sed -nE 's/.*free percentage: ([0-9]+)%.*/\1/p')"
ram="$(( 100 - ${free:-0} ))"

# Bar label.
sketchybar --set "$NAME" label="􀫥 ${cpu}%  􀫦 ${ram}%"

# ---- Popup detail rows --------------------------------------------------
phys="$(echo "$TOP" | grep -E 'PhysMem' | tail -1 | sed -E 's/PhysMem: //; s/\.$//')"
total_gb="$(awk -v b="$(sysctl -n hw.memsize)" 'BEGIN{printf "%.0f", b/1073741824}')"
top_cpu="$(ps -Aco %cpu,comm -r | sed -n '2p' | awk '{pct=$1;$1="";sub(/^ /,"");print $0" ("pct"%)"}')"
top_mem="$(ps -Aco %mem,comm -m | sed -n '2p' | awk '{pct=$1;$1="";sub(/^ /,"");print $0" ("pct"%)"}')"
disk="$(df -h /System/Volumes/Data | awk 'NR==2{print $3" / "$2" ("$5")"}')"
up="$(uptime | sed -E 's/^.*up +//; s/, *[0-9]+ users?.*//')"
load="$(sysctl -n vm.loadavg | awk '{print $2}')"

sketchybar --set sys_stats.cpu  label="${cpu}%   ↳ ${top_cpu}" \
           --set sys_stats.mem  label="${ram}% of ${total_gb}G   ↳ ${top_mem}" \
           --set sys_stats.disk label="${disk}" \
           --set sys_stats.load label="${up}   ·   load ${load}" \
           2>/dev/null
