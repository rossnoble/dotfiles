# Dotfiles

## Install script

This is an install script for configuring fresh machines.

1. Clone or download the repo.
2. Run the init script at `./bootstrap.sh`
3. Run ./bin/apps to install GUI apps
4. Run ./bin/dev to install CLI tools and apply system preferences

```
$ git clone https://github.com/rossnoble/dotfiles.git
$ cd dotfiles
$ ./bootstrap.sh
```

NOTE: You'll need to update the dotfiles git url in `.git/config` to
`git@github.com:rossnoble/dotfiles.git` if want to push to this repo
from the new machine.

## Manual settings

These are things that are useful but hard to automate.

1. Configure keyboard settings
   - Set "Key repeat rate" to max Fast
   - Set "Delay until repeat" to max Short
   - Change Caps Lock key to "Control": Keyboard > Keyboard Shortcuts > Modifier Keys

## VIM

Run `./bin/dev install` to set up vim-plug, then inside Neovim run `:PlugInstall` to install plugins.

## SSH

Run `./bin/dev ssh` to generate an SSH key and configure it for GitHub. The public key is automatically copied to your clipboard.

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
