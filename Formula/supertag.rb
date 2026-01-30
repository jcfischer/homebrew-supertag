class Supertag < Formula
  desc "CLI for Tana integration: query, create, sync, and MCP server"
  homepage "https://github.com/jcfischer/supertag-cli"
  version "2.0.1"
  license "MIT"

  # Bun is required for supertag-export (Playwright browser automation)
  depends_on "oven-sh/bun/bun"

  on_macos do
    on_arm do
      url "https://github.com/jcfischer/supertag-cli/releases/download/v#{version}/supertag-cli-macos-arm64.zip"
      sha256 "e240d564e1c6dd559f62f1cce6fbbbf254c968d9c5b7f7d894e6d15ac282f592"
    end
    on_intel do
      url "https://github.com/jcfischer/supertag-cli/releases/download/v#{version}/supertag-cli-macos-x64.zip"
      sha256 "59069009726e25f3813404d6e870032e33813efb65f43dccbe77ca9eef811a59"
    end
  end

  def install
    # Install all 4 binaries
    bin.install "supertag"
    bin.install "supertag-mcp"
    bin.install "supertag-export"
    bin.install "supertag-lite"

    # Install helper scripts and docs
    pkgshare.install "scripts" if File.directory?("scripts")
    pkgshare.install "launchd" if File.directory?("launchd")
    doc.install "docs" if File.directory?("docs")
  end

  def post_install
    # Install Playwright globally for supertag-export browser automation
    ohai "Installing Playwright for browser automation..."
    system "bun", "add", "-g", "playwright"

    # Install Chromium browser
    ohai "Installing Chromium browser (this may take a minute)..."
    system "bunx", "playwright", "install", "chromium"
  end

  def caveats
    <<~EOS
      Supertag CLI has been installed with 4 binaries:
        - supertag        Main CLI for queries, sync, and node creation
        - supertag-mcp    MCP server for AI tool integration (Claude, etc.)
        - supertag-export Browser automation for workspace exports
        - supertag-lite   Lightweight CLI for Raycast integration

      Playwright and Chromium have been installed for browser automation.

      #{node_path_instructions}

      To get started:
        1. Login to Tana (for automated exports):
           supertag-export login

        2. Discover your workspaces:
           supertag-export discover

        3. Add a workspace with your Tana API token:
           supertag workspaces add main --token <your-api-token>

        4. Sync your Tana export:
           supertag sync

        5. Query your data:
           supertag search "your query"

      For MCP server integration with Claude/AI tools:
        supertag-mcp --help

      Helper scripts are installed at:
        #{opt_pkgshare}/scripts/

      Documentation: https://github.com/jcfischer/supertag-cli
    EOS
  end

  def node_path_instructions
    shell = ENV["SHELL"] || "/bin/bash"
    bun_global = "#{ENV["HOME"]}/.bun/install/global/node_modules"

    case File.basename(shell)
    when "zsh"
      <<~SHELL
        Add this to your ~/.zshrc for Playwright support:
          export NODE_PATH="#{bun_global}:$NODE_PATH"
      SHELL
    when "fish"
      <<~SHELL
        Add this to your ~/.config/fish/config.fish for Playwright support:
          set -gx NODE_PATH #{bun_global} $NODE_PATH
      SHELL
    else
      <<~SHELL
        Add this to your shell config for Playwright support:
          export NODE_PATH="#{bun_global}:$NODE_PATH"
      SHELL
    end
  end

  # Optional: Homebrew service for the webhook server
  service do
    run [opt_bin/"supertag", "server", "start", "--foreground"]
    keep_alive true
    log_path var/"log/supertag.log"
    error_log_path var/"log/supertag.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supertag --version")
    assert_match version.to_s, shell_output("#{bin}/supertag-lite --version")
    # MCP server exits with code 1 when run without proper setup, but shows help
    assert_match "supertag", shell_output("#{bin}/supertag-mcp --help 2>&1", 1)
  end
end
