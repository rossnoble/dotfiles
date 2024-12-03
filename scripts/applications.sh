#!/bin/bash

if ! brew -v; then
  echo
  echo "Homebrew must be installed to download apps. Run ./homebrew.sh to install via curl"
  echo
  exit
fi

echo "Installing desktop applications...\n"

# Uncomment to install
apps=(
  # 1password
  # iterm2
  # sync
  # alfred
  # brave
  # telegram
  # notion
  # kaleidoscope
  # imageoptim
  # spotify
  # flux
  # krisp
  # obsidian
  # sequel-ace
  # zed
  # postman
  # nordvpn
  # expressvpn
  # karabiner-elements
  # figma
  # slack
  # the-clock
  # vlc
  # zoom
  # dropbox
  # soulver
  # visual-studio-code
  # textmate
  # certbot
  # bisq
  # macdown
  # affinity-photo
  # affinity-publisher
  # affinity-designer
)

for app in ${apps[@]}; do
  brew install --cask $app
  echo
  echo "Installed $app"
  echo
done
