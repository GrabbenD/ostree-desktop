#!/bin/sh

# V1
swaymsg -t subscribe -m '[ "window" ]' | while read line
do
    if [ "$(echo "$line" | jq -r '.change')" = "new" ]; then
        if [ "$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true).fullscreen_mode')" -eq 1 ]; then
            swaymsg fullscreen disable
            swaymsg [con_id=$(echo "$line" | jq -r '.container.id')] focus
        fi
    fi
done

# V2
#swaymsg -t subscribe -m '[ "window" ]' | while read line
#do
#    if [ "$(echo "$line" | jq -r '.change')" = "new" ]; then
#        sway_tree="$(swaymsg -t get_tree)"
#        focused_window="$(echo "$sway_tree" | jq -r '.. | select(.type?) | select(.focused==true)')"
#        fullscreen_mode="$(echo "$focused_window" | jq -r '.fullscreen_mode')"
#        app_id="$(echo "$focused_window" | jq -r '.app_id')"
#        if [ "$fullscreen_mode" = "1" ] && [ "$app_id" != "flameshot" ]; then
#            swaymsg fullscreen disable
#            swaymsg [con_id=$(echo "$line" | jq -r '.container.id')] focus
#        fi
#    fi
#done
