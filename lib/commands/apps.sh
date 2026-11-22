# lib/commands/apps.sh - Application management commands

apps_install() {
  check_dependencies

  local apps_file="$SCRIPT_DIR/config/apps.json"
  local installed_casks=$(brew list --cask 2>/dev/null)

  local candidates=()
  local selected_casks=()
  local selected_names=()

  echo "Application Installation"
  echo ""

  # Process substitution (not a pipe) so the arrays survive the loop
  while IFS=$'\t' read -r name cask app_bundle description; do
    if echo "$installed_casks" | grep -q "^$cask$" || [ -d "/Applications/$app_bundle" ]; then
      echo "[installed] $name"
    else
      candidates+=("$name"$'\t'"$cask"$'\t'"$description")
    fi
  done < <(jq -r '.apps[] | [.name, .cask, .app_bundle, .description] | @tsv' "$apps_file")

  echo ""

  if [ ${#candidates[@]} -eq 0 ]; then
    echo "All applications are already installed."
    return 0
  fi

  if command -v fzf &> /dev/null; then
    # fzf renders tabs as tab stops, so pad names into one aligned display column
    local width=0
    for candidate in "${candidates[@]}"; do
      name="${candidate%%$'\t'*}"
      [ ${#name} -gt $width ] && width=${#name}
    done

    local selection
    selection=$(
      for candidate in "${candidates[@]}"; do
        IFS=$'\t' read -r name cask description <<< "$candidate"
        printf '%s\t%s\t%-*s  %s\n' "$name" "$cask" "$width" "$name" "$description"
      done | fzf --multi --reverse \
        --delimiter=$'\t' --with-nth=3 \
        --prompt="Apps> " \
        --header="TAB to select, ENTER to confirm, ESC to cancel"
    ) || true

    while IFS=$'\t' read -r name cask _; do
      [ -z "$cask" ] && continue
      selected_casks+=("$cask")
      selected_names+=("$name")
    done <<< "$selection"
  else
    echo "Tip: install fzf (dotfiles dev install) for multi-select"
    echo ""
    for candidate in "${candidates[@]}"; do
      IFS=$'\t' read -r name cask description <<< "$candidate"
      if prompt_yes_no "Install $name? ($description)"; then
        selected_casks+=("$cask")
        selected_names+=("$name")
      fi
    done
    echo ""
  fi

  if [ ${#selected_casks[@]} -eq 0 ]; then
    echo "No applications selected."
    return 0
  fi

  echo "Selected for installation:"
  for name in "${selected_names[@]}"; do
    echo "  - $name"
  done
  echo ""

  if ! prompt_yes_no "Install ${#selected_casks[@]} application(s)?"; then
    echo "Cancelled."
    return 0
  fi

  echo ""
  if brew install --cask "${selected_casks[@]}"; then
    echo ""
    echo "Done!"
  else
    echo ""
    echo "Some applications failed to install. Run 'dotfiles apps status' to check."
    return 1
  fi
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
