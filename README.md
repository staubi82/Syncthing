
### Syncthing auf Debian installieren und konfigurieren

#### 1. Syncthing Installations-Skript herunterladen und ausführen

Um Syncthing auf Debian zu installieren und zu konfigurieren, führen Sie das folgende Skript aus. Es erledigt alle notwendigen Schritte automatisch:

```bash
bash -c "$(wget -qO- https://raw.githubusercontent.com/staubi82/syncthing-install-script/main/install_syncthing.sh)"
```

#### 2. Manuelle Schritte zur Installation und Konfiguration

Falls Sie die Schritte manuell durchführen möchten, finden Sie hier die detaillierte Anleitung:

##### a. Paketquellen und Schlüssel hinzufügen

Aktualisieren Sie die Paketliste und installieren Sie benötigte Pakete:

```bash
apt-get update
apt-get upgrade -y
apt-get install gnupg2 wget apt-transport-https -y
```

##### b. Syncthing Repository hinzufügen

Fügen Sie den GPG-Schlüssel für das Syncthing-Repository hinzu und aktualisieren Sie die Paketquellen:

```bash
wget -qO- https://syncthing.net/release-key.txt | apt-key add -
echo "deb https://apt.syncthing.net/ syncthing release" > /etc/apt/sources.list.d/syncthing.list
apt-get update -y
```

##### c. Syncthing installieren

Installieren Sie Syncthing auf dem System:

```bash
apt-get install syncthing -y
```

##### d. Benutzer `syncthing` erstellen

Erstellen Sie einen separaten Benutzer `syncthing` für den sicheren Betrieb von Syncthing:

```bash
adduser --system --group --disabled-password --home /home/syncthing --shell /bin/bash syncthing
```

##### e. Syncthing Dienst konfigurieren

Erstellen Sie die systemd-Servicekonfigurationsdatei für Syncthing:

```bash
nano /etc/systemd/system/syncthing@.service
```

Fügen Sie den folgenden Inhalt ein:

```bash
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
```

##### f. systemd Dienst aktualisieren und Syncthing starten

Laden Sie die aktualisierte systemd-Konfiguration und starten Sie den Syncthing-Dienst:

```bash
systemctl daemon-reload
systemctl start syncthing@syncthing
systemctl status syncthing@syncthing
```

#### 3. Zugriff auf das Syncthing Webinterface

Öffnen Sie Ihren Webbrowser und gehen Sie zur Adresse

```http
http://[Ihre-IP]:8384
```

Die IP-Adresse des Servers wird am Ende der Installation im Skript angezeigt.
