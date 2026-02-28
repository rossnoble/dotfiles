#!/bin/bash
# bootstrap.sh - Run this first on a fresh machine

set -e

echo "Bootstrapping new machine..."
echo ""

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "✓ Homebrew already installed"
fi

# Install jq for JSON parsing (required by bin/apps and bin/dev)
if ! command -v jq &> /dev/null; then
  echo "Installing jq..."
  brew install jq
else
  echo "✓ jq already installed"
fi

# Add dotfiles CLI to PATH via ~/.zprofile
# Using .zprofile because it's loaded by login shells (Terminal.app)
# before .zshrc, so the PATH is available even before dotfiles are symlinked
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZPROFILE="$HOME/.zprofile"
PATH_EXPORT="export PATH=\"$SCRIPT_DIR/bin:\$PATH\""

if [ -f "$ZPROFILE" ] && grep -q 'dotfiles/bin' "$ZPROFILE"; then
  echo "✓ dotfiles CLI already in PATH"
else
  echo "Adding dotfiles CLI to PATH..."
  touch "$ZPROFILE"
  echo "" >> "$ZPROFILE"
  echo "# Add dotfiles CLI to PATH" >> "$ZPROFILE"
  echo "$PATH_EXPORT" >> "$ZPROFILE"
  echo "Added to $ZPROFILE"
fi

echo ""
echo "✓ Bootstrap complete"
echo ""
echo "Next steps:"
echo "  source ~/.zprofile            # Reload shell config (or restart terminal)"
echo "  dotfiles dev install          # Set up developer environment"
echo "  dotfiles apps install         # Install GUI applications"
