# Creates a new git worktree alongside the current directory.
#
# Usage:
#   worktree_new [-m|--master] <branch-name>
#
# Options:
#   -m, --master  Force basing the new branch off main/master, even when
#                 currently on a feature branch. Without this flag, the new
#                 branch is based off the current branch.
#
# Examples:
#   If inside `~/Code/project-x` on main:
#     worktree_new claude/ABC-123/feature-z
#     -> Creates ~/Code/project-x__claude_ABC-123_feature-z
#
#   If inside `~/Code/project-x` on branch `feature-x`:
#     worktree_new feature-z
#     -> Creates ~/Code/project-x__feature-z (based off feature-x)
#
#   If inside `~/Code/project-x__feature-y` and you want to branch from master:
#     worktree_new -m feature-z
#     -> Creates ~/Code/project-x__feature-z (based off main/master)
#
function worktree_new() {
  # Always use the main worktree's directory name for consistent naming
  local project
  project="$(basename "$(git worktree list | head -1 | awk '{print $1}')")"
  local branch
  local base_branch
  local current_branch
  local tree_name
  local full_path
  local force_master=0

  # Parse optional flags (must come before branch name)
  if [[ "$1" == "-m" || "$1" == "--master" ]]; then
    force_master=1
    shift
  fi

  # Branch argument is always required
  if [[ -z "$1" ]]; then
    echo "Error: Branch name is required"
    echo "Usage: worktree_new [-m|--master] <branch-name>"
    return 1
  fi

  # Prefix branch name with worktree/ to distinguish from PR branches
  local prefix="worktree/"
  if [[ "$1" == ${prefix}* ]]; then
    branch="$1"
  else
    branch="${prefix}$1"
  fi

  # Detect main or master branch
  if git show-ref --verify --quiet "refs/heads/main"; then
    base_branch="main"
  elif git show-ref --verify --quiet "refs/heads/master"; then
    base_branch="master"
  else
    echo "Error: Could not find main or master branch"
    return 1
  fi

  # Get current branch
  current_branch=$(git branch --show-current)

  # If on a feature branch, use it as base for new branches (unless -m flag passed)
  if [[ "$force_master" -eq 0 ]] && [[ "$current_branch" != "main" ]] && [[ "$current_branch" != "master" ]]; then
    base_branch="$current_branch"
  fi

  # Generate tree name by stripping first prefix level (e.g., claude/my-feature -> my-feature)
  tree_name="${branch#*/}"

  # Replace any remaining slashes with underscores
  tree_name="${tree_name//\//_}"

  # Build full path
  full_path="../${project}__${tree_name}"

  if git show-ref --verify --quiet "refs/heads/$branch"; then
    # Branch exists: create worktree using existing branch
    if git worktree add "$full_path" "$branch"; then
      echo "Worktree ready at $full_path (using existing branch $branch)"
    else
      echo "Error: Failed to create worktree"
      return 1
    fi
  else
    # Branch doesn't exist: create new branch from base
    if git worktree add -b "$branch" "$full_path" "$base_branch"; then
      echo "Worktree ready at $full_path (created new branch $branch from $base_branch)"
    else
      echo "Error: Failed to create worktree"
      return 1
    fi
  fi

  # Any other setup steps
  cd "$full_path"
  # e.g. yarn install
}

# Enable git branch completion for worktree_new
compdef _git worktree_new=git-branch
