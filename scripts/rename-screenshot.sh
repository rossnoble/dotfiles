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
	dir=$(dirname "$f")
	ext="${f##*.}"

	# Custom format: $YYYY-MM-DD-screenshot-$unixtime.png
	newname="$(date +%Y-%m-%d)-screenshot-at-$(date +%s).${ext}"

	mv "$f" "$dir/$newname"
done
