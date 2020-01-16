#!/bin/bash

install_software () {
  echo 'Installing Software'
  sudo apt update;
  sudo apt upgrade -y;
  sudo apt install vim tmux git;
}

register_github() {
  echo 'Registering Github Keys'
  # Register a new SSH key with github
  echo 'Enter your email address for github > '
  read GITHUB_EMAIL

  echo 'Enter your name for github > '
  read GITHUB_USERNAME

  echo "generating ssh for github (with account $GITHUB_EMAIL";
  ssh-keygen -t rsa -b 4096 -C "$GITHUB_EMAIL";
  eval "$(ssh-agent -s)" 2>&1 /dev/null;
  ssh-add ~/.ssh/id_rsa

  git config --global user.name "$GITHUB_USERNAME"
  git config --global user.email "$GITHUB_EMAIL"

  cat ~/.ssh/id_rsa.pub
  echo "Copy and paste the public key into github then press enter";
  read IGNORE
}

install_dots () {
  # download dot files
  echo "Downloading dot files and updating user configuration";
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim;
  
  mkdir -p ~/workspace;
  cd workspace && git clone git@github.com:jaypmorgan/dotfiles.git
  cp dotfiles/.vimrc ~/.;
  cp dotfiles/.tmux.conf ~/.;
  vim -c 'PluginInstall' -c 'qa!';
  source ~/.bashrc;
}


if ! [[ $* == *--server* ]]; then
  install_software;
fi

register_github;
install_dots;
