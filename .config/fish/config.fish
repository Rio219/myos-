source /usr/share/cachyos-fish-config/cachyos-config.fish

# Wayland Input Method (Fcitx5)
# Note: GTK_IM_MODULE is omitted on modern Wayland to let GTK use native Wayland text-input-v3
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"
set -gx GLFW_IM_MODULE ibus

# Hardware Acceleration for Intel Iris Xe iGPU
set -gx LIBVA_DRIVER_NAME iHD
set -gx MESA_LOADER_DRIVER_NAME iris
set -gx VDPAU_DRIVER va_gl

# Run fastfetch on terminal startup
function fish_greeting
    fastfetch
end



# Local binary path
fish_add_path /home/riohoang/.local/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Antigravity CLI auto-approve alias
alias agy="agy --dangerously-skip-permissions --mode accept-edits"

# Starship prompt
if type -q starship
    starship init fish | source
end
