#!/bin/bash
[[ $EUID -ne 0 ]] && echo "You must be running as user root." && exit 1

curl -s https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
apt update

apt install -y syncthing xmlstarlet
cat <<'EOF' > /etc/systemd/system/syncthing.service
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization
Documentation=man:syncthing(1)
After=network.target
Wants=syncthing-inotify@.service
[Service]
User=pi
ExecStart=/usr/bin/syncthing -no-browser -no-restart -logflags=0
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4
[Install]
WantedBy=multi-user.target
EOF
mkdir /usr/share/syncthing
curl -o /usr/share/syncthing/syncthing.svg https://raw.githubusercontent.com/syncthing/syncthing/master/assets/logo-only.svg
cat <<'EOF' > /usr/share/applications/syncthing.desktop
[Desktop Entry]
Name=Syncthing
Categories=Network;Utility;
Exec=chromium-browser http://127.0.0.1:8384/
Icon=/usr/share/syncthing/syncthing.svg
StartupNotify=true
Terminal=false
Type=Application
EOF
systemctl enable syncthing
systemctl start syncthing
sleep 40
systemctl stop syncthing
rm -r /home/pi/Sync
mkdir /home/pi/sync
chown pi:pi /home/pi/sync
xmlstarlet ed --inplace -d '/configuration/folder'                                          /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/options/defaultFolderPath'     -v '~/sync'       /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/gui/theme'                     -v 'black'        /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/options/startBrowser'          -v 'false'        /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/options/natEnabled'            -v 'false'        /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/options/globalAnnounceEnabled' -v 'false'        /home/pi/.config/syncthing/config.xml
xmlstarlet ed --inplace -u '/configuration/options/relaysEnabled'         -v 'false'        /home/pi/.config/syncthing/config.xml

whiptail \
  --title "Syncthing" \
  --yesno "By default the Syncthing web GUI is only available on locally, should we open the GUI for access from any host?" 15 60 \
  --yes-button "open to everyone" \
  --no-button "open locally only" \
  --defaultno \
  --scrolltext \
  && xmlstarlet ed --inplace -u '/configuration/gui/address'                -v '0.0.0.0:8384' /home/pi/.config/syncthing/config.xml

ID=$(xmlstarlet sel -t -v '/configuration/device/@id' /home/pi/.config/syncthing/config.xml)
echo
echo "###################################################################"
echo "# $ID #"
echo "###################################################################"
echo

systemctl start syncthing
