#!/bin/bash

############
# WM
###########

#startx


# När jag kör podman exec skippar den helt dbus med systemd init
# När jag loggar in så funkar mina dbus variabler för de sätts genom elogind



# Without SystemD
#if [[ -z "${XDG_RUNTIME_DIR}" ]]; then
#export XDG_RUNTIME_DIR="/run/user/$UID"
#export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
#    export XDG_RUNTIME_DIR=$(mktemp -d /tmp/$(id -u)-runtime-dir.XXX)
#
#    # Window Manager setup
#    #if [[ -z "${WAYLAND_DISPLAY}" ]]; then
#    # Trigger Hyprland only if currently using TTY0
#    # && [[ "${XDG_VTNR}" == 1 ]]
#    #fi
#
#    # Wait for dbus daemon
#    sudo dbus-daemon --system --fork
#
#    # Update DBUS_SESSION_BUS_ADDRESS since subshells can't propagate environment to parent process
#    export $(dbus-launch)
#
#    # Fork seat management daemon
#    exec sudo seatd -g video &
#
#    # Start dbus session (this isn't needed with a display/login manager)
#    exec dbus-run-session -- Hyprland &
#    # Verbose only errors
#    # &> /dev/null # |& tee hyprland.log
#
#    # Fork audio
#    exec pipewire &
#    exec wireplumber &
#    exec pipewire-pulse &
#
#    # If problem with XDG
#    # /usr/lib/xdg-desktop-portal-hyprland &
#    # /usr/lib/xdg-desktop-portal &
#fi
#