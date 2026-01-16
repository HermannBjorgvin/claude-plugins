#!/bin/bash
# Resume media player (PostToolUse, PostToolUseFailure, Stop, UserPromptSubmit hooks)
# Fails gracefully if not at home (HA unreachable)

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/tv-pauser/enabled"
PAUSED_MARKER="/tmp/tv-pauser.paused"
LAST_ACTION_FILE="/tmp/tv-pauser.lastaction"

# Check if pauser is disabled (enabled by default)
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "0" ]; then
    exit 0  # Pauser is disabled, do nothing
fi

# Only resume if we actually paused
if [ ! -f "$PAUSED_MARKER" ]; then
    exit 0
fi

# Remove marker and record action time
rm -f "$PAUSED_MARKER"
date +%s > "$LAST_ACTION_FILE"

# Resume media player via Home Assistant (graceful failure with timeout)
curl -s -f --connect-timeout 2 --max-time 5 \
  -X POST "${TV_PAUSER_HA_URL:-http://homeassistant.local:8123}/api/services/media_player/media_play" \
  -H "Authorization: Bearer $TV_PAUSER_HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"entity_id\": \"${TV_PAUSER_HA_ENTITY:-media_player.apple_tv}\"}" \
  >/dev/null 2>&1 || true  # Fail silently - probably not at home

exit 0
