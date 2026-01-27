# Homebrew Tap for Supertag CLI

This is the official [Homebrew](https://brew.sh) tap for [Supertag CLI](https://github.com/jcfischer/supertag-cli).

## Installation

```bash
brew tap jcfischer/supertag
brew install supertag
```

Or in one command:

```bash
brew install jcfischer/supertag/supertag
```

## What's Included

This formula installs 4 binaries:

| Binary | Purpose |
|--------|---------|
| `supertag` | Main CLI for queries, sync, and node creation |
| `supertag-mcp` | MCP server for AI tool integration |
| `supertag-export` | Browser automation for workspace exports |
| `supertag-lite` | Lightweight CLI for Raycast integration |

## Getting Started

1. Add a workspace with your Tana API token:
   ```bash
   supertag workspaces add main --token <your-api-token>
   ```

2. Sync your Tana export:
   ```bash
   supertag sync
   ```

3. Query your data:
   ```bash
   supertag search "your query"
   ```

## Updates

```bash
brew update
brew upgrade supertag
```

## Documentation

- [Supertag CLI Repository](https://github.com/jcfischer/supertag-cli)
- [User Guide](https://github.com/jcfischer/supertag-cli/blob/main/USER-GUIDE.md)
