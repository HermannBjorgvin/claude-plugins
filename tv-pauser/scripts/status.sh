#!/bin/bash
# Check TV Pauser status

STATE_FILE="${XDG_STATE_HOME:-$HOME/.local/state}/tv-pauser/enabled"

echo "=== TV Pauser Status ==="
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
    -H "Authorization: Bearer $TV_PAUSER_HA_TOKEN" \
    "${TV_PAUSER_HA_URL:-http://homeassistant.local:8123}/api/" >/dev/null 2>&1; then
    echo "REACHABLE"
else
    echo "UNREACHABLE (not at home?)"
fi

# Show configuration
echo
echo "Configuration:"
echo "  TV_PAUSER_HA_URL: ${TV_PAUSER_HA_URL:-http://homeassistant.local:8123}"
echo "  TV_PAUSER_HA_ENTITY: ${TV_PAUSER_HA_ENTITY:-media_player.apple_tv}"
if [ -n "$TV_PAUSER_HA_TOKEN" ]; then
    echo "  TV_PAUSER_HA_TOKEN: [set]"
else
    echo "  TV_PAUSER_HA_TOKEN: [not set]"
fi
