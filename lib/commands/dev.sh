# lib/commands/dev.sh - Developer environment setup commands

prompt_input() {
  local prompt="$1"
  local response

  read -p "$prompt: " response < /dev/tty
  echo "$response"
}

# Detection functions
is_xcode_cli_installed() {
  xcode-select -p &>/dev/null
}

is_rosetta_installed() {
  /usr/bin/pgrep -q oahd 2>/dev/null
}

is_arm64() {
  [[ $(uname -m) == 'arm64' ]]
}

is_brew_package_installed() {
  local package="$1"
  brew list "$package" &>/dev/null
}

is_nvm_installed() {
  [ -d "$HOME/.nvm" ]
}

is_ssh_key_present() {
  [ -f "$HOME/.ssh/id_ed25519" ]
}

is_symlink() {
  [ -L "$1" ]
}

# Installation functions
install_system_prerequisites() {
  echo ""
  echo "System Prerequisites"
  echo "--------------------"

  # XCode CLI Tools
  if is_xcode_cli_installed; then
    echo "XCode Command Line Tools already installed"
  else
    if prompt_yes_no "Install XCode Command Line Tools?"; then
      echo "Installing XCode Command Line Tools..."
      xcode-select --install
      echo "Installed XCode Command Line Tools"
    else
      echo "Skipped XCode Command Line Tools"
    fi
  fi

  # Rosetta (Apple Silicon only)
  if is_arm64; then
    if is_rosetta_installed; then
      echo "Rosetta 2 already installed"
    else
      if prompt_yes_no "Install Rosetta 2? (for Intel compatibility)"; then
        echo "Installing Rosetta 2..."
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
        echo "Installed Rosetta 2"
      else
        echo "Skipped Rosetta 2"
      fi
    fi
  fi
}

install_cli_tools() {
  local config_file="$SCRIPT_DIR/config/dev-tools.json"
  local installed_packages=$(brew list 2>/dev/null)
  local tool_count=$(jq '.tools | length' "$config_file")

  echo ""
  echo "CLI Tools"
  echo "---------"

  # Iterate over all tools and access by index
  for ((i=0; i<tool_count; i++)); do
    local name=$(jq -r ".tools[$i].name" "$config_file")
    local package=$(jq -r ".tools[$i].package" "$config_file")
    local description=$(jq -r ".tools[$i].description" "$config_file")

    if echo "$installed_packages" | grep -q "^$package$"; then
      echo "$name already installed"
    else
      if prompt_yes_no "Install $name? ($description)"; then
        echo "Installing $package..."
        brew install "$package" || {
          echo "Failed to install $name"
          continue
        }
        echo "Installed $name"
      else
        echo "Skipped $name"
      fi
    fi
  done
}

install_node_environment() {
  echo ""
  echo "Node Environment"
  echo "----------------"

  # nvm
  if is_nvm_installed; then
    echo "nvm already installed"
  else
    if prompt_yes_no "Install nvm? (Node Version Manager)"; then
      # Create .zshrc_local file if not created
      if ! grep -q "NVM_DIR" "$HOME/.zshrc_local" 2>/dev/null; then
        echo "Creating zshrc.local file..."
        echo "" >> "$HOME/.zshrc.local"
      fi

      echo "Installing nvm..."

      # Download and install nvm
      # PROFILE specifies where the source script is added
      # See https://github.com/nvm-sh/nvm?tab=readme-ov-file#install--update-script
      PROFILE=~/.zshrc.local bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'

      echo "Installed nvm"
      echo ""
      echo "NOTE: Restart your terminal or run 'source ~/.zshrc' to use nvm"
      echo "Then run: nvm install node && corepack enable"
    else
      echo "Skipped nvm"
    fi
  fi
}

