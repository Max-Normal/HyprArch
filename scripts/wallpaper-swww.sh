#!/bin/bash
# __        __    _ _                              
# \ \      / /_ _| | |_ __   __ _ _ __   ___ _ __  
#  \ \ /\ / / _` | | | '_ \ / _` | '_ \ / _ \ '__| 
#   \ V  V / (_| | | | |_) | (_| | |_) |  __/ |    
#    \_/\_/ \__,_|_|_| .__/ \__,_| .__/ \___|_|    
#                    |_|         |_|               
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

# ----------------------------------------------------- 
# Select wallpaper
# ----------------------------------------------------- 
selected=$(ls -1 ~/Pictures/Wallpapers1 | grep "jpg" | rofi -dmenu -p "Wallpapers")

if [ "$selected" ]; then

    echo "Changing theme..."
    # ----------------------------------------------------- 
    # Update wallpaper with pywal
    # ----------------------------------------------------- 
    wal -q -i ~/Pictures/Wallpapers1/$selected

    # ----------------------------------------------------- 
    # Get new theme
    # ----------------------------------------------------- 
    source "$HOME/.cache/wal/colors.sh"

    # ----------------------------------------------------- 
    # Copy color file to waybar folder
    # ----------------------------------------------------- 
    cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/
    cp $wallpaper ~/.cache/current_wallpaper.jpg   

    newwall=$(echo $wallpaper | sed "s|$HOME/Pictures/Wallpapers1/||g")

    # ----------------------------------------------------- 
    # Set the new wallpaper
    # ----------------------------------------------------- 
    swww img $wallpaper --transition-step 20 --transition-fps=20
    ~/.config/waybar/launch.sh

    # ----------------------------------------------------- 
    # Send notification
    # ----------------------------------------------------- 
    notify-send "Theme and Wallpaper updated" "With image $newwall"

    echo "Done."
fi
