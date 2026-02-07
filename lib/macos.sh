# Common hot corner values:
# 1 = Disabled
# 2 = Mission Control
# 3 = Application Windows
# 4 = Desktop
# 5 = Start Screen Saver
# 10 = Put Display to Sleep
# 11 = Launchpad
# 12 = Notification Center
# 13 = Lock Screen

# Corner identifiers:
# tl = top-left
# tr = top-right
# bl = bottom-left
# br = bottom-right
configure_dock_settings() {
  # HOT CORNERS
  echo "━━━ Hot corners ━━━"

  # Set Mission Control to bottom-left hot corner
  defaults write com.apple.dock wvous-bl-corner -int 2 # Mission control
  defaults write com.apple.dock wvous-bl-modifier -int 0 # No hot key
  echo "✓ Assigned bottom-left hot corner to Mission Control"

  # Set Desktop to bottom-right hot corner
  defaults write com.apple.dock wvous-br-corner -int 4 # Desktop
  defaults write com.apple.dock wvous-br-modifier -int 0 # No hot key
  echo "✓ Assigned bottom-right hot corner to Show Desktop"

  # Set Lock Screen to top-right and Cmd key
  defaults write com.apple.dock wvous-tr-corner -int 13 # Lock screen
  defaults write com.apple.dock wvous-tr-modifier -int 1048576 # Hold Cmd key
  echo "✓ Assigned bottom-right hot corner to Lock Screen (with Cmd key)"
  echo ""

  # DOCK DISPLAY CONFIGS
  echo "━━━ Dock display ━━━"

  # Enable auto-hide of dock
  defaults write com.apple.dock autohide -bool true
  # Speed up animation duration
  defaults write com.apple.dock autohide-time-modifier -float 0.75
  # No delay before showing dock
  defaults write com.apple.dock autohide-delay -float 0
  echo "✓ Enabled dock auto-hide with fast animations"

  # Restart Dock to apply changes
  killall Dock
  echo ""
  echo "Restarted dock to apply changes"
  echo ""
}

configure_keyboard_settings() {
  echo "━━━ Keyboard settings ━━━"

  # Key repeat rate (1 = fastest, 2 = fast GUI limit, default is 6)
  defaults write NSGlobalDomain KeyRepeat -int 2
  echo "✓ Set key repeat to fastest GUI limit"

  # Delay until repeat (10 = shortest, 15 = fast GUI limit, default is 68)
  defaults write NSGlobalDomain InitialKeyRepeat -int 15
  echo "✓ Set key repeat delay to fastest GUI limit"

  echo ""
  echo "⚠️ You will need to log out/in again for keyboard settings to take effect"
  echo ""
}

configure_screenshot_settings() {
  echo "━━━ Screenshot settings ━━━"

  # Create screenshots directory if it doesn't exist
  local screenshot_dir="$HOME/Screenshots"
  if [ ! -d "$screenshot_dir" ]; then
    mkdir -p "$screenshot_dir"
    echo "✓ Created $screenshot_dir"
  else
    echo "✓ Screenshot directory already exists at $screenshot_dir"
  fi

  # Set screenshot save location
  defaults write com.apple.screencapture location "$screenshot_dir"
  echo "✓ Set screenshot save location to $screenshot_dir"

  # Disable screenshot preview thumbnail for faster saves
  defaults write com.apple.screencapture show-thumbnail -bool false
  echo "✓ Disabled screenshot preview thumbnail"

  # Restart SystemUIServer to apply changes
  killall SystemUIServer
  echo ""
  echo "Restarted SystemUIServer to apply changes"
  echo ""
}
