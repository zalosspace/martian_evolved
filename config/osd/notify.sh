#!/bin/sh

inotifywait -m -q -e modify /sys/class/backlight/*/brightness |
while read -r _; do
    qs -p "/home/zalos/.config/osd/" ipc call osd showBrightness
done
