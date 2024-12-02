# Install home brew (see brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

PROFILE_PATH="/Users/$(whoami)/.zprofile"
echo >> "${PROFILE_PATH}"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${PROFILE_PATH}"
eval "$(/opt/homebrew/bin/brew shellenv)"
