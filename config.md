# norgeous' Ubuntu setup

text here

---

## UPDATE: Update system software package lists

TODO: does `snap refresh` actually perform the upgrade also?

```sh
sudo apt update
sudo snap refresh
```

## UPGRADE: Upgrade system software

```sh
sudo apt upgrade -y

# not sure if this is needed https://askubuntu.com/a/761719
snap list | awk -F" " '{if ($1 && NR>1) { system("sudo snap refresh " $1) }}'
```

## AUTOREMOVE: Autoremove packages

```sh
sudo apt autoremove
```

## UNBLOAT: Remove Ubuntu bloat

```sh
sudo apt remove deja-dup rhythmbox cheese totem
sudo snap remove thunderbird cups
```

## MPV: Install MPV

TODO: set mpv.conf and input.conf

```sh
sudo apt install -y mpv
```

## GIMP: Install GIMP (snap)

```sh
sudo snap install gimp
```

## INKSCAPE: Install InkScape (snap)

```sh
sudo snap install inkscape
```

## BLENDER: Install Blender (snap)

```sh
sudo snap install blender
```

## NODE: Install tj/n

```sh
chmod +x ./scripts/tj_n.sh
./scripts/tj_n.sh
```

## VSCODE: Install VSCode (snap)

```sh
sudo snap install code --classic
```

## GHDESKTOP: Install Github Desktop

from https://github.com/shiftkey/desktop

TODO: this is breaking apt upgrade at the moment due to SSL expired / wrong on https://shiftkey.dev

```sh
wget -qO - https://apt.packages.shiftkey.dev/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/shiftkey-packages.gpg > /dev/null
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/shiftkey-packages.gpg] https://apt.packages.shiftkey.dev/ubuntu/ any main" > /etc/apt/sources.list.d/shiftkey-packages.list'
sudo apt update
sudo apt install github-desktop
```

## KEEPASSXC: Install KeepassXC

```sh
sudo apt install -y keepassxc
```

## SYNCTHING: Install Syncthing

```sh
chmod +x ./scripts/syncthing.sh
./scripts/syncthing.sh
```

## LUTRIS: Install Lutris (Steam, Epic, etc)

see https://github.com/lutris/lutris/releases for updates

```sh
url=https://github.com/lutris/lutris/releases/download/v0.5.18/lutris_0.5.18_all.deb
wget $url -O /tmp/lutris.deb
chmod +x /tmp/lutris.deb
sudo dpkg -i /tmp/lutris.deb
rm /tmp/lutris.deb
```

## GPT4ALL: Install gpt4all

https://gpt4all.io

TODO: .desktop link appears to install to ~/Desktop, and doesnt appear in dock in Ubuntu 24.04

```sh
url=https://gpt4all.io/installers/gpt4all-installer-linux.run
wget $url -O /tmp/gpt4all-installer-linux.run
chmod +x /tmp/gpt4all-installer-linux.run
/tmp/gpt4all-installer-linux.run
rm /tmp/gpt4all-installer-linux.run
```

## PINOKIO: Install pinokio.computer

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

## NAUTILLUS: Remove items from Nautillus (Files) sidebar

### RMDOCS: Remove Documents

```sh
commentOut "XDG_DOCUMENTS_DIR=" "$HOME/.config/user-dirs.dirs"
commentOut "DOCUMENTS=" "/etc/xdg/user-dirs.defaults"
```

### RMMUSIC: Nautillus (Files) sidebar > Remove Music

```sh
commentOut "XDG_MUSIC_DIR=" "$HOME/.config/user-dirs.dirs"
commentOut "MUSIC=" "/etc/xdg/user-dirs.defaults"
```

### RMPICTURES: Nautillus (Files) sidebar > Remove Pictures

```sh
commentOut "XDG_PICTURES_DIR=" "$HOME/.config/user-dirs.dirs"
commentOut "PICTURES=" "/etc/xdg/user-dirs.defaults"
```

### RMVIDEOS: Nautillus (Files) sidebar > Remove Videos

```sh
commentOut "XDG_VIDEOS_DIR=" "$HOME/.config/user-dirs.dirs"
commentOut "VIDEOS=" "/etc/xdg/user-dirs.defaults"
```
