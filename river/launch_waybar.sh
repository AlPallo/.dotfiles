#!/bin/sh
[ "${FLOCKER}" != "$0" ] && exec env FLOCKER="$0" flock -en "$0" "$0" "$@" || :

killall -q waybar

sleep 0.5

while true; do
    echo "--- Starting Waybar $(date) ---" >> /tmp/waybar.log
    
    waybar >> /tmp/waybar.log 2>&1
    
    echo "Waybar crashed or exited. Restarting in 1 second..." >> /tmp/waybar.log
    sleep 1
done
