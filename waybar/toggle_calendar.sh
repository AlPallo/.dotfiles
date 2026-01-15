#!/bin/sh

APP_ID="zen-cal"

if pgrep -f "foot.*$APP_ID" > /dev/null; then
    pkill -f "foot.*$APP_ID"
else
    foot --app-id "$APP_ID" -w 300x250 -e /run/current-system/sw/bin/zen-cal &

    wlrctl toplevel waitfor zen-cal state:active

    riverctl snap up
    riverctl move down 35
fi
