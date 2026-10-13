#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers"
THUMB_DIR="$HOME/.cache/wallpaper_thumbs"
BACKDROP_DIR="/tmp"

mkdir -p "$THUMB_DIR"

list_walls() {
    cd "$WALL_DIR" || exit
    for file in *.{jpg,jpeg,png,gif,webp}; do
        [[ -e "$file" ]] || continue
        thumb="$THUMB_DIR/$file"
        if [[ ! -f "$thumb" || "$file" -nt "$thumb" ]]; then
            magick "$WALL_DIR/$file[0]" -thumbnail 320x180^ -gravity center -extent 320x180 "$thumb" 2>/dev/null || true
        fi
        if [[ -f "$thumb" ]]; then
            echo -en "$file\0icon\x1f$thumb\n"
        else
            echo -en "$file\0icon\x1f$WALL_DIR/$file\n"
        fi
    done
}

set_wallpaper() {
    local wall="$1"
    if ! pgrep -x "awww-daemon" > /dev/null; then
        rm -f "${XDG_RUNTIME_DIR:-/run/user/$UID}"/*awww*.sock 2>/dev/null || true
        if command -v niri >/dev/null 2>&1 && [ "${XDG_CURRENT_DESKTOP:-}" = "niri" ]; then
            niri msg action spawn -- awww-daemon
        else
            nohup awww-daemon >/dev/null 2>&1 &
        fi
        sleep 0.5
    fi
    awww img "$wall" \
        --transition-type random \
        --transition-step 90 \
        --transition-fps 60

    if [[ $XDG_CURRENT_DESKTOP == "niri" ]]; then
        magick "${wall}[0]" -background black -alpha remove -set option:filter:blur 1.0 -blur 0x15 "$BACKDROP_DIR/backdrop.jpg" 2>/dev/null || true
        if [ -f "$BACKDROP_DIR/backdrop.jpg" ]; then
            awww img -n "awww-daemon-backdrop" "$BACKDROP_DIR/backdrop.jpg" 2>/dev/null || true
        fi
    fi
}

CHOICE=$(list_walls | rofi -dmenu -i -show-icons -p "Wallpaper" \
-theme-str "
    window { width: 55%; height: 65%; }
    mainbox { children: [ inputbar, listview ]; }
    listview { columns: 3; lines: 2; spacing: 10px; padding: 10px;}
    element { orientation: vertical; padding: 8px; border-radius: 12px; }
    element-icon { size: 140px; horizontal-align: 0.5; vertical-align: 0.5; }
    element-text { horizontal-align: 0.5; vertical-align: 0.5; margin: 6px 0 0 0; }
")

if [ -n "$CHOICE" ]; then
    WALL="$WALL_DIR/$CHOICE"

    # Check if mpvpaper is running and kill it to prevent conflicts with awww
    if pgrep -x "mpvpaper" > /dev/null; then
        pkill mpvpaper
    fi
    
    # 1. Set awww
    set_wallpaper "$WALL"
    
    # 2. Get accent color from wallpaper using colorthief, fallback to a default if too dark
    ACCENT=$(python3 -c '
try:
    from colorthief import ColorThief
    import sys
    def brightness(c): return sum(v*v for v in c)
    colors = ColorThief(sys.argv[1]).get_palette(color_count=5)
    brightest = max(colors,key=brightness)
    print("#%02x%02x%02x" % brightest)
except Exception:
    print("#ffffff")
' "$WALL" 2>/dev/null || echo "#ffffff")

    # 3. If the accent color is too dark, use a lighter default
    r=$(printf "%d" 0x${ACCENT:1:2})
    g=$(printf "%d" 0x${ACCENT:3:2})
    b=$(printf "%d" 0x${ACCENT:5:2})
    if [ $((r + g + b)) -lt 180 ]; then
        ACCENT="#ffffff"
    fi

    # 4. Generate theme files with the new accent color
    ~/.local/bin/gen_style.sh "$ACCENT"

    sleep 0.1
    ~/.local/bin/apply_style.sh
fi