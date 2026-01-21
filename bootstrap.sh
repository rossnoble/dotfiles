#!/bin/bash
# bootstrap.sh - Run this first on a fresh machine

set -e

echo "Bootstrapping new machine..."

# Install Homebrew if needed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add to PATH for Apple Silicon
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  echo "Homebrew already installed"
fi

# Install jq for JSON parsing (required by bin/dotfiles)
if ! command -v jq &> /dev/null; then
  echo "Installing jq..."
  brew install jq
else
  echo "jq already installed"
fi

echo ""
echo "Bootstrap complete!"
echo ""
echo "Next steps:"
echo "  ./bin/dotfiles install    # Interactive app installation"
echo "  ./install.sh              # Configure dotfiles"
