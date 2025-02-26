if pgrep waybar; then 
    killall waybar
else
    COLOR_SCHEME=$(cat ~/.config/hypr/themes/$1/$1.json | jq -r ".colorScheme")
    waybar --config ~/.config/waybar/$COLOR_SCHEME/config --style ~/.config/waybar/$COLOR_SCHEME/style.css &
fi
