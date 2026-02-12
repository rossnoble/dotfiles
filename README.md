# Dotfiles

## Installation

This is an install script for configuring fresh machines.

1. Clone or download the repo.
2. Run the init script at `./bootstrap.sh`

> [!NOTE]
> You'll need to update the dotfiles git url in `.git/config` to
> `git@github.com:rossnoble/dotfiles.git` if want to push to this repo
> from the new machine.

### CLI PATH

The bootstrap script adds `~/Code/dotfiles/bin` to the PATH via `~/.zshrc.local`.
The path will need to be changed if this repository is in a different location or
to a different profile file if not using zshrc.

```bash
# In ~/.zshrc.local
export PATH="$HOME/your/custom/path/dotfiles/bin:$PATH"
```

Once in PATH, you can run the `dotfiles` command entry point without the `./bin/` prefix:

```bash
dotfiles apps install
dotfiles dev install
dotfiles macos run-all
```

### Quick Start

Clone and run the bootstrap script.

> [!IMPORTANT]
> MacOS will prompt you to install xcode when you try to use git. So you will
> actually have to run this twice.

```
git clone https://github.com/rossnoble/dotfiles.git && \
cd dotfiles && \
./bootstrap.sh
```

Install applications, dev tools and configure OS
```bash
./bin/dotfiles apps install     # Interactive GUI app installation
./bin/dotfiles dev install      # Interactive developer environment setup
./bin/dotfiles macos run-all    # Configure macOS system preferences
```

## CLI Tool

### Domains

There are three domains available under the `dotfiles` namespace:
- `dotfiles apps`  -> install macOS GUI applications via Homebrew casks.
- `dotfiles dev`   -> install developer tools and link dotfiles
- `dotfiles macos` -> configure MacOS system settings

### Config files

These tools read the configs and prompt for installation.

- Edit `config/apps.json` to add applications. Find cask names at https://formulae.brew.sh/cask/
- Edit `config/dev-tools.json` to customize tools and symlinks.

### Special notes

#### Vim

The `dotfiles dev install` command installs vim-plug which then needs to be
called inside Neovim with `:PlugInstall` to install the plugins in `nvim/init.vim`.

#### SSH and Githu

Run `dotfiles dev ssh` to generate an SSH key and configure it for GitHub.
The public key is automatically copied to your clipboard. You will need to
manually enter this on Github or other repository hosts.

Add key to GitHub: https://github.com/settings/keys
