#!/bin/bash
# lib/utils.sh - Shared utility functions for dotfiles scripts

prompt_yes_no() {
  local prompt="$1"
  local response

  while true; do
    read -p "$prompt [y/n]: " response < /dev/tty
    case $response in
      [Yy]* ) return 0 ;;
      [Nn]* ) return 1 ;;
      * ) echo "Please answer y or n." ;;
    esac
  done
}

# Check for required dependencies
check_dependencies() {
  if ! command -v brew &> /dev/null; then
    echo "Error: Homebrew is required but not installed."
    echo "Run ./bootstrap.sh first"
    exit 1
  fi

  if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Run ./bootstrap.sh first, or: brew install jq"
    exit 1
  fi
}
