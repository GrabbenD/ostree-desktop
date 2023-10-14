set -x

#
# Gaming
#

export WINEESYNC=1                 # ESync
export RADV_PERFTEST=gpl,rt
export VKD3D_CONFIG=dxr11
#export VKD3D_CONFIG=no_upload_hvv # Halo Infinite
#export DXVK_ASYNC=1               # Obsolete, breaks anticheat, not used in DX12 games

#
# Compositor
#

# https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md
export WLR_DRM_NO_ATOMIC=1    # Legacy API: fix mouse stuttering
export WLR_DRM_NO_MODIFIERS=1 # Legacy API: fix vrr flickering
export WLR_RENDERER=vulkan    # Faster API

# DBUS session is started by Sway package
# Debug: -d 2> ~/sway.log
# Fix VRR stuttering: -Dnoscanout
exec sway -Dnoscanout
