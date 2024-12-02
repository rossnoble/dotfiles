# ssh-keygen -t ed25519 -C you@example.com
# ssh-keygen -t ed25519 -C rnoble@fastmail.com
# 
# eval "$(ssh-agent -s)"
# 
# touch ~/.ssh/config
# 
# # This assumes a passphrase was chosen
# echo "Host github.com
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_ed25519" > ~/.ssh/config
# 
# cat ~/.ssh/config

# # This assumes a passphrase was chosen
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
