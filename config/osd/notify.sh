#!/bin/sh

BRIGHTNESS="/sys/class/backlight/amdgpu_bl0/brightness"

inotifywait -m -q -e modify "$BRIGHTNESS" |
while read -r _; do
    qs ipc call osd showBrightness
done
