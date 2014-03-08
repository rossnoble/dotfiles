# Enables color highlighting
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# MySQL socket location
export MYSQL_SOCKET='/tmp/mysql.sock'

# Enables color for iTerm
export TERM=xterm-color

# Set the default editor to vim
export EDITOR=vim

# Sets up the prompt color (currently a green similar to linux terminal)
source "/usr/local/etc/bash_completion.d/git-completion.bash"
source "/usr/local/etc/bash_completion.d/git-prompt.sh"

# Show user@server path (git branch)
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$(__git_ps1 " (%s)")$ '

# Config file shortcuts
alias ebash='vim ~/.bash_profile'
alias sobash='source ~/.bash_profile'
alias vimrc='vim ~/.vimrc'
alias gitconfig='vim ~/.gitconfig'

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Chruby scripts and config
# http://zaiste.net/2013/04/towards_simplicity_from_rbenv_to_chruby/
source '/usr/local/share/chruby/chruby.sh'
source '/usr/local/share/chruby/auto.sh'
# Default ruby version
chruby ruby-1.9

# PasswordBox locations
alias lckr='cd ~/Code/pbox/lckr'
