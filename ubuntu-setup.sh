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
  "UPGRADE"    "Update and upgrade system software                   " OFF \
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
  "STEAM"      "Install Steam                                        " OFF \
  "LUTRIS"     "Install Lutris (Steam, Epic Games, etc)              " OFF \
  "GPT4ALL"    "Install gpt4all                                      " OFF \
  "PINOKIO"    "Install pinokio.computer                             " OFF \
  "RMDOCS"     "Nautillus (Files) sidebar > Remove Documents         " OFF \
  "RMMUSIC"    "Nautillus (Files) sidebar > Remove Music             " OFF \
  "RMPICTURES" "Nautillus (Files) sidebar > Remove Pictures          " OFF \
  "RMVIDEOS"   "Nautillus (Files) sidebar > Remove Videos            " OFF \
3>&1 1>&2 2>&3)

for i in $CHOICES; do
  log "Working on $i..."

  if [[ $i == "\"UPGRADE\"" ]]; then
    sudo apt update
    sudo apt upgrade -y
    sudo snap refresh
  fi

  if [[ $i == "\"UNBLOAT\"" ]]; then
    sudo apt remove -y deja-dup rhythmbox cheese totem
    sudo snap remove thunderbird cups
  fi

  if [[ $i == "\"AUTOREMOVE\"" ]]; then
    sudo apt autoremove -y
  fi

  # https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

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
    sudo apt install -y git build-essential
    git clone https://github.com/tj/n.git /tmp/n
    cd /tmp/n
    sudo make install
    rm -rf /tmp/n
    sudo n latest
    sudo npm i -g npm
    node -v
    npm -v
    sudo npm i -g ntl # node task list - command line package.json menu
  fi

  if [[ "$i" == '"VSCODE"' ]]; then
    # install VSCode and remove Gnome Text Editor
    sudo snap install code --classic
    sudo apt remove -y gnome-text-editor
  fi

  if [[ "$i" == '"GHDESKTOP"' ]]; then
    # from https://github.com/shiftkey/desktop
    # TODO: this is breaking apt upgrade at the moment due to SSL expired / wrong on shiftkey.dev
    # wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
    # sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
    # so we are using mwt.me mirror
    wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'
    sudo apt update
    sudo apt install -y github-desktop
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    # sudo apt install -y keepassxc
    sudo snap install keepassxc
  fi

  # addons into firefox (they need to be enabled manually)
  # firefox_default_profile=$(echo /home/user/snap/firefox/common/.mozilla/firefox/*.default/extensions)
  # wget https://addons.mozilla.org/firefox/downloads/file/4458450/ublock_origin-latest.xpi -O $firefox_default_profile/uBlock0@raymondhill.net.xpi
  # wget https://addons.mozilla.org/firefox/downloads/file/4465727/sponsorblock-latest.xpi -O $firefox_default_profile/sponsorBlocker@ajay.app.xpi


  if [[ $i == "\"SYNCTHING\"" ]]; then
    chmod +x ./scripts/syncthing.sh
    ./scripts/syncthing.sh
  fi

  if [[ $i == "\"STEAM\"" ]]; then
    sudo apt install -y steam
  fi

  if [[ $i == "\"LUTRIS\"" ]]; then
    # see https://github.com/lutris/lutris/releases
    latest_deb_url=$(wget -q -O - https://api.github.com/repos/lutris/lutris/releases/latest  |  jq -r '.assets[] | select(.name | contains ("deb")) | .browser_download_url')
    echo $latest_deb_url
    wget $latest_deb_url -O /tmp/lutris.deb
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
    latest_deb_url=$(wget -q -O - https://api.github.com/repos/pinokiocomputer/pinokio/releases/latest  |  jq -r '.assets[] | select(.name | contains ("_amd64.deb")) | .browser_download_url')
    echo $latest_deb_url
    wget $latest_deb_url -O /tmp/pinokio.deb
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
