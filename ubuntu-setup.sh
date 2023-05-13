#!/bin/bash

CHOICES=$(\
  whiptail --title "norgeous' Ubuntu setup" --checklist \
  "Use Up / Down and Space to select.\nEnter to start.\nEsc to cancel." 18 56 8 \
  "UPDATE" "Update system software " OFF \
  "UPGRADE" "Upgrade system software " OFF \
  "UNBLOAT" "remove Ubuntu bloat " OFF \
  "AUTOREMOVE" "autoremove packages " OFF \
  "NODE" "Install tj/n " OFF \
  "VSCODE" "Install VSCode " OFF \
  "GITHUB-DESKTOP" "Install Github Desktop " OFF \
  "GPT4ALL" "Install gpt4all " OFF \
  "VLC" "Install VLC " OFF \
  "SYNCTHING" "Install Syncthing " OFF \
  "KEEPASSXC" "Install KeepassXC " OFF \
3>&1 1>&2 2>&3)

for i in $CHOICES; do
  echo "🧌  Working on $i..."

  if [[ $i == "\"UPDATE\"" ]]; then
    sudo apt update
  fi

  if [[ $i == "\"UPGRADE\"" ]]; then
    sudo apt upgrade
  fi

  if [[ $i == "\"UNBLOAT\"" ]]; then
    sudo apt remove thunderbird deja-dup rhythmbox cheese totem
  fi

  if [[ $i == "\"AUTOREMOVE\"" ]]; then
    sudo apt autoremove
  fi

  if [[ $i == "\"NODE\"" ]]; then
    chmod +x ./scripts/tj_n.sh
    ./scripts/tj_n.sh
  fi

  if [[ "$i" == '"VSCODE"' ]]; then
    snap install code --classic
  fi

  if [[ "$i" == '"GITHUB-DESKTOP"' ]]; then
    wget https://github.com/shiftkey/desktop/releases/download/release-3.2.1-linux1/GitHubDesktop-linux-3.2.1-linux1.deb -O /tmp/shiftkey-github-desktop.deb
    chmod +x /tmp/shiftkey-github-desktop.deb
    sudo apt install /tmp/shiftkey-github-desktop.deb
    rm /tmp/shiftkey-github-desktop.deb
  fi

  if [[ "$i" == '"GPT4ALL"' ]]; then
    wget https://gpt4all.io/installers/gpt4all-installer-linux.run -O /tmp/gpt4all-installer-linux.run
    chmod +x /tmp/gpt4all-installer-linux.run
    /tmp/gpt4all-installer-linux.run
    rm /tmp/gpt4all-installer-linux.run
  fi

  if [[ $i == "\"VLC\"" ]]; then
    sudo apt install -y vlc
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    sudo apt install -y keepassxc
  fi

  if [[ $i == "\"SYNCTHING\"" ]]; then
    chmod +x ./scripts/syncthing.sh
    ./scripts/syncthing.sh
  fi

  sleep 1

  echo
done
