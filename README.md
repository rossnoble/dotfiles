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

1. Run the `./scripts/developer.sh` script to install vim-plug for plugin management
2. Inside vim, run  `:PlugInstall` to install the vim plugins defined in `vimrc`

## SSH

Run the `./scripts/ssh.sh` script or manually below.

```
ssh-keygen -t ed25519 -C you@example.com
```

Start the ssh agent
```
eval "$(ssh-agent -s)"
```

Add the following to `~./ssh/config`
```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519" > ~/.ssh/config
```

Add key to Github:
https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account

```
pbcopy < ~/.ssh/id_ed25519.pub
```
