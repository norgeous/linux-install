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
  "MPV" "Install MPV " OFF \
  "SYNCTHING" "Install Syncthing " OFF \
  "KEEPASSXC" "Install KeepassXC " OFF \
  "STEAM" "Install Steam " OFF \
  "LUTRIS" "Install Lutris " OFF \
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
    # from https://github.com/shiftkey/desktop
    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    sudo apt update
    sudo apt install github-desktop
  fi

  if [[ "$i" == '"GPT4ALL"' ]]; then
    wget https://gpt4all.io/installers/gpt4all-installer-linux.run -O /tmp/gpt4all-installer-linux.run
    chmod +x /tmp/gpt4all-installer-linux.run
    /tmp/gpt4all-installer-linux.run
    rm /tmp/gpt4all-installer-linux.run
  fi

  if [[ $i == "\"MPV\"" ]]; then
    sudo apt install -y mpv
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    sudo apt install -y keepassxc
  fi

  if [[ $i == "\"SYNCTHING\"" ]]; then
    chmod +x ./scripts/syncthing.sh
    ./scripts/syncthing.sh
  fi

  if [[ $i == "\"STEAM\"" ]]; then
    sudo apt install -y steam
  fi

  if [[ $i == "\"LUTRIS\"" ]]; then
    # see https://github.com/lutris/lutris/releases
    wget https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb -O /tmp/lutris.deb
    chmod +x /tmp/lutris.deb
    sudo dpkg -i /tmp/lutris.deb
  fi

  # Customise the sidebar in Files (Nautillus)
  # ~/.config/user-dirs.dirs
  # sed -i
    # XDG_DOCUMENTS_DIR="$HOME/Documents"
    # XDG_MUSIC_DIR="$HOME/Music"
    # XDG_PICTURES_DIR="$HOME/Pictures"
    # XDG_VIDEOS_DIR="$HOME/Videos"

  # rm -r ~/Documents
  # rm -r ~/Music
  # rm -r ~/Videos

  sleep 1

  echo
done
