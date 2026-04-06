# Sync gitignored files from main worktree to current worktree via symlinks
# Config file: .worktree-sync in the main worktree root
function worktree_sync() {
  # Get the main worktree (first line of git worktree list)
  local main_worktree
  main_worktree=$(git worktree list --porcelain 2>/dev/null | head -1 | sed 's/^worktree //')

  if [[ -z "$main_worktree" ]]; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Get current worktree root (handles being in subdirectory)
  local current_worktree
  current_worktree=$(git rev-parse --show-toplevel 2>/dev/null)

  if [[ -z "$current_worktree" ]]; then
    echo "Error: Could not determine worktree root"
    return 1
  fi

  # Using .local/* because it's already gitignored in maintainx
  #
  # local config_file="${main_worktree}/.worktree-sync"
  local config_file="${main_worktree}/.local/worktree-sync"

  if [[ ! -f "$config_file" ]]; then
    echo "No .worktree-sync found in main worktree: $main_worktree"
    return 1
  fi

  # Don't run in main worktree itself
  if [[ "$current_worktree" == "$main_worktree" ]]; then
    echo "Already in main worktree, nothing to sync"
    return 0
  fi

  echo "Syncing from: $main_worktree"
  echo ""

  while IFS= read -r item || [[ -n "$item" ]]; do
    # Skip comments and empty lines
    [[ -z "$item" || "$item" =~ ^[[:space:]]*# ]] && continue
    # Trim whitespace
    item=$(echo "$item" | xargs)

    local src="${main_worktree}/${item}"
    local dest="${current_worktree}/${item}"

    if [[ ! -e "$src" ]]; then
      echo "  [!] Not found in source: $item"
      continue
    fi

    if [[ -e "$dest" || -L "$dest" ]]; then
      echo "  [-] Skipping (exists): $item"
      continue
    fi

    # Ensure parent directory exists for nested paths
    local dest_dir="${dest:h}"
    if [[ ! -d "$dest_dir" ]]; then
      mkdir -p "$dest_dir" && echo "  [+] Created directory: ${dest_dir#$current_worktree/}"
    fi

    ln -s "$src" "$dest" && echo "  [+] Linked: $item"
  done < "$config_file"
}
