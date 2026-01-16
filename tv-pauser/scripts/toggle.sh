#!/bin/bash
# Toggle TV Pauser enabled/disabled state

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/tv-pauser"
STATE_FILE="$STATE_DIR/enabled"

mkdir -p "$STATE_DIR"

# Enabled by default, so toggle to disabled if no file or enabled
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "0" ]; then
    echo "1" > "$STATE_FILE"
    echo "TV Pauser: ENABLED"
else
    echo "0" > "$STATE_FILE"
    echo "TV Pauser: DISABLED"
fi
