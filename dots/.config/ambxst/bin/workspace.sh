#!/usr/bin/env bash

target_workspace="$1"

# 1. Validation
if [[ -z "$target_workspace" ]]; then
  notify-send "$0 Error: no parameters provided"
  exit 1
fi

# 2. Check if we are currently inside a special workspace
# We grab the name of the active workspace on the focused monitor
current_ws=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .specialWorkspace.name')

if [[ "$current_ws" =~ ^special:(.*) ]]; then
  special_name="${BASH_REMATCH[1]}"
  # Toggle it off before moving
  hyprctl dispatch togglespecialworkspace "$special_name" >/dev/null
fi

# 3. Perform the move
hyprctl dispatch workspace "$target_workspace" >/dev/null
exit 0
