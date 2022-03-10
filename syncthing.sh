#!/bin/bash
[[ $EUID -ne 0 ]] && echo "You must be running as user root." && exit 1

# https://apt.syncthing.net/
curl -s -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | tee /etc/apt/sources.list.d/syncthing.list
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list
apt update
apt install -y syncthing

# autostart syncthing on boot with systemd
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

# add syncthing desktop shortcut
mkdir /usr/share/syncthing
curl -o /usr/share/syncthing/syncthing.svg https://raw.githubusercontent.com/syncthing/syncthing/master/assets/logo-only.svg
cat <<'EOF' > /usr/share/applications/syncthing.desktop
[Desktop Entry]
Name=Syncthing
Categories=Network;Utility;
Exec=open http://127.0.0.1:8384/
Icon=/usr/share/syncthing/syncthing.svg
StartupNotify=true
Terminal=false
Type=Application
EOF

systemctl enable syncthing
systemctl start syncthing
