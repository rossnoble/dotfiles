# Creates a new git worktree alongside the current directory.
#
# Usage:
#   worktree_new <branch-name>
#
# Examples:
#   If inside `~/Code/project-a` on main:
#     worktree_new claude/my-feature
#     -> Creates ~/Code/project-a-my-feature with new branch from main
#
#   If inside `~/Code/project-a` on branch `feature-x`:
#     worktree_new new-branch
#     -> Creates ~/Code/project-a-new-branch with new branch from feature-x
#
#   If inside `~/Code/project-a` (any branch):
#     worktree_new existing-branch
#     -> Creates ~/Code/project-a-existing-branch using existing branch
#
function worktree_new() {
  local project="${PWD##*/}"
  local branch
  local base_branch
  local current_branch
  local tree_name
  local full_path

  # Branch argument is always required
  if [[ -z "$1" ]]; then
    echo "Error: Branch name is required"
    echo "Usage: new_worktree <branch-name>"
    return 1
  fi
  branch="$1"

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

  # If on a feature branch, use it as base for new branches
  if [[ "$current_branch" != "main" ]] && [[ "$current_branch" != "master" ]]; then
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
