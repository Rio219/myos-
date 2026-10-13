#!/usr/bin/env bash

# Trigger rescan
nmcli device wifi rescan 2>/dev/null

# Get list of SSIDs
WIFI_LIST=$(nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list | grep -v '^:' | sort -u)

if [[ -z "$WIFI_LIST" ]]; then
    notify-send "Wi-Fi" "Không tìm thấy mạng Wi-Fi nào xung quanh!"
    exit 0
fi

FORMATTED=""
while IFS=':' read -r in_use ssid signal security; do
    [[ -z "$ssid" ]] && continue
    prefix="󰖩"
    [[ "$in_use" == "*" ]] && prefix="󰖩 [Đang kết nối]"
    FORMATTED+="$prefix  $ssid ($signal%) [$security]\n"
done <<< "$WIFI_LIST"

CHOSEN=$(echo -e "$FORMATTED" | rofi -dmenu -i -p "󰖩 Chọn Wi-Fi:")

[[ -z "$CHOSEN" ]] && exit 0

# Extract SSID name
SSID=$(echo "$CHOSEN" | sed -E 's/^(󰖩 \[Đang kết nối\]|󰖩)\s+//; s/\s+\([0-9]+%\).*//')

# Try connecting directly if network is saved
if nmcli device wifi connect "$SSID" >/dev/null 2>&1; then
    notify-send "Wi-Fi" "Đã kết nối thành công tới $SSID"
else
    # Ask password via Rofi
    PASS=$(rofi -dmenu -password -p "🔑 Nhập mật khẩu Wi-Fi ($SSID):")
    if [[ -n "$PASS" ]]; then
        if nmcli device wifi connect "$SSID" password "$PASS"; then
            notify-send "Wi-Fi" "Đã kết nối thành công tới $SSID"
        else
            notify-send "Wi-Fi" "Kết nối thất bại! Sai mật khẩu hoặc lỗi mạng."
        fi
    fi
fi
