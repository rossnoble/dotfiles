# lib/commands/macos.sh - macOS system configuration commands

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

macos_hot_corners() {
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

macos_keyboard() {
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

macos_screenshot() {
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

macos_dock_apps() {
  echo "━━━ Dock applications ━━━"
  echo

  # Check if dockutil is installed
  if ! command -v dockutil &> /dev/null; then
    echo "Error: dockutil is not installed"
    echo "Install it with: brew install dockutil"
    exit 1
  fi

  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed"
    echo "Install it with: brew install jq"
    exit 1
  fi

  # System apps to add first (not installable via brew)
  local system_apps=(
    "/System/Applications/System Settings.app"
    "/System/Applications/App Store.app"
    "/System/Applications/Utilities/Activity Monitor.app"
  )

  # Get the dotfiles directory (parent of lib/)
  local dotfiles_dir
  dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
  local config_file="$dotfiles_dir/config/apps.json"

  if [ ! -f "$config_file" ]; then
    echo "Error: Config file not found at $config_file"
    exit 1
  fi

  # Read apps with show_in_dock=true from config
  local app_bundles
  app_bundles=$(jq -r '.apps[] | select(.show_in_dock == true) | .app_bundle' "$config_file")

  # Remove all current dock items
  echo "Removing all current dock items..."
  dockutil --remove all --no-restart

  # Add system apps first
  for app in "${system_apps[@]}"; do
    if [ -d "$app" ]; then
      dockutil --add "$app" --no-restart
      echo "✓ Added $(basename "$app" .app)"
    else
      echo "⚠ Skipped $(basename "$app" .app) (not found)"
    fi
  done

  # Add apps from config
  if [ -n "$app_bundles" ]; then
    while IFS= read -r app_bundle; do
      local app_path="/Applications/$app_bundle"
      if [ -d "$app_path" ]; then
        dockutil --add "$app_path" --no-restart
        echo "✓ Added ${app_bundle%.app}"
      else
        echo "⚠ Skipped ${app_bundle%.app} (not installed)"
      fi
    done <<< "$app_bundles"
  fi

  # Restart Dock to apply changes
  killall Dock
  echo ""
  echo "Restarted dock to apply changes"
  echo ""
}

macos_run_all() {
  echo "macOS Configuration"
  echo "==================="
  echo ""
  macos_hot_corners
  macos_keyboard
  macos_screenshot
  macos_dock_apps

  echo "Done!"
}

macos_help() {
  echo "Usage: dotfiles macos <command>"
  echo ""
  echo "Commands:"
  echo "  run-all      Run all macOS configuration"
  echo "  hotcorners   Configure hot corners"
  echo "  dock         Set persistent dock applications"
  echo "  keyboard     Configure keyboard settings"
  echo "  screenshot   Configure screenshot settings"
  echo "  help         Show this help message"
}

macos_run() {
  local cmd="${1:-}"

  case "$cmd" in
    run-all)     macos_run_all ;;
    hotcorners)  macos_hot_corners ;;
    dock)        macos_dock_apps ;;
    keyboard)    macos_keyboard ;;
    screenshot)  macos_screenshot ;;
    help|"")     macos_help ;;
    *)
      echo "Unknown command: $cmd"
      echo ""
      macos_help
      exit 1
      ;;
  esac
}
