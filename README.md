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

1. Change Caps Lock key to Control
2. Update Cmd + Spacebar to open Alfred
3. Update iTerm full screen mode (General > Window > Native full screen windows)
4. Configure SSH keys for Github: https://jdblischak.github.io/2014-09-18-chicago/novice/git/05-sshkeys.html

This could be automated:

```
mkdir .ssh
cd .ssh
ssh-keygen -o -t rsa -C "rnoble@fastmail.com"
cat ~/.ssh/id_rsa.pub
```
