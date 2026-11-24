#!/bin/bash
# Install Workspace Apps for the current user (no root needed).
#   ./install.sh
set -euo pipefail

cd "$(dirname "$0")"
BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"

missing=()
python3 -c 'import gi; gi.require_version("Gtk", "4.0"); gi.require_version("Adw", "1")' 2>/dev/null ||
  missing+=(python-gobject gtk4 libadwaita)
command -v hyprctl >/dev/null || missing+=(hyprland)
if ((${#missing[@]})); then
  echo "Missing dependencies. On Arch / Omarchy install them with:"
  echo "  sudo pacman -S --needed ${missing[*]}"
  exit 1
fi

if [[ ! -f $HOME/.config/hypr/hyprland.lua ]]; then
  echo "warning: ~/.config/hypr/hyprland.lua not found."
  echo "Workspace Apps writes Lua config, which needs Hyprland 0.55 or newer."
fi

install -Dm755 workspace-apps "$BIN/workspace-apps"
install -Dm644 /dev/stdin "$APPS/workspace-apps.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Workspace Apps
GenericName=Assign apps to workspaces
Comment=Pin apps to Hyprland workspaces with drag and drop
Exec=$BIN/workspace-apps
Icon=view-grid-symbolic
Terminal=false
Categories=Settings;Utility;
Keywords=hyprland;workspace;window;rules;autostart;omarchy;
StartupWMClass=io.github.seatrips.WorkspaceApps
EOF
update-desktop-database "$APPS" 2>/dev/null || true

echo "Installed. Open \"Workspace Apps\" from your app launcher, or run: $BIN/workspace-apps"
