#!/bin/bash

CHOICES=$(\
  whiptail --title "norgeous' Ubuntu setup" --checklist \
  "Choose software options" 15 58 8 \
  "UPDATE" "Update system software " ON \
  "UPGRADE" "Upgrade system software " ON \
  "UNBLOAT" "remove Ubuntu bloat " OFF \
  "VLC" "Install VLC " OFF \
  "SYNCTHING" "Install Syncthing " OFF \
  "KEEPASSXC" "Install KeepassXC " OFF \
  "VSCODE" "Install VSCode " OFF \
  "GITHUB-DESKTOP" "Install Github Desktop " OFF \
  "GPT4ALL" "Install gpt4all " OFF \
3>&1 1>&2 2>&3)

for i in $CHOICES; do
  echo "🧌  Working on $i..."

  if [[ $i == "\"UPDATE\"" ]]; then
    echo "sudo apt update"
    sudo apt update
  fi

  if [[ $i == "\"UPGRADE\"" ]]; then
    echo "sudo apt upgrade"
    sudo apt upgrade
  fi

  if [[ $i == "\"UNBLOAT\"" ]]; then
    echo "sudo apt remove thunderbird deja-dup rhythmbox cheese totem"
    sudo apt remove thunderbird deja-dup rhythmbox cheese totem
    sudo apt autoremove
  fi

  if [[ $i == "\"VLC\"" ]]; then
    echo "sudo apt install vlc"
    sudo apt install vlc
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    echo "sudo apt install keepassxc"
    sudo apt install keepassxc
  fi

  if [[ "$i" == '"VSCODE"' ]]; then
    echo "snap install code --classic"
    snap install code --classic
  fi

  if [[ "$i" == '"GITHUB-DESKTOP"' ]]; then
    echo "GITHUB-DESKTOP"
    wget https://github.com/shiftkey/desktop/releases/download/release-3.2.1-linux1/GitHubDesktop-linux-3.2.1-linux1.deb -O /tmp/shiftkey-github-desktop.deb
    chmod +x /tmp/shiftkey-github-desktop.deb
    sudo apt install /tmp/shiftkey-github-desktop.deb
    rm /tmp/shiftkey-github-desktop.deb

  fi

  if [[ "$i" == '"GPT4ALL"' ]]; then
    echo "install GPT"
    wget https://gpt4all.io/installers/gpt4all-installer-linux.run -O /tmp/gpt4all-installer-linux.run
    chmod +x /tmp/gpt4all-installer-linux.run
    /tmp/gpt4all-installer-linux.run
    rm /tmp/gpt4all-installer-linux.run
  fi

  sleep 1

  echo
done
