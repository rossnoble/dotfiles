# Dotfiles

## Install script

This is an install script for configuring fresh machines.

1. Create a `~/Code/` directory.
2. Clone or download the repo into that directory. 
3. Run the installation script.

```
$ git clone git@github.com:rossnoble/dotfiles.git
$ cd dotfiles
$ ./install.sh
```

## Manual settings

These are things that are useful but hard to automate.

1. Configure keyboard settings
   - Set "Key repeat rate" to max Fast
   - Set "Delay until repeat" to max Short
   - Change Caps Lock key to "Control": Keyboard > Keyboard Shortcuts > Modifier Keys
2. Configure display settings
   - Hide the dock: Desktop & Dock > Automatically show and hide the Dock
3. Set hot corners in MacOS
   - Bottom left: all windows
   - Bottom right: desktop
4. Update iTerm defaults
   - Full screen mode: General > Window > Deselect "Native full screen windows"
   - Increase font size: Profiles > Text > Bump to 14/15
5. Configure Alfred: search scopes
   - Update search scopes (details??)
   - Update Cmd + Spacebar to open Alfred
6. Configure Control Center
   - ...
7. Configure SSH keys for Github:
   - https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

## VIM

Run `./bin/dev install` to set up vim-plug, then inside Neovim run `:PlugInstall` to install plugins.

## SSH

Run `./bin/dev install` to generate an SSH key and configure it for GitHub. The public key is automatically copied to your clipboard.

Add key to GitHub: https://github.com/settings/keys

## CLI Tools

Two CLI tools for setting up a fresh Mac:

### Quick Start

```bash
./bootstrap.sh        # Install Homebrew and jq (run first)
./bin/apps install    # Interactive GUI app installation
./bin/dev install     # Interactive developer environment setup
```

## Application Installation (`bin/apps`)

Interactively install macOS GUI applications via Homebrew casks.

```bash
./bin/apps install    # Interactive app installation
./bin/apps list       # Show available applications
./bin/apps status     # Show installation status
```

Edit `config/apps.json` to add applications. Find cask names at https://formulae.brew.sh/cask/

## Developer Environment (`bin/dev`)

Interactively set up developer tools, environments, and dotfiles.

```bash
./bin/dev install     # Interactive developer setup
./bin/dev list        # Show available tools
./bin/dev status      # Show installation status
```

### What it sets up

1. **System Prerequisites**: XCode CLI Tools, Rosetta 2
2. **CLI Tools**: git, nvim, tmux, z, rg, deno (via Homebrew)
3. **Node Environment**: nvm, Node, corepack/yarn
4. **SSH**: Generate key and configure for GitHub
5. **Symlinks**: Link dotfiles to home directory
6. **Post-install**: vim-plug for Neovim

Edit `config/dev-tools.json` to customize tools and symlinks.
