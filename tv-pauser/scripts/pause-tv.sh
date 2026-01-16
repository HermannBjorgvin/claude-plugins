#!/bin/bash
# Pause media player when Claude needs attention (PermissionRequest, Stop hooks)
# Fails gracefully if not at home (HA unreachable)

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/tv-pauser/enabled"
PAUSED_MARKER="/tmp/tv-pauser.paused"
LAST_ACTION_FILE="/tmp/tv-pauser.lastaction"
DEBOUNCE_SECONDS=2

# Check if pauser is disabled (enabled by default)
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "0" ]; then
    exit 0  # Pauser is disabled, do nothing
fi

# Skip if already paused
if [ -f "$PAUSED_MARKER" ]; then
    exit 0
fi

# Debounce: skip if we recently acted (pause or resume)
if [ -f "$LAST_ACTION_FILE" ]; then
    last_action=$(cat "$LAST_ACTION_FILE" 2>/dev/null || echo 0)
    now=$(date +%s)
    if [ $((now - last_action)) -lt $DEBOUNCE_SECONDS ]; then
        exit 0
    fi
fi

# Mark as paused and record action time
touch "$PAUSED_MARKER"
date +%s > "$LAST_ACTION_FILE"

# Pause media player via Home Assistant (graceful failure with timeout)
curl -s -f --connect-timeout 2 --max-time 5 \
  -X POST "${TV_PAUSER_HA_URL:-http://homeassistant.local:8123}/api/services/media_player/media_pause" \
  -H "Authorization: Bearer $TV_PAUSER_HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"entity_id\": \"${TV_PAUSER_HA_ENTITY:-media_player.apple_tv}\"}" \
  >/dev/null 2>&1 || true  # Fail silently - probably not at home

exit 0
