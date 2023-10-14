#!/bin/sh

# V1
#set $display_w 1920px
#set $display_h 1080px
#for_window [class="steamwebhelper" title="SP"] \
#    fullscreen disable; \
#    floating enable;  \
#    border pixel 0; \
#    resize set $display_w $display_h; \
#    move absolute position 0 0

# V2
while true; do
  swaymsg -t subscribe '["window"]' |
    jq 'select(.change == "focus" or .change == "fullscreen_mode").container | if (.app_id == "firefox") then halt_error(127-.fullscreen_mode) else halt end'
    [[ $? -eq 127 ]] && swaymsg fullscreen enable
done
