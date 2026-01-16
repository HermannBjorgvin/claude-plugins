#!/bin/bash
# Resume Apple TV (PostToolUse, PostToolUseFailure, Stop, UserPromptSubmit hooks)
# Fails gracefully if not at home (HA unreachable)

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/claude-pauser/enabled"
PAUSED_MARKER="/tmp/claude-pauser.paused"
LAST_ACTION_FILE="/tmp/claude-pauser.lastaction"

# Check if pauser is enabled
if [ ! -f "$STATE_FILE" ] || [ "$(cat "$STATE_FILE")" != "1" ]; then
    exit 0  # Pauser is disabled, do nothing
fi

# Only resume if we actually paused
if [ ! -f "$PAUSED_MARKER" ]; then
    exit 0
fi

# Remove marker and record action time
rm -f "$PAUSED_MARKER"
date +%s > "$LAST_ACTION_FILE"

# Resume Apple TV via Home Assistant (graceful failure with timeout)
curl -s -f --connect-timeout 2 --max-time 5 \
  -X POST "${CLAUDE_PAUSER_HA_URL:-http://homeassistant.local:8123}/api/services/media_player/media_play" \
  -H "Authorization: Bearer $CLAUDE_PAUSER_HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"entity_id\": \"${CLAUDE_PAUSER_HA_ENTITY:-media_player.apple_tv}\"}" \
  >/dev/null 2>&1 || true  # Fail silently - probably not at home

exit 0
