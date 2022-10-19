echo "Installing desktop applications...\n"

# Uncomment to install
apps=(
  # 1password
  # iterm2
  # alfred
  # macdown
  # brave
  # kaleidoscope
  # imageoptim
  # flux
  # karabiner-elements
  # nordvpn
  # krisp
  # expressvpn
  # spotify
  # figma
  # slack
  # react-native-debugger
  # the-clock
  # notion
  # vlc
  # zoom
  # sync
  # dropbox
  # soulver
  # visual-studio-code
  # textmate
  # certbot
  # telegram
  # bisq
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
