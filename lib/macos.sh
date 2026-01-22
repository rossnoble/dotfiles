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

set_hot_corners() {
  # Set Mission Control to bottom-left hot corner
  defaults write com.apple.dock wvous-bl-corner -int 2
  defaults write com.apple.dock wvous-bl-modifier -int 0 # No hot key

  # Set Desktop to bottom-right hot corner
  defaults write com.apple.dock wvous-br-corner -int 4
  defaults write com.apple.dock wvous-br-modifier -int 0 # No hot key

  # Set lock screen to top-right and Cmd key
  defaults write com.apple.dock wvous-tr-corner -int 13
  defaults write com.apple.dock wvous-tr-modifier -int 1048576

  # # Restart Dock to apply changes
  killall Dock
}
