#!/bin/bash
# Check if Claude Pauser is configured and show setup instructions if not

# Skip check if token is already configured
if [ -n "$CLAUDE_PAUSER_HA_TOKEN" ]; then
    exit 0
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Claude Pauser: Not configured"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "  Add to ~/.claude/settings.json:"
echo
echo '  {'
echo '    "env": {'
echo '      "CLAUDE_PAUSER_HA_URL": "http://homeassistant.local:8123",'
echo '      "CLAUDE_PAUSER_HA_TOKEN": "your-long-lived-access-token",'
echo '      "CLAUDE_PAUSER_HA_ENTITY": "media_player.your_apple_tv"'
echo '    }'
echo '  }'
echo
echo "  Get your token: Home Assistant → Profile → Long-Lived Access Tokens"
echo "  Find entity ID: Home Assistant → Settings → Devices → Entities"
echo
echo "  Then restart Claude Code."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit 0
