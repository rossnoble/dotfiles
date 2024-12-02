# NODE SETUP

brew install nvm

# Create local zshrc file"
echo >> ~/.zshrc_local

source ~/.zshrc

# Add autoload for nvm
# https://formulae.brew.sh/formula/nvm
echo "export NVM_DIR=\"$HOME/.nvm\"" >> ~/.zshrc_local
echo "[ -s \"$HOMEBREW_PREFIX/opt/nvm/nvm.sh\" ] && \. \"$HOMEBREW_PREFIX/opt/nvm/nvm.sh\"" >> ~/.zshrc_local
echo "[ -s \"$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm\" ] && \. \"$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm\"" >> ~/.zshrc_local

# Use nvm to install node
# NOTE: You probably have to reload the session
nvm install node

source ~/.zshrc

# Enable yarn
corepack enable

source ~/.zshrc
