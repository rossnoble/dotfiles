#!/bin/bash

# jd-index.sh
# Generates a Johnny Decimal index from directory structure
# Flags misplaced items with [!]
# Usage: ./jd-index.sh [path]
#        Defaults to current directory if no path provided

root="${1:-.}"

# Color codes (only if outputting to a terminal)
if [ -t 1 ]; then
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m'
else
  GREEN=''
  RED=''
  NC=''
fi

# Find all JD area directories and sort them
find "$root" -maxdepth 1 -type d -name '[0-9][0-9] *' | sort | while read -r area; do
  area_name=$(basename "$area")
  area_num=${area_name:0:2}
  echo "$area_name"

  # Find categories within this area
  find "$area" -maxdepth 1 -type d -name '[0-9][0-9] *' | sort | while read -r category; do
    category_name=$(basename "$category")
    category_num=${category_name:0:2}

    # Check if category belongs in this area (first digit should match area's first digit)
    # Special case: 00 Inbox can live anywhere
    if [[ "$category_num" == "00" ]] || [[ "${category_num:0:1}" == "${area_num:0:1}" ]]; then
      echo -e "   ${GREEN}$category_name${NC}"
    else
      echo -e "   ${RED}[!] $category_name${NC}"
    fi

    # Find IDs within this category
    find "$category" -maxdepth 1 -type d -name '[0-9][0-9].[0-9][0-9] *' | sort | while read -r id; do
      id_name=$(basename "$id")
      id_prefix=${id_name:0:2}

      # Check if ID belongs in this category (prefix should match category number)
      if [[ "$id_prefix" == "$category_num" ]]; then
        echo -e "      ${GREEN}$id_name${NC}"
      else
        echo -e "      ${RED}[!] $id_name${NC}"
      fi
    done
  done
done
