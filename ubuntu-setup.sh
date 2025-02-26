#!/bin/bash

function title {
  P='\033[1;35m' # purple
  C='\033[1;36m' # cyan
  N='\033[0m' # color off
  length=${#1}
  width=$((length + 4))
  echo -en "${C}"
  printf %${width}s | tr " " "#"
  echo
  echo -e "# ${P}$1${C} #"
  printf %${width}s | tr " " "#"
  echo -e "${N}\n"
}

function log {
  C='\033[1;36m' # cyan
  N='\033[0m' # color off
  echo -e "🧌  ${C}$1${N}\n"
}

function commentOut {
  FIND="$1"
  REPLACE="# $1"
  FILE="$2"
  sudo sed -i "s/^$FIND/$REPLACE/g" "$FILE"
}

title "norgeous' Ubuntu setup"

CHOICES=$(\
  whiptail --title "norgeous' Ubuntu setup" --checklist \
  "Use Up / Down and Space to select.\nEnter to start.\nEsc to cancel." 21 77 12 \
  "UPDATE"     "Update system software package lists                 " OFF \
  "UPGRADE"    "Upgrade system software                              " OFF \
  "AUTOREMOVE" "Autoremove packages                                  " OFF \
  "UNBLOAT"    "Remove Ubuntu bloat                                  " OFF \
  "MPV"        "Install MPV                                          " OFF \
  "GIMP"       "Install GIMP (snap)                                  " OFF \
  "INKSCAPE"   "Install InkScape (snap)                              " OFF \
  "BLENDER"    "Install Blender (snap)                               " OFF \
  "NODE"       "Install tj/n                                         " OFF \
  "VSCODE"     "Install VSCode (snap)                                " OFF \
  "GHDESKTOP"  "Install Github Desktop                               " OFF \
  "SYNCTHING"  "Install Syncthing                                    " OFF \
  "KEEPASSXC"  "Install KeepassXC                                    " OFF \
  "LUTRIS"     "Install Lutris (Steam, Epic, etc)                    " OFF \
  "GPT4ALL"    "Install gpt4all                                      " OFF \
  "PINOKIO"    "Install pinokio.computer                             " OFF \
  "RMDOCS"     "Nautillus (Files) sidebar > Remove Documents         " OFF \
  "RMMUSIC"    "Nautillus (Files) sidebar > Remove Music             " OFF \
  "RMPICTURES" "Nautillus (Files) sidebar > Remove Pictures          " OFF \
  "RMVIDEOS"   "Nautillus (Files) sidebar > Remove Videos            " OFF \
3>&1 1>&2 2>&3)

for i in $CHOICES; do
  log "Working on $i..."

  if [[ $i == "\"UPDATE\"" ]]; then
    sudo apt update
    sudo snap refresh # TODO: does this actually perform the upgrade also?
  fi

  if [[ $i == "\"UPGRADE\"" ]]; then
    sudo apt upgrade
    
    # not sure if this is needed https://askubuntu.com/a/761719
    snap list | awk -F" " '{if ($1 && NR>1) { system("sudo snap refresh " $1) }}'
  fi

  if [[ $i == "\"AUTOREMOVE\"" ]]; then
    sudo apt autoremove -y
  fi

  if [[ $i == "\"UNBLOAT\"" ]]; then
    sudo apt remove -y deja-dup rhythmbox cheese totem
    sudo snap remove thunderbird cups
  fi

  if [[ $i == "\"MPV\"" ]]; then
    sudo apt install -y mpv
    # TODO: set mpv.conf and input.conf
  fi

  if [[ $i == "\"GIMP\"" ]]; then
    sudo snap install gimp
  fi

  if [[ $i == "\"INKSCAPE\"" ]]; then
    sudo snap install inkscape
  fi

  if [[ $i == "\"BLENDER\"" ]]; then
    sudo snap install blender
  fi

  if [[ $i == "\"NODE\"" ]]; then
    chmod +x ./scripts/tj_n.sh
    ./scripts/tj_n.sh
  fi

  if [[ "$i" == '"VSCODE"' ]]; then
    sudo snap install code --classic
    sudo apt remove gnome-text-editor
  fi

  if [[ "$i" == '"GHDESKTOP"' ]]; then
    # from https://github.com/shiftkey/desktop
    # TODO: this is breaking apt upgrade at the moment due to SSL expired / wrong on shiftkey.dev
    wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    sudo apt update
    sudo apt install github-desktop
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    sudo apt install -y keepassxc
  fi

  if [[ $i == "\"SYNCTHING\"" ]]; then
    chmod +x ./scripts/syncthing.sh
    ./scripts/syncthing.sh
  fi

  if [[ $i == "\"LUTRIS\"" ]]; then
    # see https://github.com/lutris/lutris/releases
    wget https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb -O /tmp/lutris.deb
    chmod +x /tmp/lutris.deb
    sudo dpkg -i /tmp/lutris.deb
    rm /tmp/lutris.deb
  fi

  # GPT4ALL
  if [[ "$i" == '"GPT4ALL"' ]]; then
    wget https://gpt4all.io/installers/gpt4all-installer-linux.run -O /tmp/gpt4all-installer-linux.run
    chmod +x /tmp/gpt4all-installer-linux.run
    /tmp/gpt4all-installer-linux.run
    rm /tmp/gpt4all-installer-linux.run
    # TODO: .desktop link appears to install to ~/Desktop, and doesnt appear in dock in Ubuntu 24.04
  fi

  if [[ "$i" == '"PINOKIO"' ]]; then
    # see https://github.com/pinokiocomputer/pinokio/releases
    wget https://github.com/pinokiocomputer/pinokio/releases/download/2.15.1/Pinokio_2.15.1_amd64.deb -O /tmp/pinokio.deb
    chmod +x /tmp/pinokio.deb
    sudo dpkg -i /tmp/pinokio.deb
    rm /tmp/pinokio.deb
    
    # fix the .desktop link file icon, as it seems to be broken
    cp /usr/share/icons/hicolor/0x0/apps/pinokio.png /home/user/.local/share/icons/hicolor/256x256/apps/pinokio.png
  fi

  if [[ "$i" == '"RMDOCS"' ]]; then
    commentOut "XDG_DOCUMENTS_DIR=" "$HOME/.config/user-dirs.dirs"
    commentOut "DOCUMENTS=" "/etc/xdg/user-dirs.defaults" # must be edited for changes to persist after reboot
  fi

  if [[ "$i" == '"RMMUSIC"' ]]; then
    commentOut "XDG_MUSIC_DIR=" "$HOME/.config/user-dirs.dirs"
    commentOut "MUSIC=" "/etc/xdg/user-dirs.defaults" # must be edited for changes to persist after reboot
  fi

  if [[ "$i" == '"RMPICTURES"' ]]; then
    commentOut "XDG_PICTURES_DIR=" "$HOME/.config/user-dirs.dirs"
    commentOut "PICTURES=" "/etc/xdg/user-dirs.defaults" # must be edited for changes to persist after reboot
  fi

  if [[ "$i" == '"RMVIDEOS"' ]]; then
    commentOut "XDG_VIDEOS_DIR=" "$HOME/.config/user-dirs.dirs"
    commentOut "VIDEOS=" "/etc/xdg/user-dirs.defaults" # must be edited for changes to persist after reboot
  fi

  echo

  sleep 1
done

log "Done."
echo "Press any key to exit..."
echo
read -rsn1 -p ""
