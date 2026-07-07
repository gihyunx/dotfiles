#!/usr/bin/env bash

swaybg -i ~/.config/_wallpapers/kei-l2d.jpg -m fill &
waybar &
# xwayland-satellite &
mako &
~/.config/_scripts/gammastep-toggle.sh &

disown -a 
