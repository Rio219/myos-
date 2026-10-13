#!/bin/bash

spawn() { ( "$@" & ) >/dev/null 2>&1; disown; }

if [[ $# -eq 0 ]]; then
    cat <<'EOF'
󰖩  Wifi
󰂯  Bluetooth
  Disk Manager
󰋊  Storage Manager
󰓃  Audio Control
  HakuMenu General Tab
  HakuMenu Theme Tab
  HakuMenu Setting Tab
EOF
    exit 0
fi

chosen="$*"
case "$chosen" in
    *"Wifi"*) spawn "$HOME/.local/bin/wifi_menu.sh" ;;
    *"Bluetooth"*)
        if command -v blueman-manager >/dev/null 2>&1; then
            spawn blueman-manager
        else
            spawn kitty --class bluetoothctl -e bluetoothctl
        fi
        ;;
    *"Disk Manager"*) spawn gparted ;;
    *"Storage Manager"*) spawn kitty --class ncdu -e sudo ncdu / ;;
    *"Audio Control"*) spawn pavucontrol ;;
    *"HakuMenu General Tab"*) spawn code $HOME/.local/bin/hm_general.sh ;;
    *"HakuMenu Theme Tab"*) spawn code $HOME/.local/bin/hm_theme.sh ;;
    *"HakuMenu Setting Tab"*) spawn code $HOME/.local/bin/hm_setting.sh ;;
esac

exit 0