install_ssh_setup() {
  echo ""
  echo "SSH Setup"
  echo "---------"

  if is_ssh_key_present; then
    echo "SSH key already exists at ~/.ssh/id_ed25519"
  else
    if prompt_yes_no "Generate SSH key for GitHub?"; then
      local email=$(prompt_input "Enter your email address")

      echo "Generating SSH key..."
      ssh-keygen -t ed25519 -C "$email"

      # Start ssh-agent
      eval "$(ssh-agent -s)"

      # Create/update SSH config
      mkdir -p "$HOME/.ssh"
      if ! grep -q "Host github.com" "$HOME/.ssh/config" 2>/dev/null; then
        echo "Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519" >> "$HOME/.ssh/config"
      fi

      # Add key to agent
      ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519"

      # Copy public key to clipboard
      pbcopy < "$HOME/.ssh/id_ed25519.pub"
      echo ""
      echo "SSH key generated and public key copied to clipboard"
      echo "Add it to GitHub: https://github.com/settings/keys"
    else
      echo "Skipped SSH setup"
    fi
  fi
}

dev_link() {
  local config_file="$SCRIPT_DIR/config/symlinks.json"

  echo ""
  echo "Dotfile Symlinks"
  echo "----------------"

  jq -c '.symlinks[]' "$config_file" | while read -r link; do
    local source=$(echo "$link" | jq -r '.source')
    local target=$(echo "$link" | jq -r '.target')
    local is_directory=$(echo "$link" | jq -r '.is_directory // false')

    # Expand ~ to $HOME
    local expanded_target="${target/#\~/$HOME}"
    local source_path="$SCRIPT_DIR/$source"

    if is_symlink "$expanded_target"; then
      local current_target=$(readlink "$expanded_target")
      if [ "$current_target" = "$source_path" ]; then
        echo "[linked] $target"
      else
        if prompt_yes_no "$target points to wrong location. Update symlink?"; then
          rm "$expanded_target"
          ln -s "$source_path" "$expanded_target"
          echo "Updated $target"
        else
          echo "[stale] $target -> $current_target"
        fi
      fi
    elif [ -e "$expanded_target" ]; then
      if prompt_yes_no "$target exists. Replace with symlink to $source?"; then
        # Create parent directory if needed
        mkdir -p "$(dirname "$expanded_target")"
        rm -rf "$expanded_target"
        ln -s "$source_path" "$expanded_target"
        echo "Linked $target"
      else
        echo "Skipped $target"
      fi
    else
      if prompt_yes_no "Create symlink $target -> $source?"; then
        # Create parent directory if needed
        mkdir -p "$(dirname "$expanded_target")"
        ln -s "$source_path" "$expanded_target"
        echo "Linked $target"
      else
        echo "Skipped $target"
      fi
    fi
  done
}

# TODO: Move this as a post-install set for neovim only
install_post_setup() {
  echo ""
  echo "Post-install"
  echo "------------"

  local plug_path="$HOME/.local/share/nvim/site/autoload/plug.vim"

  if [ -f "$plug_path" ]; then
    echo "vim-plug already installed"
  else
    if prompt_yes_no "Install vim-plug for Neovim?"; then
      echo "Installing vim-plug..."
      sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      echo "Installed vim-plug"
      echo "Run :PlugInstall in Neovim to install plugins"
    else
      echo "Skipped vim-plug"
    fi
  fi
}

# Installs and configures everything
dev_install() {
  check_dependencies

  echo "Developer Environment Setup"
  echo "==========================="

  install_system_prerequisites
  install_cli_tools
  install_node_environment
  install_ssh_setup
  install_post_setup

  echo ""
  echo "Done!"
  echo ""
}

