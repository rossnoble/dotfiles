# Enables color highlighting
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# MySQL socket location
export MYSQL_SOCKET='/tmp/mysql.sock'

# Postgres
export PGHOST=localhost
#alias pg-start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pgstart="postgres -D /usr/local/var/postgres"
alias pgstop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'

# added by Anaconda 1.9.2 installer
export PATH="//anaconda/bin:$PATH"

# Enables color for iTerm
export TERM=xterm-color

# Set the default editor to vim
export EDITOR=vim

# Sets up the prompt color (currently a green similar to linux terminal)
source "/usr/local/etc/bash_completion.d/git-completion.bash"
source "/usr/local/etc/bash_completion.d/git-prompt.sh"
source "/usr/local/etc/bash_completion.d/password-store"

# Show user@server path (git branch)
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]$(__git_ps1 " (%s)")$ '

# Config file shortcuts
alias ebash='vim ~/.bash_profile'
alias sobash='source ~/.bash_profile'
alias vimrc='vim ~/.vimrc'
alias gitconfig='vim ~/.gitconfig'

# Chruby scripts and config
# http://zaiste.net/2013/04/towards_simplicity_from_rbenv_to_chruby/
source '/usr/local/share/chruby/chruby.sh'
source '/usr/local/share/chruby/auto.sh'
source '/usr/local/share/gem_home/gem_home.sh'

# Default ruby version
chruby ruby-2.0

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Personal locations
alias mylogins='cd ~/.logins'
alias hosts='sudo vim /etc/hosts'
alias code='cd ~/Code'
alias reel='cd ~/Code/personal/reelonrails'
alias pjm='cd ~/Code/personal/pjmsl'
alias softball='cd ~/Code/personal/pjmsl-rails'
alias mastermind='cd ~/Code/personal/mastermind'
alias lists='cd ~/Lists'
alias songs='vim ~/Lists/songs_to_cover.mdown'
alias movies='vim ~/Lists/movies.mdown'
alias reviews='vim ~/Lists/movie_reviews.mdown'
alias books='vim ~/Lists/books.mdown'

# PasswordBox aliases
alias pbox='cd ~/Code/work/pbox'
alias lckr='cd ~/Code/work/pbox/lckr'
alias road='cd ~/Code/work/pbox/road-house'
alias corp='cd ~/Code/work/pbox/corporate'
alias sasspbox='bundle exec sass --watch --scss --compass app/stylesheets:public/stylesheets'

# Remote staging servers
alias pboxstaging1='ssh deploy@qa-staging1.it.pboxlabs.com'
alias pboxstaging2='ssh deploy@qa-staging2.it.pboxlabs.com'
alias pboxstaging3='ssh deploy@qa-staging3.it.pboxlabs.com'

# Development
alias ztest='zeus test'
alias rtest='rake test TEST='
alias jtest='jasmine-headless-webkit -c --no-full-run'
alias routes='rake routes > routes.txt && mate routes.txt'
alias zroutes='zeus rake routes > routes.txt && mate routes.txt'

# Other
alias iphonesim='open /Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app'
