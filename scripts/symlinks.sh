read -p "Remove existing config files? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "\n\nRemoving existing files...\n"
  rm ~/.zshrc
  echo "Removed ~/.zshrc"
  rm ~/.vimrc
  echo "Removed ~/.vimrc"
  rm ~/.agignore
  echo "Removed ~/.agignore"
  rm ~/.gitconfig
  echo "Removed ~/.gitignore"
  rm ~/.gitignore_global
  echo "Removed ~/.gitignore_global"
  rm ~/.tmux.conf
  echo "Removed ~/.tmux.conf"
  rm ~/.vim
  echo "Removed ~/.vim"
  echo
fi

echo "Creating symlinks...\n"
ln -s ~/Code/dotfiles/zshrc ~/.zshrc
echo "Linked ~/.vim"
ln -s ~/Code/dotfiles/vimrc ~/.vimrc
echo "Linked ~/.vimrc"
ln -s ~/Code/dotfiles/agignore ~/.agignore
echo "Linked ~/.agignore"
ln -s ~/Code/dotfiles/gitconfig ~/.gitconfig
echo "Linked ~/.gitconfig"
ln -s ~/Code/dotfiles/gitignore_global ~/.gitignore_global
echo "Linked ~/.gitignore_global"
ln -s ~/Code/dotfiles/tmux.conf ~/.tmux.conf
echo "Linked ~/.tmux.conf"
ln -s ~/Code/dotfiles/vim ~/.vim
echo "Linked ~/.vim"
echo
echo "DONE."
