#!/bin/bash

# Paketquellen aktualisieren und benötigte Pakete installieren
apt-get update
apt-get upgrade -y
apt-get install gnupg2 curl apt-transport-https -y

# Syncthing Repository hinzufügen und Paketquellen aktualisieren
curl -s https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing release" > /etc/apt/sources.list.d/syncthing.list
apt-get update -y

# Syncthing installieren
apt-get install syncthing -y

# Benutzer syncthing erstellen
adduser --system --group --disabled-password --home /home/syncthing --shell /bin/bash syncthing

# Syncthing systemd Service Datei erstellen
cat <<EOT > /etc/systemd/system/syncthing@.service
[Unit]
Description=Syncthing - Open Source Continuous File Synchronization for %i
Documentation=man:syncthing(1)
After=network.target

[Service]
User=%i
ExecStart=/usr/bin/syncthing -no-browser -gui-address="0.0.0.0:8384" -no-restart -logflags=0
Restart=on-failure
SuccessExitStatus=3 4
RestartForceExitStatus=3 4

[Install]
WantedBy=multi-user.target
EOT

# systemd daemon neu laden und Syncthing starten
systemctl daemon-reload
systemctl start syncthing@syncthing
systemctl status syncthing@syncthing
