# norgeous' Ubuntu setup

text here

## System Updates...

### Update system software package lists

TODO: does `snap refresh` actually perform the upgrade also?

```sh
sudo apt update
sudo snap refresh
```

### Upgrade system software

```sh
sudo apt upgrade -y

# not sure if this part is needed, but it's from https://askubuntu.com/a/761719
snap list | awk -F" " '{if ($1 && NR>1) { system("sudo snap refresh " $1) }}'
```

### Autoremove packages

```sh
sudo apt autoremove
```

### Remove Ubuntu bloat

```sh
sudo apt remove deja-dup rhythmbox cheese totem
sudo snap remove thunderbird cups
```

### Disable Wayland

This makes the Ubuntu UI much faster

```sh
FIND="#WaylandEnable=false"
FILE="/etc/gdm3/custom.conf"
sudo sed -i "/$FIND/s/^#//" "$FILE" # uncomment line
```

## Install Software...

### MPV

TODO: set mpv.conf and input.conf

```sh
sudo apt install -y mpv
```

### GIMP (snap)

```sh
sudo snap install gimp
```

### InkScape (snap)

```sh
sudo snap install inkscape
```

### Blender (snap)

```sh
sudo snap install blender
```

### tj/n

```sh
chmod +x ./scripts/tj_n.sh
./scripts/tj_n.sh
```

### VSCode (snap)

```sh
sudo snap install code --classic
```

### Github Desktop

from https://github.com/shiftkey/desktop

TODO: this is breaking apt upgrade at the moment due to SSL expired / wrong on https://shiftkey.dev

```sh
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
sudo apt update
sudo apt install github-desktop
```

### KeepassXC

```sh
sudo apt install -y keepassxc
```

### Syncthing

```sh
chmod +x ./scripts/syncthing.sh
./scripts/syncthing.sh
```

### Lutris (for Steam, Epic, EA, Ubisoft, GOG)

see https://github.com/lutris/lutris/releases for updates

```sh
url=https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb
wget $url -O /tmp/lutris.deb
chmod +x /tmp/lutris.deb
sudo dpkg -i /tmp/lutris.deb
rm /tmp/lutris.deb
```

### gpt4all

https://gpt4all.io

TODO: .desktop link appears to install to ~/Desktop, and doesnt appear in dock in Ubuntu 24.04

```sh
url=https://gpt4all.io/installers/gpt4all-installer-linux.run
wget $url -O /tmp/gpt4all-installer-linux.run
chmod +x /tmp/gpt4all-installer-linux.run
/tmp/gpt4all-installer-linux.run
rm /tmp/gpt4all-installer-linux.run
```

### pinokio.computer

see https://github.com/pinokiocomputer/pinokio/releases for updates

```sh
url=https://github.com/pinokiocomputer/pinokio/releases/download/2.15.1/Pinokio_2.15.1_amd64.deb
wget $url -O /tmp/pinokio.deb
chmod +x /tmp/pinokio.deb
sudo dpkg -i /tmp/pinokio.deb
rm /tmp/pinokio.deb

# fix the .desktop link file icon, as it seems to be broken
path1=/usr/share/icons/hicolor/0x0/apps/pinokio.png
path2=/home/user/.local/share/icons/hicolor/256x256/apps/pinokio.png
cp $path1 $path2
```

## Remove items from Nautillus (Files) sidebar...

### Remove Documents

```sh
FIND="XDG_DOCUMENTS_DIR="
FILE="$HOME/.config/user-dirs.dirs"
sed -i "/$FIND/s/^/#/" "$FILE" # comment out line

FIND="DOCUMENTS="
FILE="/etc/xdg/user-dirs.defaults"
sudo sed -i "/$FIND/s/^/#/" "$FILE" # comment out line
```

### Remove Music

```sh
sudo commentOut "XDG_MUSIC_DIR=" "$HOME/.config/user-dirs.dirs"
sudo commentOut "MUSIC=" "/etc/xdg/user-dirs.defaults"
```

### Remove Pictures

```sh
sudo commentOut "XDG_PICTURES_DIR=" "$HOME/.config/user-dirs.dirs"
sudo commentOut "PICTURES=" "/etc/xdg/user-dirs.defaults"
```

### Remove Videos

```sh
sudo commentOut "XDG_VIDEOS_DIR=" "$HOME/.config/user-dirs.dirs"
sudo commentOut "VIDEOS=" "/etc/xdg/user-dirs.defaults"
```
