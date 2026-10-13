# 🍙 Haku Dotfiles (CachyOS / Arch Linux)

Bộ cấu hình cá nhân hóa tối ưu cao dành cho **CachyOS (Arch Linux)** chạy trình quản lý cửa sổ dạng cuộn vô tận **Niri (Wayland)**.

---

## 🖥️ Thông số môi trường (System Specs)

- **Hệ điều hành**: CachyOS Linux (Kernel `linux-cachyos`)
- **Trình quản lý cửa sổ**: [Niri](https://github.com/YaLTeR/niri) (Scrollable-tiling Wayland compositor)
- **Thanh trạng thái**: [Waybar](https://github.com/Alexays/Waybar)
- **Trình khởi chạy & Menu**: [Rofi-wayland](https://github.com/lbonn/rofi-wayland)
- **Terminal**: [Kitty](https://sw.kovidgoyal.net/kitty/)
- **Vỏ lệnh (Shell)**: [Fish Shell](https://fishshell.com/) + [Starship Prompt](https://starship.rs/)
- **Trình soạn thảo (IDE)**: Visual Studio Code (`One Dark Pro Darker` + `JetBrainsMono Nerd Font`)
- **Trung tâm thông báo**: [SwayNC](https://github.com/ErikReider/SwayNotificationCenter)
- **Âm thanh & Bluetooth**: PipeWire + WirePlumber (Tự động chuyển đổi codec A2DP/HFP) + EasyEffects

---

## 📦 Các gói phần mềm cần cài đặt (Dependencies)

### 1. Gói chính thức (Official Repositories)
```bash
sudo pacman -S --needed \
    niri waybar rofi-wayland kitty fish starship swaync \
    code wl-clipboard cliphist grim slurp brightnessctl playerctl \
    tumbler thunar thunar-archive-plugin file-roller \
    easyeffects lsp-plugins-lv2 rnnoise earlyoom \
    ttf-jetbrains-mono-nerd noto-fonts-emoji
```

### 2. Gói AUR (qua Paru / Yay)
```bash
paru -S --needed xwaylandvideobridge-bin
```

---

## 🚀 Hướng dẫn khôi phục (Quick Installation)

Khi cài lại máy hoặc chuyển sang laptop mới, bạn chỉ cần thực hiện 3 bước:

```bash
# 1. Clone repository về thư mục cá nhân
git clone git@github.com:Rio219/dotfiles.git ~/dotfiles

# 2. Di chuyển vào thư mục và chạy script tự động liên kết
cd ~/dotfiles
./install.sh

# 3. Đăng xuất và đăng nhập lại để nạp toàn bộ cấu hình mới!
```

---

## ⌨️ Bảng phím tắt cốt lõi (Keybindings)

Phím chính: `Mod` (thường là phím `Super` / `Windows`)

### Ứng dụng & Tiện ích
| Phím tắt | Tác vụ |
| :--- | :--- |
| `Mod + Q` | Mở Terminal (Kitty) |
| `Mod + I` | Mở Trình soạn thảo IDE (VS Code) |
| `Mod + B` | Mở Trình duyệt Web (Edge) |
| `Mod + E` | Mở Quản lý tệp tin (Thunar) |
| `Mod + R` | Mở Menu ứng dụng (Rofi) |
| `Mod + N` | Mở Trung tâm thông báo (SwayNC) |
| `Mod + V` | Mở Lịch sử Clipboard (Cliphist) |
| `Mod + Tab` | Mở Menu điều khiển nhanh (Hakumenu) |
| `Mod + Y` | Đổi hình nền ngẫu nhiên |
| `Mod + Alt + L` | Khóa màn hình (Lock screen) |

### Quản lý cửa sổ Niri
| Phím tắt | Tác vụ |
| :--- | :--- |
| `Mod + C` | Đóng cửa sổ hiện tại |
| `Mod + F` | Bật/Tắt chế độ Toàn màn hình (Maximize) |
| `Mod + Shift + Space` | Chuyển cửa sổ sang dạng Nổi (Floating) |
| `Mod + H / J / K / L` | Di chuyển tiêu điểm (Trái / Dưới / Trên / Phải) |
| `Mod + Shift + H / J / K / L` | Di chuyển vị trí cửa sổ |
| `Mod + WheelScrollDown / Up` | Cuộn nhanh giữa các workspace |

---

## 📁 Cấu trúc thư mục

```text
dotfiles/
├── .config/
│   ├── niri/           # Cấu hình phím tắt, window rules, hiệu ứng Niri
│   ├── waybar/         # Giao diện thanh Waybar top & left
│   ├── kitty/          # Cấu hình terminal Kitty
│   ├── rofi/           # Theme và menu Rofi
│   ├── swaync/         # Trung tâm thông báo SwayNC
│   ├── fish/           # Cấu hình shell Fish
│   ├── wireplumber/    # Tự động chuyển profile Bluetooth A2DP/HFP
│   ├── Code/           # Thiết lập VS Code (settings.json, font, theme)
│   ├── code-flags.conf # Cờ Wayland cho VS Code
│   └── starship.toml   # Giao diện dòng lệnh Starship
├── .local/bin/         # Tập hợp các bash script tiện ích
├── install.sh          # Script cài đặt & symlink tự động
└── README.md           # Tài liệu hướng dẫn sử dụng
```
