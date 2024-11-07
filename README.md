# Ask Claude

A fish shell function that leverages Claude AI to generate contextually accurate terminal commands for macOS and Linux systems. Simply describe what you want to do, and get the correct command for your specific OS and version.

## Features

- Generates commands specific to your OS (macOS/Linux) and version
- Provides correct syntax for fish shell
- Detects system details automatically (e.g., macOS version, Linux distribution)
- Interactive command placement in terminal
- Built-in error handling and validation
- Safe execution (commands are placed on prompt for review)

## Prerequisites

- [fish shell](https://fishshell.com/) installed and configured
- An Anthropic API key (Get one from [Anthropic Console](https://console.anthropic.com/settings/keys))
- `curl` and `jq` installed on your system

## Installation

1. Add the following environment variables to your `~/.config/fish/config.fish`:
```fish
set -gx CLAUDE_MODEL "claude-3-sonnet-20240229"
set -gx CLAUDE_API_KEY "sk-ant-YOUR-API-KEY"
```

2. Copy the `ask-claude.fish` function to your fish functions directory:
```fish
mkdir -p ~/.config/fish/functions
cp ask-claude.fish ~/.config/fish/functions/
```

## Usage

Simply describe the command you need:
```fish
ask-claude "flush DNS cache"
ask-claude "create a new directory called projects"
ask-claude "find all PDF files modified in the last 24 hours"
```

The function will:
1. Generate the appropriate command for your system
2. Place it on your command line
3. Let you review and edit before execution

## Examples

macOS example:
```fish
> ask-claude "restart DNS"
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

Linux (Debian) example:
```fish
> ask-claude "install nginx"
sudo apt install nginx
```

## How It Works

The function:
1. Detects your operating system and version
   - On macOS: Identifies version (e.g., Sonoma, Ventura) and specific build
   - On Linux: Identifies distribution and version
2. Gets shell environment details
3. Sends a structured prompt to Claude AI
4. Receives and validates the response
5. Places the command on your terminal prompt for review

## System Support

### Currently Supported
- macOS (all recent versions including Sonoma, Ventura, Monterey, Big Sur)
- Linux (Debian-based distributions)
- Fish shell

### Planned Support
- Bash/Zsh shells
- Windows (PowerShell)
- More Linux distributions

## Known Limitations

- Works only with fish shell currently
- Requires environment variables to be set
- Commands are OS-specific and may not work across different systems
- API key required from Anthropic

## Contributing

Contributions are welcome! Here's how you can help:

- Submit feature requests
- Report bugs
- Add support for more shells
- Improve documentation
- Add tests
- Add support for more Linux distributions
- Improve error handling

### Development Setup

1. Fork the repository
2. Clone your fork
3. Make your changes
4. Submit a pull request

## Security Notes

- API key is stored in fish environment variables
- Commands are reviewed before execution
- No automatic command execution
- All commands are displayed for user review

## License

[MIT License](LICENSE)

## Acknowledgments

- [Anthropic](https://www.anthropic.com/) for the Claude AI API
- [Fish Shell](https://fishshell.com/) community
- All contributors to this project

## Support

If you encounter any issues or have questions:
1. Check the [Issues](../../issues) page
2. Create a new issue if yours isn't already listed
3. Provide detailed information about your system and the problem

## Changelog

### v1.0.0 (Initial Release)
- Basic command generation
- macOS and Linux support
- Fish shell integration
- System version detection
- Interactive command placement