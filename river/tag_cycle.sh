#!/bin/sh
CURRENT=$(river-bedload -print focused | jq -r '.[0].focused_id')

if [ -z "$CURRENT" ] || [ "$CURRENT" -eq 0 ]; then
    CURRENT=1
fi

TOTAL_TAGS=5

if [ "$1" = "next" ]; then
    NEXT=$((CURRENT + 1))
    [ "$NEXT" -gt "$TOTAL_TAGS" ] && NEXT=1
elif [ "$1" = "prev" ]; then
    NEXT=$((CURRENT - 1))
    [ "$NEXT" -lt 1 ] && NEXT=$TOTAL_TAGS
else
    exit(1)
fi

TAG_MASK=$((1 << (NEXT - 1)))

riverctl set-focused-tags $TAG_MASK
