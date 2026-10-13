#!/usr/bin/env bash
# ==============================================================================
# Haku Dotfiles Installer (CachyOS / Arch Linux + Niri + Waybar)
# Author: Rio219
# ==============================================================================

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN_DIR="$HOME/.local/bin"

echo "🚀 Bắt đầu cài đặt Haku Dotfiles..."

# 1. Tạo thư mục đích nếu chưa có
mkdir -p "$CONFIG_DIR" "$BIN_DIR"

# 2. Sao lưu và liên kết các thư mục cấu hình
CONFIGS=("niri" "waybar" "kitty" "rofi" "swaync" "fish" "wireplumber")

for cfg in "${CONFIGS[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$cfg" ]; then
        if [ -e "$CONFIG_DIR/$cfg" ] && [ ! -L "$CONFIG_DIR/$cfg" ]; then
            echo "📦 Sao lưu $CONFIG_DIR/$cfg thành ${cfg}.bak..."
            mv "$CONFIG_DIR/$cfg" "$CONFIG_DIR/${cfg}.bak"
        fi
        echo "🔗 Liên kết $cfg..."
        rm -rf "$CONFIG_DIR/$cfg"
        ln -sf "$DOTFILES_DIR/.config/$cfg" "$CONFIG_DIR/$cfg"
    fi
done

# 3. Liên kết các file cấu hình đơn lẻ
FILES=("starship.toml" "code-flags.conf")
for file in "${FILES[@]}"; do
    if [ -f "$DOTFILES_DIR/.config/$file" ]; then
        echo "🔗 Liên kết $file..."
        ln -sf "$DOTFILES_DIR/.config/$file" "$CONFIG_DIR/$file"
    fi
done

# 4. Cấu hình VS Code
if [ -f "$DOTFILES_DIR/.config/Code/User/settings.json" ]; then
    mkdir -p "$CONFIG_DIR/Code/User"
    echo "🔗 Liên kết VS Code settings.json..."
    ln -sf "$DOTFILES_DIR/.config/Code/User/settings.json" "$CONFIG_DIR/Code/User/settings.json"
fi

# 5. Cài đặt các scripts trong ~/.local/bin
echo "⚡ Cài đặt scripts vào $BIN_DIR..."
for script in "$DOTFILES_DIR/.local/bin"/*.sh; do
    if [ -f "$script" ]; then
        base="$(basename "$script")"
        ln -sf "$script" "$BIN_DIR/$base"
        chmod +x "$BIN_DIR/$base"
    fi
done

echo ""
echo "✨ Cài đặt Dotfiles hoàn tất! Hãy đăng xuất và đăng nhập lại để nạp toàn bộ cấu hình mới."
