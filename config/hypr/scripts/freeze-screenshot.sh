#!/bin/sh


${hyprpicker}/bin/hyprpicker -r -z & picker_proc=$!

grimblast=/home/marcos/.config/hypr/scripts/grimblast.sh

if [ $1 -eq 0 ]
then
    ${grimblast} save area "$HOME/Pictures/screenshots/$(date +'%s_grim.png')"
elif [ $1 -eq 1 ]
then
    ${grimblast} save area - | wl-copy
fi

hyprctl dispatch movecursor 0,0

kill $picker_proc
