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

function uncomment {
  sed -i "/$1/s/^#//" "$2"
}

function addToDock {
  gsettings set org.gnome.shell favorite-apps "$(gsettings get org.gnome.shell favorite-apps | sed s/.$//), '$1']"
}

title "norgeous' Ubuntu setup"

CHOICES=$(\
  whiptail --title "norgeous' Ubuntu setup" --checklist \
  "Use Up / Down and Space to select.\nEnter to start.\nEsc to cancel." 21 77 12 \
  "UNBLOAT"       "Remove Ubuntu bloat                                  " OFF \
  "UPGRADE"       "Update and upgrade system software                   " OFF \
  "AUTOREMOVE"    "Autoremove packages                                  " OFF \
  "FIXINSTALL"    "Fix broken install                                   " OFF \
  "NOWAY"         "Disable Wayland                                      " OFF \
  "CHROME"        "Install Chrome (deb)                                 " OFF \
  "CHROMIUM"      "Install Chromium (snap)                              " OFF \
  "WATERFOX"      "Install Waterfox (flatpak)                           " OFF \
  "KEEPASSXC"     "Install KeepassXC (snap)                             " OFF \
  "UBLOCK"        "Install uBlock Origin (firefox addon)                " OFF \
  "SPONSBLOCK"    "Install SponsorBlock (firefox addon)                 " OFF \
  "TOP"           "Install htop and nvtop                               " OFF \
  "RESOURCES"     "Install Nokyan Resources (flatpak)                   " OFF \
  "MPV"           "Install MPV                                          " OFF \
  "GIMP"          "Install GIMP (snap)                                  " OFF \
  "INKSCAPE"      "Install InkScape (snap)                              " OFF \
  "BLENDER"       "Install Blender (snap)                               " OFF \
  "NODE"          "Install tj/n                                         " OFF \
  "VSCODE"        "Install VSCode (snap) and remove Gnome Text Editor   " OFF \
  "GHDESKTOP"     "Install Github Desktop                               " OFF \
  "SYNCTHING"     "Install Syncthing                                    " OFF \
  "STEAM"         "Install Steam                                        " OFF \
  "LUTRIS"        "Install Lutris (deb) (Steam, Epic, EA, Ubisoft, GOG) " OFF \
  "GPT4ALL"       "Install gpt4all (.run)                               " OFF \
  "PINOKIO"       "Install pinokio.computer (deb)                       " OFF \
  "PROTONVPN"     "Install Proton VPN (deb)                             " OFF \
  "DARK"          "Enable system dark mode                              " OFF \
  "DOCKBOTTOM"    "Move dock to bottom edge and set 32px icons          " OFF \
  "WIDEWALLPAPER" "Configure wallpaper for dual / triple screen         " OFF \
  "FASTBLINK"     "Faster system cursor blink rate                      " OFF \
  "HIDEHOME"      "Hide Home directory on the desktop wallpaper         " OFF \
  "BLUETOOTHOFF"  "Disable bluetooth on startup                         " OFF \
  "RMDOCS"        "Remove ~/Documents                                   " OFF \
  "RMMUSIC"       "Remove ~/Music                                       " OFF \
  "RMPICTURES"    "Remove ~/Pictures                                    " OFF \
  "RMPUBLIC"      "Remove ~/Public                                      " OFF \
  "RMTEMPLATES"   "Remove ~/Templates                                   " OFF \
  "RMVIDEOS"      "Remove ~/Videos                                      " OFF \
3>&1 1>&2 2>&3)

