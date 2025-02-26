#!/bin/bash


if grep -q 'summer-day' ~/.config/hypr/hyprland.conf;
then
    sed -i 's/summer-day/summer-night/g' ~/.config/hypr/hyprland.conf
else 
  sed -i 's/summer-night/summer-day/g' ~/.config/hypr/hyprland.conf
fi