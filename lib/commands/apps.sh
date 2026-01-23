# lib/commands/apps.sh - Application management commands

apps_install() {
  check_dependencies

  local apps_file="$SCRIPT_DIR/config/apps.json"
  local installed_casks=$(brew list --cask 2>/dev/null)

  echo "Application Installation"
  echo ""

  # Parse JSON and prompt for each app
  jq -c '.apps[]' "$apps_file" | while read -r app; do
    local name=$(echo "$app" | jq -r '.name')
    local cask=$(echo "$app" | jq -r '.cask')
    local app_bundle=$(echo "$app" | jq -r '.app_bundle')
    local description=$(echo "$app" | jq -r '.description')

    # Check if already installed (via Homebrew or /Applications)
    if echo "$installed_casks" | grep -q "^$cask$" || [ -d "/Applications/$app_bundle" ]; then
      echo "[installed] $name"
      continue
    fi

    if prompt_yes_no "Install $name? ($description)"; then
      echo "Installing $cask..."
      brew install --cask "$cask"
      echo "Installed $name"
      echo ""
    else
      echo "Skipped $name"
    fi
  done

  echo ""
  echo "Done!"
}

apps_list() {
  check_dependencies

  local apps_file="$SCRIPT_DIR/config/apps.json"
  local BOLD='\033[1m'
  local NC='\033[0m'

  echo "Available applications:"
  echo ""

  jq -c '.apps[]' "$apps_file" | while read -r app; do
    local name=$(echo "$app" | jq -r '.name')
    local description=$(echo "$app" | jq -r '.description')
    echo -e "  ${BOLD}$name${NC}: $description"
  done
  echo ""
}

apps_status() {
  check_dependencies

  local apps_file="$SCRIPT_DIR/config/apps.json"
  local installed_casks=$(brew list --cask 2>/dev/null)
  local BOLD='\033[1m'
  local NC='\033[0m'

  echo "Applications installed:"
  echo ""

  jq -c '.apps[]' "$apps_file" | while read -r app; do
    local name=$(echo "$app" | jq -r '.name')
    local cask=$(echo "$app" | jq -r '.cask')
    local app_bundle=$(echo "$app" | jq -r '.app_bundle')
    local description=$(echo "$app" | jq -r '.description')

    if echo "$installed_casks" | grep -q "^$cask$" || [ -d "/Applications/$app_bundle" ]; then
      echo -e "  [x] ${BOLD}$name${NC}: $description"
    else
      echo -e "  [ ] ${BOLD}$name${NC}: $description"
    fi
  done
  echo ""
}

apps_help() {
  echo "Usage: dotfiles apps <command>"
  echo ""
  echo "Commands:"
  echo "  install    Interactive application installation"
  echo "  list       Print available applications"
  echo "  status     Show installation status of all applications"
  echo "  help       Show this help message"
}

apps_run() {
  local cmd="${1:-}"

  case "$cmd" in
    install) apps_install ;;
    list)    apps_list ;;
    status)  apps_status ;;
    help|"") apps_help ;;
    *)
      echo "Unknown command: $cmd"
      echo ""
      apps_help
      exit 1
      ;;
  esac
}
