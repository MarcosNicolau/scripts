#!/bin/sh

# gsettings
gsettings set org.gnome.desktop.interface gtk-theme $1
gsettings set org.gnome.desktop.wm.preferences theme $1
