#!/usr/bin/env bash

target_workspace="$1"
regex="workspace:.*\(special:(.*)\)"
active_window_info=$(hyprctl activewindow)

if [[ -z "$target_workspace" ]]; then
  notify-send "$0 Error: no parameters provided"
  exit 1
fi

if [[ $target_workspace -gt 10 || $target_workspace -lt 1 ]]; then
  notify-send "$0 Error: invalid workspace provided"
  exit 1
fi

if [[ $active_window_info =~ $regex ]]; then
  special_workspace="${BASH_REMATCH[1]}"
  echo "$special_workspace"
  hyprctl dispatch togglespecialworkspace "$special_workspace" >/dev/null
fi

hyprctl dispatch workspace "$target_workspace" >/dev/null
exit 0