dev_status() {
  check_dependencies

  local config_file="$SCRIPT_DIR/config/dev-tools.json"
  local installed_packages=$(brew list 2>/dev/null)
  local BOLD='\033[1m'
  local NC='\033[0m'

  echo "Developer Environment Status"
  echo "============================"

  echo ""
  echo "System Prerequisites"
  echo "--------------------"
  if is_xcode_cli_installed; then
    echo -e "  XCode CLI Tools: ${BOLD}installed${NC}"
  else
    echo -e "  XCode CLI Tools: not installed"
  fi

  if is_arm64; then
    if is_rosetta_installed; then
      echo -e "  Rosetta 2: ${BOLD}installed${NC}"
    else
      echo -e "  Rosetta 2: not installed"
    fi
  fi

  echo ""
  echo "CLI Tools"
  echo "---------"
  jq -c '.tools[]' "$config_file" | while read -r tool; do
    local name=$(echo "$tool" | jq -r '.name')
    local package=$(echo "$tool" | jq -r '.package')

    if echo "$installed_packages" | grep -q "^$package$"; then
      echo -e "  ${BOLD}$name${NC}: installed"
    else
      echo -e "  ${BOLD}$name${NC}: not installed"
    fi
  done

  echo ""
  echo "Node Environment"
  echo "----------------"
  if is_nvm_installed; then
    echo -e "  nvm: ${BOLD}installed${NC}"
  else
    echo -e "  nvm: not installed"
  fi

  echo ""
  echo "SSH"
  echo "---"
  if is_ssh_key_present; then
    echo -e "  SSH key: ${BOLD}present${NC}"
  else
    echo -e "  SSH key: not present"
  fi

  echo ""
  echo "Symlinks"
  echo "--------"
  local symlinks_file="$SCRIPT_DIR/config/symlinks.json"
  jq -c '.symlinks[]' "$symlinks_file" | while read -r link; do
    local target=$(echo "$link" | jq -r '.target')
    local expanded_target="${target/#\~/$HOME}"

    if is_symlink "$expanded_target"; then
      echo -e "  [x] ${BOLD}$target${NC}: linked"
    elif [ -e "$expanded_target" ]; then
      echo -e "  [!] ${BOLD}$target${NC}: exists (not symlink)"
    else
      echo -e "  [ ] ${BOLD}$target${NC}: missing"
    fi
  done

  echo ""
  echo "Post-install"
  echo "------------"
  if [ -f "$HOME/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo -e "  vim-plug: ${BOLD}installed${NC}"
  else
    echo -e "  vim-plug: not installed"
  fi

  echo ""
}

dev_list() {
  check_dependencies

  local config_file="$SCRIPT_DIR/config/dev-tools.json"
  local BOLD='\033[1m'
  local NC='\033[0m'

  echo "Available developer tools:"
  echo ""

  jq -c '.tools[]' "$config_file" | while read -r tool; do
    local name=$(echo "$tool" | jq -r '.name')
    local description=$(echo "$tool" | jq -r '.description')
    echo -e "  ${BOLD}$name${NC}: $description"
  done

  echo ""
  echo "Additional setup:"
  echo -e "  ${BOLD}nvm${NC}: Node Version Manager"
  echo -e "  ${BOLD}SSH${NC}: GitHub SSH key configuration"
  echo -e "  ${BOLD}Symlinks${NC}: Dotfile symlinks"
  echo -e "  ${BOLD}vim-plug${NC}: Neovim plugin manager"
  echo ""
}

dev_ssh() {
  install_ssh_setup
}

dev_help() {
  echo "Usage: dotfiles dev <command>"
  echo ""
  echo "Commands:"
  echo "  install    Interactive developer environment setup"
  echo "  status     Show installation status of all tools"
  echo "  list       List available tools"
  echo "  link       Create symlinks to local dotfiles"
  echo "  ssh        Create SSH keys"
  echo "  help       Show this help message"
}

dev_run() {
  local cmd="${1:-}"

  case "$cmd" in
    install) dev_install ;;
    status)  dev_status ;;
    list)    dev_list ;;
    link)    dev_link ;;
    ssh)     dev_ssh ;;
    help|"") dev_help ;;
    *)
      echo "Unknown command: $cmd"
      echo ""
      dev_help
      exit 1
      ;;
  esac
}
