#!/bin/bash
# Check Claude Pauser status

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/claude-pauser/enabled"

echo "=== Claude Pauser Status ==="
echo

# Check enabled state
if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "1" ]; then
    echo "State: ENABLED"
else
    echo "State: DISABLED"
fi

# Check Home Assistant connectivity
echo -n "Home Assistant: "
if curl -s -f --connect-timeout 2 --max-time 3 \
    -H "Authorization: Bearer $CLAUDE_PAUSER_HA_TOKEN" \
    "${CLAUDE_PAUSER_HA_URL:-http://homeassistant.local:8123}/api/" >/dev/null 2>&1; then
    echo "REACHABLE"
else
    echo "UNREACHABLE (not at home?)"
fi

# Show configuration
echo
echo "Configuration:"
echo "  CLAUDE_PAUSER_HA_URL: ${CLAUDE_PAUSER_HA_URL:-http://homeassistant.local:8123}"
echo "  CLAUDE_PAUSER_HA_ENTITY: ${CLAUDE_PAUSER_HA_ENTITY:-media_player.apple_tv}"
if [ -n "$CLAUDE_PAUSER_HA_TOKEN" ]; then
    echo "  CLAUDE_PAUSER_HA_TOKEN: [set]"
else
    echo "  CLAUDE_PAUSER_HA_TOKEN: [not set]"
fi
