#!/bin/bash

# =============================================================================================== #
# OPIS:           Automatyczne tworzy kopie plików konfiguracyjnych uslug ze wszystkich serwerów  #
#                 przez ssh.                                                                      #
# LOKALIZACJA:    /opt/skrypty/backup.sh                                                          #
# WYMAGANIA:      1)Nadaj uprawnienia - sudo chmod -x /opt/skrypty/backup.sh                      #
#                 2)Dodanie skryptu do visudo aby nie wpisywać hasła za każdym razem.             #
#                 3)Stworzenie konfiguracji klienta SSH aby nie wpisywać nazwy urzytkownika i IP( #
#                 konfiguracja podana jest w głównym katalogu Serwer4).                           #
#                 4)Stworzenie klucza SSH i skopiowanie go na pozostale serwery.                  #
# Użycie:         /opt/skrypty/services-watchdog.sh                                               #
# =============================================================================================== #

# Zmienna z aktualnym rokiem, miesiącem i dniem
DATE=$(date +%F)

# Zmienna z katalogiem backup i aktualną datą
BACKUP_DIR="/backup/$DATE"

# Zmienna wskazująca gdzie ma zostać stworzone archiwum
ARCHIVE="/backup/backup-$DATE.tar.gz"

# Tworzenie katalogów pod backup
mkdir -p "$BACKUP_DIR/server1/bind"
mkdir -p "$BACKUP_DIR/server1/dhcp"
mkdir -p "$BACKUP_DIR/server1/apache2"
mkdir -p "$BACKUP_DIR/server1/www"
mkdir -p "$BACKUP_DIR/server1/syslog-ng"
mkdir -p "$BACKUP_DIR/server1/node_exporter"

mkdir -p "$BACKUP_DIR/server2/samba"
mkdir -p "$BACKUP_DIR/server2/nfs"
mkdir -p "$BACKUP_DIR/server2/ftp"
mkdir -p "$BACKUP_DIR/server2/syslog-ng"
mkdir -p "$BACKUP_DIR/server2/node_exporter"

mkdir -p "$BACKUP_DIR/server3/nginx"
mkdir -p "$BACKUP_DIR/server3/syslog-ng"
mkdir -p "$BACKUP_DIR/server3/node_exporter"

mkdir -p "$BACKUP_DIR/server4/prometheus"
mkdir -p "$BACKUP_DIR/server4/grafana"
mkdir -p "$BACKUP_DIR/server4/syslog-ng"
mkdir -p "$BACKUP_DIR/server4/node_exporter"

# Kopiowanie katalogow /etc
rsync -az --rsync-path="sudo rsync" backup1:/etc/bind/ \
  "$BACKUP_DIR/server1/bind"
rsync -az --rsync-path="sudo rsync" backup1:/etc/dhcp/ \
  "$BACKUP_DIR/server1/dhcp"
rsync -az backup1:/etc/apache2/ \
  "$BACKUP_DIR/server1/apache2"
rsync -az backup1:/var/www/ \
  "$BACKUP_DIR/server1/www"
rsync -az backup1:/etc/syslog-ng/ \
  "$BACKUP_DIR/server1/syslog-ng"
rsync -az backup1:/etc/systemd/system/node_exporter.service \
  "$BACKUP_DIR/server1/node_exporter"

rsync -az backup2:/etc/samba/ \
  "$BACKUP_DIR/server2/samba"
rsync -az backup2:/etc/exports \
  "$BACKUP_DIR/server2/nfs"
rsync -az backup2:/etc/vsftpd.conf \
  "$BACKUP_DIR/server2/vsftp"
rsync -az backup2:/etc/syslog-ng/ \
  "$BACKUP_DIR/server2/syslog-ng"
rsync -az backup2:/etc/systemd/system/node_exporter.service \
  "$BACKUP_DIR/server2/node_exporter"

rsync -az --rsync-path="sudo rsync" backup3:/etc/nginx/ \
  "$BACKUP_DIR/server3/nginx"
rsync -az backup3:/etc/syslog-ng/ \
  "$BACKUP_DIR/server3/syslog-ng"
rsync -az backup3:/etc/systemd/system/node_exporte.service \
  "$BACKUP_DIR/server3/node_exporter"

sudo rsync -az /etc/prometheus "$BACKUP_DIR/server4/prometheus"
sudo rsync -az /etc/grafana "$BACKUP_DIR/server4/grafana"
rsync -az /etc/syslog-ng "$BACKUP_DIR/server4/syslog-ng"
rsync -az /etc/systemd/system/node_exporter.service "$BACKUP_DIR/server4/node_exporter"

# Tworzenie archiwum
sudo tar -czf "$ARCHIVE" -C /backup "$DATE"

# Sprawdzenie czy backup przebiegl pomyslnie, jezeli nie logguje sie jako CRITICAL ERROR
if sudo tar -tzf "$ARCHIVE" >/dev/null 2>&1; then
  logger -t backup-script "Backup zakonczony pomyslnie"
  sudo rm -rf "$BACKUP_DIR"
else
  logger -t backup-script "CRITICAL_ERROR: Backup sie nie powiodl"
fi
