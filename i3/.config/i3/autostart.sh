#!/bin/env bash

# compositor
killall compton
while pgrep -u $UID -x compton >/dev/null; do sleep 1; done
compton --config ~/.config/picom/picom.conf&

# Background
~/.fehbg &

# Set Caps Lock to the Escape Key (Mostly Used for Vim)
setxkbmap -option caps:escape &

#sxhkd
sxhkd -c $HOME/.config/sxhkd/sxhkdrc &
