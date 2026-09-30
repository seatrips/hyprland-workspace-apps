#!/bin/bash
# Remove Workspace Apps and the config it generated.
#   ./uninstall.sh          remove app + generated rules (keeps your layout JSON)
#   ./uninstall.sh --purge  also delete ~/.config/hypr/workspace-apps.json
set -euo pipefail

HYPR="$HOME/.config/hypr"

pkill -f "workspace-apps --daemon" 2>/dev/null || true
rm -f "$HOME/.local/bin/workspace-apps" "$HOME/.local/share/applications/workspace-apps.desktop"

if [[ -f $HYPR/hyprland.lua ]] && grep -q "workspace-apps" "$HYPR/hyprland.lua"; then
  cp "$HYPR/hyprland.lua" "$HYPR/hyprland.lua.bak.$(date +%s)"
  sed -i '/workspace-apps/d' "$HYPR/hyprland.lua"
fi
rm -f "$HYPR/workspace-apps.lua"
[[ ${1:-} == --purge ]] && rm -f "$HYPR/workspace-apps.json"

hyprctl reload >/dev/null 2>&1 || true
echo "Workspace Apps removed."
