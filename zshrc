# CORE ZSH CONFIGS
# -----------------
#
set shell=/bin/bash

export DOTFILES_DIR=~/Code/dotfiles

set LANG="en_US.UTF-8"

# Previous prompt style for reference
# PROMPT="%B%F{78}%1~%f:%F{39}$(git_branch)%F{169}$%b %f"

# https://gist.github.com/reinvanoyen/05bcfe95ca9cb5041a4eafd29309ff29
function parse_git_branch() {
   git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/(\1)/p'
}

COLOR_DEF=$'%f'
COLOR_SYM=$'%F{169}'
COLOR_USR=$'%F{243}'
COLOR_DIR=$'%F{197}'
COLOR_GIT=$'%F{39}'

setopt PROMPT_SUBST
export PROMPT='${COLOR_DIR}%~ ${COLOR_GIT}$(parse_git_branch)${COLOR_SYM} $ ${COLOR_DEF}'

# Color highlighting for terminal
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagacad

# Set the default editor to vim
export EDITOR=vim

export TERM="xterm-256color"

# Add homebrew to path. Will not work on M1 which requires /usr/local instead.
# https://nhancv.medium.com/macbook-pro-m1-homebrew-install-error-7170e4816894
# export PATH="/opt/homebrew/bin:$PATH"

# Local binaries
export PATH="/usr/local/sbin:$PATH"

# z browzing utility
Z_PATH=/opt/homebrew/etc/profile.d/z.sh
[ -r $Z_PATH ] && source "$Z_PATH"

# Git tab completion
autoload -Uz compinit && compinit

# Init rbenv automatically
# eval "$(rbenv init - zsh)"

# UTILITY ALIASES
# -----------------

# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls='ls -lAh'
# alias find='gfind'

# Shortcuts to dotfiles
# This alias used to be called `dotfiles` but that would
# conflict with the dotfiles CLI tool of the same name
alias dots="cd ${DOTFILES_DIR}"
alias vimrc='vim ~/.vimrc'
alias zshrc='vim ~/.zshrc'
alias zshrc_local='vim ~/.zshrc.local'
alias sozshrc='source ~/.zshrc'
alias sozshrc_local='source ~/.zshrc.local'
alias tconf='vim ~/.tmux.conf'
alias sotconf='tmux source ~/.tmux.conf'
alias ghostconf='vim ~/.config/ghostty/config'

alias pryrc='vim ~/.pryrc'
alias agignore='vim ~/.agignore'
alias gitconfig='vim ~/.gitconfig'
alias cocsettings="vim ${DOTFILES_DIR}/vim/coc-settings.json"
alias hosts='sudo vim /etc/hosts'
alias python='python3'
alias pip='pip3'
alias vim='nvim'

# MacOS
alias show_hidden='defaults write com.apple.finder AppleShowAllFiles YES'
alias hide_hidden='defaults write com.apple.finder AppleShowAllFiles NO'
alias enable_sleep='sudo pmset disablesleep 0'
alias disable_sleep='sudo pmset disablesleep 1'

# Silver searcher
alias ag='ag --path-to-ignore ~/.agignore'

# Postgres
alias pgstart="brew services start postgresql@17"
alias pgstop="brew services stop postgresql@17"
alias pgrestart="brew services restart postgresql@17"

# Tmux
alias tmux="tmux -2"
alias tat='tmux new-session -As "$(basename "$PWD" | tr . -)"'
alias tlist="tmux list-sessions"

# Destroy a tmux session by name
function tkill() {
  tmux kill-session -t ${1}
  echo "Killed session ${1}"
}

# Python static files server on the given port
function server() {
  local port="${1:-1234}"
  open "http://localhost:${port}/"
  python -m SimpleHTTPServer "${port}"
}

function start_ssh_agent() {
  eval "$(ssh-agent -s)"
  ssh-add -K ~/.ssh/id_rsa
}

function flush_dns_cache() {
  sudo dscacheutil -flushcache
  sudo killall -HUP mDNSResponder
}

# Parse pwd name and pass to tmuxp config to support dynamic session names:
#
#   session_name: ${SESSION_NAME}
#
function tp() {
  SESSION_NAME=$(basename "$PWD") tmuxp load "$@"
}

# Creates a new git worktree alongside the current directory.
#
# Usage:
#   On main/master: new_worktree <branch-name>
#   On feature branch: new_worktree [new-branch-name]
#
# Examples:
#   If inside `~/Code/project-a` on main:
#     new_worktree claude/my-feature
#     -> Creates ~/Code/project-a-my-feature with branch claude/my-feature
#
#   If inside `~/Code/project-a` on branch `feature-x`:
#     new_worktree
#     -> Creates ~/Code/project-a-feature-x using existing branch
#
#   If inside `~/Code/project-a` on branch `feature-x`:
#     new_worktree new-branch
#     -> Creates ~/Code/project-a-new-branch with new branch based on feature-x
#
function new_worktree() {
  local project="${PWD##*/}"
  local branch
  local base_branch
  local current_branch
  local tree_name
  local full_path
  local on_main_branch=false

  # Detect main or master branch
  if git show-ref --verify --quiet "refs/heads/main"; then
    base_branch="main"
  elif git show-ref --verify --quiet "refs/heads/master"; then
    base_branch="master"
  else
    echo "Error: Could not find main or master branch"
    return 1
  fi

  # Get current branch
  current_branch=$(git branch --show-current)

  # Check if on main/master
  if [[ "$current_branch" == "main" ]] || [[ "$current_branch" == "master" ]]; then
    on_main_branch=true
  fi

  # Determine branch name based on context
  if [[ "$on_main_branch" == true ]]; then
    # On main/master: branch argument is required
    if [[ -z "$1" ]]; then
      echo "Error: Branch name is required when on $current_branch"
      echo "Usage: new_worktree <branch-name>"
      return 1
    fi
    branch="$1"
  else
    # On feature branch: use current branch or provided argument
    if [[ -z "$1" ]]; then
      branch="$current_branch"
    else
      branch="$1"
      # When creating a new branch from a feature branch, use current branch as base
      base_branch="$current_branch"
    fi
  fi

  # Generate tree name by stripping first prefix level (e.g., claude/my-feature -> my-feature)
  tree_name="${branch#*/}"

  # Build full path
  full_path="../${project}-${tree_name}"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    # Branch exists: create worktree using existing branch
    if git worktree add "$full_path" "$branch"; then
      echo "Worktree ready at $full_path (using existing branch $branch)"
    else
      echo "Error: Failed to create worktree"
      return 1
    fi
  else
    # Branch doesn't exist: create new branch from base
    if git worktree add -b "$branch" "$full_path" "$base_branch"; then
      echo "Worktree ready at $full_path (created new branch $branch from $base_branch)"
    else
      echo "Error: Failed to create worktree"
      return 1
    fi
  fi

  # Any other setup steps
  # cd "$full_path"
  # e.g. yarn install
}

# LOCAL ZSH CONFIGS
# -----------------

# Load local zshrc configurationt file.
#
# Configs and variable unique to the current machine should be added
# there instead of here to keep the repository state clear.
#
# .zshrc.local is in the .gitignore
#
export ZSHRC_LOCAL_PATH=~/.zshrc.local
[ -r $ZSHRC_LOCAL_PATH ] && source $ZSHRC_LOCAL_PATH
