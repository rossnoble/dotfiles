# Install home brew (see brew.sh)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# TODO: Verify where these should go
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /Users/ross/.zprofile
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/ross/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