for i in $CHOICES; do
  log "Working on $i..."

  if [[ "$i" == '"UNBLOAT"' ]]; then
    sudo apt remove -y deja-dup rhythmbox cheese totem shotwell remmina 'libreoffice*'
    sudo snap remove thunderbird cups
  fi

  if [[ "$i" == '"UPGRADE"' ]]; then
    update="sudo apt update && sudo apt upgrade -y; sudo snap refresh; command -v flatpak && flatpak update -y"
    eval $update
    update_alias="alias update=\"$update\""
    grep -Fxq "$update_alias" ~/.bashrc || echo $update_alias >> ~/.bashrc
    source ~/.bashrc
  fi

  if [[ "$i" == '"AUTOREMOVE"' ]]; then
    sudo apt autoremove -y
  fi

  if [[ "$i" == '"FIXINSTALL"' ]]; then
    sudo apt --fix-broken -y install
  fi

  if [[ "$i" == '"NOWAY"' ]]; then
    sudo uncomment "#WaylandEnable=false" "/etc/gdm3/custom.conf"
  fi

  if [[ "$i" == '"CHROME"' ]]; then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/google-chrome.deb
    chmod +x /tmp/google-chrome.deb
    sudo dpkg -i /tmp/google-chrome.deb
    rm /tmp/google-chrome.deb
    addToDock google-chrome.desktop
  fi

  if [[ "$i" == '"CHROMIUM"' ]]; then
    snap install chromium
    addToDock chromium_chromium.desktop
  fi

  if [[ "$i" == '"WATERFOX"' ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub net.waterfox.waterfox
    addToDock net.waterfox.waterfox.desktop
  fi

  if [[ "$i" == '"KEEPASSXC"' ]]; then
    sudo snap install keepassxc
    addToDock keepassxc_keepassxc.desktop
    wget https://addons.mozilla.org/firefox/downloads/file/4592023/keepassxc_browser-latest.xpi -O /tmp/keepassxc_browser.xpi
    firefox_default_profile=$(echo ~/snap/firefox/common/.mozilla/firefox/*.default/extensions)
    waterfox_default_profile=$(echo ~/.var/app/net.waterfox.waterfox/.waterfox/*.default-release/extensions)
    cp /tmp/keepassxc_browser.xpi $firefox_default_profile/keepassxc-browser@keepassxc.org.xpi
    cp /tmp/keepassxc_browser.xpi $waterfox_default_profile/keepassxc-browser@keepassxc.org.xpi
  fi

  if [[ "$i" == '"UBLOCK"' ]]; then
    wget https://addons.mozilla.org/firefox/downloads/file/4458450/ublock_origin-latest.xpi -O /tmp/ublock_origin.xpi
    firefox_default_profile=$(echo ~/snap/firefox/common/.mozilla/firefox/*.default/extensions)
    waterfox_default_profile=$(echo ~/.var/app/net.waterfox.waterfox/.waterfox/*.default-release/extensions)
    cp /tmp/ublock_origin.xpi $firefox_default_profile/uBlock0@raymondhill.net.xpi
    cp /tmp/ublock_origin.xpi $waterfox_default_profile/uBlock0@raymondhill.net.xpi
  fi

  if [[ "$i" == '"SPONSBLOCK"' ]]; then
    wget https://addons.mozilla.org/firefox/downloads/file/4465727/sponsorblock-latest.xpi -O /tmp/sponsorblock.xpi
    firefox_default_profile=$(echo ~/snap/firefox/common/.mozilla/firefox/*.default/extensions)
    waterfox_default_profile=$(echo ~/.var/app/net.waterfox.waterfox/.waterfox/*.default-release/extensions)
    cp /tmp/sponsorblock.xpi $firefox_default_profile/sponsorBlocker@ajay.app.xpi
    cp /tmp/sponsorblock.xpi $waterfox_default_profile/sponsorBlocker@ajay.app.xpi
  fi

  if [[ "$i" == '"TOP"' ]]; then
    sudo apt install -y htop nvtop
  fi

  if [[ "$i" == '"RESOURCES"' ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub net.nokyan.Resources
    addToDock net.nokyan.Resources.desktop
  fi

  if [[ "$i" == '"MPV"' ]]; then
    sudo apt install -y mpv
    mkdir -p ~/.config/mpv/
    echo "r playlist-shuffle\nup add volume 1\ndown add volume -1" > ~/.config/mpv/input.conf
    echo -e "volume=50\nloop-playlist=inf" > ~/.config/mpv/mpv.conf
  fi

  if [[ "$i" == '"GIMP"' ]]; then
    sudo snap install gimp
  fi

  if [[ "$i" == '"INKSCAPE"' ]]; then
    sudo snap install inkscape
  fi

  if [[ "$i" == '"BLENDER"' ]]; then
    sudo snap install blender
  fi

  if [[ "$i" == '"NODE"' ]]; then
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

  # pyenv python version manager
  # curl -fsSL https://pyenv.run | bash
  # echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  # echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  # echo 'eval "$(pyenv init - bash)"' >> ~/.bashrc
  # sudo apt update
  # sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev



  # conda installer (miniconda)

  if [[ "$i" == '"VSCODE"' ]]; then
    sudo snap install code --classic
    sudo apt remove -y gnome-text-editor

    # fix the copy lines up/down keybindings
    mkdir -p ~/.config/Code/User/
    cat <<'EOF' > ~/.config/Code/User/keybindings.json
[
    { "key": "shift+alt+up",        "command": "editor.action.copyLinesUpAction",    "when": "editorTextFocus && !editorReadonly" },
    { "key": "ctrl+shift+alt+up",   "command": "-editor.action.copyLinesUpAction",   "when": "editorTextFocus && !editorReadonly" },
    { "key": "shift+alt+down",      "command": "editor.action.copyLinesDownAction",  "when": "editorTextFocus && !editorReadonly" },
    { "key": "ctrl+shift+alt+down", "command": "-editor.action.copyLinesDownAction", "when": "editorTextFocus && !editorReadonly" }
]
EOF
    addToDock code_code.desktop
  fi

  if [[ "$i" == '"GHDESKTOP"' ]]; then
    # from https://github.com/shiftkey/desktop
    # standard gpg key is breaking apt upgrade at the moment due to SSL expired / wrong on shiftkey.dev
    # so we are using mwt.me mirror
    wget -qO - https://mirror.mwt.me/shiftkey-desktop/gpgkey | gpg --dearmor | sudo tee /usr/share/keyrings/mwt-desktop.gpg > /dev/null
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mwt-desktop.gpg] https://mirror.mwt.me/shiftkey-desktop/deb/ any main" > /etc/apt/sources.list.d/mwt-desktop.list'
    sudo apt update
    sudo apt install -y github-desktop
    addToDock github-desktop.desktop
  fi

  if [[ "$i" == '"SYNCTHING"' ]]; then
    chmod +x ./scripts/syncthing.sh
    ./scripts/syncthing.sh
  fi

  if [[ "$i" == '"STEAM"' ]]; then
    sudo snap install steam
    addToDock steam_steam.desktop
  fi

  # if [[ "$i" == '"LUTRIS"' ]]; then
  #   # see https://github.com/lutris/lutris/releases
  #   latest_deb_url=$(wget -q -O - https://api.github.com/repos/lutris/lutris/releases/latest  |  jq -r '.assets[] | select(.name | contains ("deb")) | .browser_download_url')
  #   echo $latest_deb_url
  #   wget $latest_deb_url -O /tmp/lutris.deb
  #   chmod +x /tmp/lutris.deb
  #   sudo dpkg -i /tmp/lutris.deb
  #   rm /tmp/lutris.deb
  #   sudo apt --fix-broken -y install
  # fi

  if [[ "$i" == '"LUTRIS"' ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub net.lutris.Lutris
    addToDock net.lutris.Lutris.desktop
  fi

  # if [[ "$i" == '"GPT4ALL"' ]]; then
  #   # see https://gpt4all.io/
  #   wget https://gpt4all.io/installers/gpt4all-installer-linux.run -O /tmp/gpt4all-installer-linux.run
  #   chmod +x /tmp/gpt4all-installer-linux.run
  #   /tmp/gpt4all-installer-linux.run
  #   rm /tmp/gpt4all-installer-linux.run
  #   mv ~/Desktop/GPT4All.desktop ~/.local/share/applications/GPT4All.desktop
  #   chmod +x ~/.local/share/applications/GPT4All.desktop
  #   addToDock GPT4All.desktop
  # fi
  if [[ "$i" == '"GPT4ALL"' ]]; then
    sudo apt install -y flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install -y flathub io.gpt4all.gpt4all
    addToDock io.gpt4all.gpt4all.desktop
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
    sudo cp /usr/share/icons/hicolor/0x0/apps/pinokio.png /usr/share/icons/hicolor/256x256/apps/pinokio.png
    addToDock pinokio.desktop
  fi

  # https://protonvpn.com/support/official-linux-vpn-ubuntu/
  if [[ "$i" == '"PROTONVPN"' ]]; then
    wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.8_all.deb -O /tmp/protonvpn.deb
    sudo dpkg -i /tmp/protonvpn.deb
    rm /tmp/protonvpn.deb
#     sudo cat <<'EOF' > /etc/apt/sources.list.d/protonvpn-stable.sources
# Types: deb
# URIs: https://repo.protonvpn.com/debian
# Suites: stable
# Components: main
# Signed-By: /usr/share/keyrings/protonvpn-stable-archive-keyring.gpg
# EOF
    sudo apt update
    sudo apt install -y proton-vpn-gnome-desktop
    addToDock proton.vpn.app.gtk.desktop
  fi

  if [[ "$i" == '"DARK"' ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  fi

  if [[ "$i" == '"DOCKBOTTOM"' ]]; then
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' # default 'LEFT'
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32 # default 48 px

    addToDock org.gnome.Calculator.desktop # add calc to dock
    addToDock org.gnome.Ptyxis.desktop # add terminal to dock
  fi

  if [[ "$i" == '"WIDEWALLPAPER"' ]]; then
    gsettings set org.gnome.desktop.background picture-options 'spanned' # default 'zoom'
  fi

  if [[ "$i" == '"FASTBLINK"' ]]; then
    gsettings set org.gnome.desktop.interface cursor-blink-time 200 # default 1200 millis
    gsettings set org.gnome.desktop.interface cursor-blink-timeout 120 # default 10 seconds
  fi

  if [[ "$i" == '"HIDEHOME"' ]]; then
    gsettings set org.gnome.shell.extensions.ding show-home false # default true
  fi

  if [[ "$i" == '"BLUETOOTHOFF"' ]]; then
    sudo sed -i "s/#AutoEnable=true/AutoEnable=false/" /etc/bluetooth/main.conf
  fi

  # swapfile manager
  # /tmp as tmpfs manager

  if [[ "$i" == '"RMDOCS"' ]]; then
    rmdir ~/Documents
    sed -i "/Documents/d" ~/.config/gtk-3.0/bookmarks
  fi

  if [[ "$i" == '"RMMUSIC"' ]]; then
    rmdir ~/Music
    sed -i "/Music/d" ~/.config/gtk-3.0/bookmarks
  fi

  if [[ "$i" == '"RMPICTURES"' ]]; then
    rmdir ~/Pictures
    sed -i "/Pictures/d" ~/.config/gtk-3.0/bookmarks
  fi

  if [[ "$i" == '"RMPUBLIC"' ]]; then
    rmdir ~/Public
  fi

  if [[ "$i" == '"RMTEMPLATES"' ]]; then
    rmdir ~/Templates
  fi

  if [[ "$i" == '"RMVIDEOS"' ]]; then
    rmdir ~/Videos
    sed -i "/Videos/d" ~/.config/gtk-3.0/bookmarks
  fi

  echo

  sleep 1
done

log "Done."
echo "Press any key to exit..."
echo
read -rsn1 -p ""
