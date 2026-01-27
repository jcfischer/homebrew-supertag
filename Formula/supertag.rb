class Supertag < Formula
  desc "CLI for Tana integration: query, create, sync, and MCP server"
  homepage "https://github.com/jcfischer/supertag-cli"
  version "1.13.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/jcfischer/supertag-cli/releases/download/v#{version}/supertag-cli-macos-arm64.zip"
      sha256 "490571f8d777662b5e5ae3dca96a12675ee50d7932612ec0ab36cf5cf5225ac2"
    end
    on_intel do
      url "https://github.com/jcfischer/supertag-cli/releases/download/v#{version}/supertag-cli-macos-x64.zip"
      sha256 "9d7216e0cc1dc93f142ccac2d91ac981c81fcb115c69228c0cf385e15369fc5e"
    end
  end

  def install
    bin.install "supertag"
    bin.install "supertag-mcp"
    bin.install "supertag-export"
    bin.install "supertag-lite"
  end

  def caveats
    <<~EOS
      Supertag CLI has been installed with 4 binaries:
        - supertag       Main CLI for queries, sync, and node creation
        - supertag-mcp   MCP server for AI tool integration (Claude, etc.)
        - supertag-export Browser automation for workspace exports
        - supertag-lite  Lightweight CLI for Raycast integration

      To get started:
        1. Add a workspace with your Tana API token:
           supertag workspaces add main --token <your-api-token>

        2. Sync your Tana export:
           supertag sync

        3. Query your data:
           supertag search "your query"

      For MCP server integration with Claude/AI tools:
        supertag-mcp --help

      Documentation: https://github.com/jcfischer/supertag-cli
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supertag --version")
    assert_match "supertag-mcp", shell_output("#{bin}/supertag-mcp --help 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/supertag-lite --version")
  end
end
