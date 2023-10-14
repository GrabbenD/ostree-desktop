#!/bin/bash

# List of supported outputs for VRR
output_vrr_whitelist=(
    "DP-1"
)

# Toggle VRR for fullscreened apps in prespecified displays to avoid stutters while in desktop
swaymsg -t subscribe -m '[ "window" ]' | while read window_json; do
    window_event=$(echo ${window_json} | jq -r '.change')

    # Process only focus change and fullscreen toggle
    if [[ $window_event = "focus" || $window_event = "fullscreen_mode" ]]; then
        output_json=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused == true)')
        output_name=$(echo ${output_json} | jq -r '.name')
        echo : output_name: $output_name

        # Use only VRR in whitelisted outputs
        if [[ ${output_vrr_whitelist[*]} =~ ${output_name} ]]; then
            output_vrr_status=$(echo ${output_json} | jq -r '.adaptive_sync_status')
            window_fullscreen_status=$(echo ${window_json} | jq -r '.container.fullscreen_mode')
            echo : output_vrr_status: $output_vrr_status
            echo : window_fullscreen_status: $window_fullscreen_status

            # Only update output if nesseccary to avoid flickering
            [[ $output_vrr_status = "disabled" && $window_fullscreen_status = "1" ]] && echo "Enabled vrr" && swaymsg output "${output_name}" adaptive_sync 1
            [[ $output_vrr_status = "enabled" && $window_fullscreen_status = "0" ]] && echo "Disabled vrr" && swaymsg output "${output_name}" adaptive_sync 0

            # Cursor FPS workaround
            window_pid=$(echo ${window_json} | jq -r '.container.pid')
            window_max_latency=$(echo ${window_json} | jq -r '.container.max_cursor_latency')
            echo : window_max_latency: $window_max_latency
            [[ $output_vrr_status = "disabled" && $window_fullscreen_status = "1" && ! $window_max_latency -eq 1000000 ]] && echo "Updated max_cursor_latency" && swaymsg [pid="${window_pid}"] max_cursor_latency 1000000 && swaymsg [pid="${window_pid}"] max_render_time 1
        fi

        echo
    fi
done

