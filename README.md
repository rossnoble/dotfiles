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
7. Configure SSH keys for Github: https://jdblischak.github.io/2014-09-18-chicago/novice/git/05-sshkeys.html

## Developer

1. Run `PlugInstall` to install vim plugins

Generate a public key (this could be automated):
```
mkdir .ssh
cd .ssh
ssh-keygen -o -t rsa -C "rnoble@fastmail.com"
cat ~/.ssh/id_rsa.pub
```

Start the ssh-agent (manually);
```
eval `ssh-agent -s`
ssh-add ~/.ssh/id_rsa
```
