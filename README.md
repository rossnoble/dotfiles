# Dotfiles

## Install script

This is an install script for configuring fresh machines.

1. Clone or download the repo.
2. Run the init script at `./bootstrap.sh`
3. Run `./bin/dotfiles apps install` to install GUI apps
4. Run `./bin/dotfiles dev install` to install CLI tools and apply system preferences

```
git clone https://github.com/rossnoble/dotfiles.git
cd dotfiles
```

NOTE: You'll need to update the dotfiles git url in `.git/config` to
`git@github.com:rossnoble/dotfiles.git` if want to push to this repo
from the new machine.

### Quick Start

```bash
./bootstrap.sh                  # Install Homebrew and jq (run first)
./bin/dotfiles apps install     # Interactive GUI app installation
./bin/dotfiles dev install      # Interactive developer environment setup
```

## VIM

Run `./bin/dotfiles dev install` to set up vim-plug, then inside Neovim run `:PlugInstall` to install plugins.

## SSH

Run `./bin/dotfiles dev ssh` to generate an SSH key and configure it for GitHub. The public key is automatically copied to your clipboard.

Add key to GitHub: https://github.com/settings/keys

## CLI Tools

A unified CLI tool for setting up a fresh Mac:

## Application Installation (`dotfiles apps`)

Interactively install macOS GUI applications via Homebrew casks.

```bash
./bin/dotfiles apps install    # Interactive app installation
./bin/dotfiles apps list       # Show available applications
./bin/dotfiles apps status     # Show installation status
```

Edit `config/apps.json` to add applications. Find cask names at https://formulae.brew.sh/cask/

## Developer Environment (`dotfiles dev`)

Interactively set up developer tools, environments, and dotfiles.

```bash
./bin/dotfiles dev install     # Interactive developer setup
./bin/dotfiles dev list        # Show available tools
./bin/dotfiles dev status      # Show installation status
```

### What it sets up

1. **System Prerequisites**: XCode CLI Tools, Rosetta 2
2. **CLI Tools**: git, nvim, tmux, z, rg, deno (via Homebrew)
3. **Node Environment**: nvm, Node, corepack/yarn
4. **SSH**: Generate key and configure for GitHub
5. **Symlinks**: Link dotfiles to home directory
6. **Post-install**: vim-plug for Neovim

Edit `config/dev-tools.json` to customize tools and symlinks.
