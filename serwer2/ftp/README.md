# FTP Server

## Cel
Podstawowa konfiguracja serwera FTP do udostępniania plików z wykorzystaniem vsftpd.
Serwer obsługuje zarówno dostęp publiczny (anonymous), jak i użytkowników lokalnych.

## Plik konfiguracjny
- `/etc/vsftpd.conf`

## Utworzenie użytkownika
```bash
sudo useradd -m -s /bin/bash ftpuser
sudo passwd ftpuser
```

## Tworzenie katalogów i uprawnienia
**Publiczny**
```bash
sudo mkdir -p /srv/share/ftp/public
```
```bash
sudo chown root:root /srv/share/ftp/public
```
```bash
sudo chmod 755 /srv/share/ftp/public
```

**Prywatny**
```bash
sudo mkdir -p /srv/share/ftp/private
```
```bash
sudo chown ftpuser:ftpuser /srv/share/ftp/private
```
```bash
sudo chmod 750 /srv/share/ftp/private
```

## Krótki opis konfiguracji
Serwer FTP udostępnia dwa typy dostępu:

1) publiczny (anonymous)
- dostępny dla wszystkich użytkowników
- logowanie bez
  hasła
- katalog: /srv/share/ftp/public
- brak możliwości wrzucania plików
- brak możliwości wrzucania katalogów
- uprawnienia i właściciel:

2) prywatny (użytkownicy lokalni)
- możliwość logowania użytkowników systemowych
- wymagane hasło
- możliwość zapisu plików
- użytkownik ograniczony do swojego katalogu (chroot)
- uprawnienia i właściciel:

### Bezpieczeństwo i Sieć
- użytkownicy lokalni zamknięci w swoich katalogach (chroot)
- dostęp tylko dla wybranych użytkowników (userlist)
- ukrycie UID/GID
- anonymous bez uprawnień zapisu
- tryb pasywny (PASV) włączony
- zakres portów 10000-10100
- IPv6 wyłączony (środowisko labowe)

### Logi i komunikaty
- logowanie transferów plików
- logowanie komend i połączeń
- użycie lokalnego czasu
- obsługa komunikatorów (.message)

## Restart i Status usługi
```bash
sudo systemctl restart vsftpd
```
```bash
sudo systemctl status vsftpd
```

## Testy na kliencie
Testy znajdują się w katalogu **hosts**

