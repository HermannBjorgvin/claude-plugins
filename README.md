# Claude Pauser

Your TV keeps playing while you stare at a permission prompt? Not anymore.

Claude Pauser automatically pauses your Apple TV when Claude stops working and resumes when you start typing. It's a productivity plugin that respects your binge-watching.

## Features

- **Auto pause/resume** - Pauses Apple TV on permission prompts, resumes when Claude finishes
- **Easy toggle** - `/claude-pauser:toggle` command to enable/disable
- **Graceful failure** - Silently fails if Home Assistant is unreachable (you're not at home)
- **Debouncing** - Prevents rapid pause/resume toggling

## Prerequisites

- [Home Assistant](https://www.home-assistant.io/) with the Apple TV integration configured
- A long-lived access token from Home Assistant
- Your Apple TV entity ID (e.g., `media_player.living_room_apple_tv`)

## Installation

### Local Installation

```bash
# Clone the repository
git clone https://github.com/hermannbjorgvin/claude-pauser.git

# Load plugin during development
claude --plugin-dir ./claude-pauser

# Or install it permanently
/plugin install ./claude-pauser
```

### Marketplace Installation

```bash
/plugin marketplace add https://github.com/hermannbjorgvin/claude-pauser
/plugin install claude-pauser@hermannbjorgvin
```

## Configuration

Add these environment variables to your Claude Code settings file (`~/.claude/settings.json`):

```json
{
  "env": {
    "CLAUDE_PAUSER_HA_URL": "http://homeassistant.local:8123",
    "CLAUDE_PAUSER_HA_TOKEN": "your-long-lived-access-token",
    "CLAUDE_PAUSER_HA_ENTITY": "media_player.living_room_apple_tv"
  }
}
```

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_PAUSER_HA_URL` | Home Assistant URL | `http://homeassistant.local:8123` |
| `CLAUDE_PAUSER_HA_TOKEN` | Long-lived access token | (required) |
| `CLAUDE_PAUSER_HA_ENTITY` | Apple TV entity ID | `media_player.apple_tv` |

**Long-Lived Access Token:** Create one in Home Assistant: Profile → Long-Lived Access Tokens

**Apple TV Entity ID:** Find it in Home Assistant: Settings → Devices → Entities → search "apple tv"

## Usage

### Enable/Disable

Toggle the plugin on or off:

```
/claude-pauser:toggle
```

### Check Status

View current status and configuration:

```
/claude-pauser:status
```

## How It Works

| Event | Action | Why |
|-------|--------|-----|
| **UserPromptSubmit** | ▶️ Resume | You sent a message, Claude is working |
| **PostToolUse** | ▶️ Resume | Tool completed, Claude is working |
| **PermissionRequest** | ⏸️ Pause | Claude needs your attention |
| **Stop** | ⏸️ Pause | Claude finished, your turn |

The plugin uses a state file at `~/.local/state/claude-pauser/enabled` to track whether it's enabled.

## Troubleshooting

### Plugin not working

1. Check status: `/claude-pauser:status`
2. Verify `CLAUDE_PAUSER_HA_TOKEN` is set correctly in `~/.claude/settings.json`
3. Ensure Home Assistant is reachable
4. Restart Claude Code after installing or modifying the plugin

### Apple TV not responding

1. Verify the entity ID is correct in Home Assistant
2. Check that the Apple TV integration is working in Home Assistant
3. Try controlling the Apple TV directly from Home Assistant first

## License

MIT
