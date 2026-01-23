# Common hot corner values:
# 1 = Disabled
# 2 = Mission Control
# 3 = Application Windows
# 4 = Desktop
# 5 = Start Screen Saver
# 10 = Put Display to Sleep
# 11 = Launchpad
# 12 = Notification Center

# Corner identifiers:
# tl = top-left
# tr = top-right
# bl = bottom-left
# br = bottom-right
configure_dock_settings() {
  # ===========
  # HOT CORNERS
  # ===========

  # Set Mission Control to bottom-left hot corner
  defaults write com.apple.dock wvous-bl-corner -int 2 # Mission control
  defaults write com.apple.dock wvous-bl-modifier -int 0 # No hot key

  # Set Desktop to bottom-right hot corner
  defaults write com.apple.dock wvous-br-corner -int 4 # Desktop
  defaults write com.apple.dock wvous-br-modifier -int 0 # No hot key

  # Set lock screen to top-right and Cmd key
  defaults write com.apple.dock wvous-tr-corner -int 13 # Lock screen
  defaults write com.apple.dock wvous-tr-modifier -int 1048576 # Hold Cmd key

  # ====================
  # DOCK DISPLAY CONFIGS
  # ====================

  # Enable auto-hide of dock
  defaults write com.apple.dock autohide -bool true
  # Speed up animation duration
  defaults write com.apple.dock autohide-time-modifier -float 0.75
  # No delay before showing dock
  defaults write com.apple.dock autohide-delay -float 0

  # Restart Dock to apply changes
  killall Dock
}
