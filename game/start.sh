set -x

# [ENV] GAMING
export WINEESYNC=1                 # ESync
export RADV_PERFTEST=gpl,rt
export VKD3D_CONFIG=dxr11
#export VKD3D_CONFIG=no_upload_hvv # Halo Infinite
#export DXVK_ASYNC=1               # Obsolete, breaks anticheat, not used in DX12 games

# [ENV] DESKTOP
export XDG_CURRENT_DESKTOP=wayland

# [ENV] WINDOW MANAGER [https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md]
#export WLR_RENDERER=vulkan        # [WLR] Faster API (occasionally causes flickering when moving windows)
export WLR_DRM_NO_ATOMIC=1         # [VRR] Use Legacy API: fix cursor stuttering
export WLR_DRM_NO_MODIFIERS=1      # [VRR] Legacy API: fix flickering

# [RUN] START [50-systemd-user.conf handles DBUS]
# Debug: -d &| tee sway.log
# Perf : -Dnoscanout               # Fixes VRR stuttering
exec sway -Dnoscanout
