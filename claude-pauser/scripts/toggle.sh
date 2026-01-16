#!/bin/bash
# Toggle Claude Pauser enabled/disabled state

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/claude-pauser"
STATE_FILE="$STATE_DIR/enabled"

mkdir -p "$STATE_DIR"

if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "1" ]; then
    echo "0" > "$STATE_FILE"
    echo "Claude Pauser: DISABLED"
else
    echo "1" > "$STATE_FILE"
    echo "Claude Pauser: ENABLED"
fi
