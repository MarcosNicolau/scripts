#!/bin/bash

# TODO save state in json file (previous waybar and gaps and recover that when switching out)

TOGGLE=$HOME/.fullscreen

if [ ! -e $TOGGLE ]; then
	touch $TOGGLE
    killall waybar
	hyprctl keyword general:gaps_in 0
	hyprctl keyword general:gaps_out 0
	hyprctl keyword decoration:rounding 0
	hyprctl fullscreen
else
	rm $TOGGLE
	~/.config/hypr/scripts/toggle-waybar.sh $1
	hyprctl keyword general:gaps_in 10
	hyprctl keyword general:gaps_out 20
	hyprctl keyword decoration:rounding 15
fi