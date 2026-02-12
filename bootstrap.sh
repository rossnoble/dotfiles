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

# Add dotfiles CLI to PATH via ~/.zshrc.local
ZSHRC_LOCAL="$HOME/.zshrc.local"
PATH_EXPORT='export PATH="$HOME/Code/dotfiles/bin:$PATH"'

if [ -f "$ZSHRC_LOCAL" ] && grep -q 'dotfiles/bin' "$ZSHRC_LOCAL"; then
  echo "✓ dotfiles CLI already in PATH"
else
  echo "Adding dotfiles CLI to PATH..."
  touch "$ZSHRC_LOCAL"
  echo "" >> "$ZSHRC_LOCAL"
  echo "# Add dotfiles CLI to PATH" >> "$ZSHRC_LOCAL"
  echo "$PATH_EXPORT" >> "$ZSHRC_LOCAL"
  echo "Added to $ZSHRC_LOCAL"
fi

echo ""
echo "✓ Bootstrap complete"
echo ""
echo "Next steps:"
echo "  source ~/.zshrc.local         # Reload shell config (or restart terminal)"
echo "  dotfiles dev install          # Set up developer environment"
echo "  dotfiles apps install         # Install GUI applications"
