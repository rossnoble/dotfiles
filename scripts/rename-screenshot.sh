#!/bin/bash
# Rename screenshots with custom format
# Called by Automator Folder Action when files are added to ~/Screenshots
#
# Add the following to Automator
# 1. New Document
# 2. Select "Folder Action"
# 3. Select "Screenshots" folder to watch
# 4. Search for "Run Shell Script"
# 5. Add the following snippet to source this file:
# ```
# "$HOME/Code/dotfiles/scripts/rename-screenshot.sh" "$@"
# ```

for f in "$@"; do
  # Skip if not a file
  [ -f "$f" ] || continue

	dir=$(dirname "$f")
	ext="${f##*.}"

  # Only rename files matching macOS default screenshot pattern
  # e.g., "Screenshot 2026-02-06 at 2.30.22 PM.png"
  SCREENSHOT_PATTERN='^Screenshot [0-9]{4}-[0-9]{2}-[0-9]{2}'

  basename=$(basename "$f")
  if [[ ! "$basename" =~ $SCREENSHOT_PATTERN ]]; then
     continue
  fi

  datestamp=$(date +%Y-%m-%d)
  epoch=$(date +%s)

	# Custom format: $YYYY-MM-DD-screenshot_$unixtime.png
  # This naming scheme is designed to be easy to rename/edit while
  # retaining the datestamp prefix.
	newname="${datestamp}-screenshot_${epoch}.${ext}"

	mv "$f" "$dir/$newname"
done
