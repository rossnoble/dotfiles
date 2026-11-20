# AGENTS.md

## Project

Personal dotfiles and setup tooling for configuring macOS machines.

- `bootstrap.sh` is the entry point for a fresh machine.
- `bin/dotfiles` is a CLI with three domains (`apps`, `dev`, `macos`), implemented in `lib/commands/`, with shared helpers in `lib/utils.sh`.
- `config/` holds the JSON that drives the CLI: apps (`apps.json`), dev tools (`dev-tools.json`), and symlink mappings (`symlinks.json`).
- Top-level files and directories (`zshrc`, `gitconfig`, `tmux.conf`, `nvim/`, `ghostty.config`, `tmuxp/`, `agents/`, etc.) are symlinked into `~` according to `config/symlinks.json`.
- `agents/skills/` contains AI agent skills, which are symlinked to `~/.agents`.

## Git

Use [Conventional Commits](https://www.conventionalcommits.org/) for commit messages, for example:

- `feat: add pr-create skill`
- `fix: correct tmux pane keybinding`
- `chore: rename and delete skills`
