sudo setcap 'cap_sys_nice=eip' $(which gamescope)
gamescope -W 3840 -H 1600 -r 120 --adaptive-sync -e -f -- steam -gamepadui
