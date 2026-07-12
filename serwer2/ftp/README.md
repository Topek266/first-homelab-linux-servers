# FTP Server

## Cel
Podstawowa konfiguracja serwera FTP do udostępniania plików z wykorzystaniem vsftpd.
Serwer obsługuje zarówno dostęp publiczny (anonymous), jak i użytkowników lokalnych.

---

## Instalacja
```bash
sudo apt install vsftpd -y
```

---

## Utworzenie użytkownika
Utworzenie użytkownika z katalogiem domowym i z powłoką bash:
```bash
sudo useradd -m -s /bin/bash ftpuser
```

Nadanie hasła:
```bash
sudo passwd ftpuser
```

## Tworzenie katalogów i uprawnienia
**Publiczny**

Tworzenie katalogu:
```bash
sudo mkdir -p /srv/share/ftp/public
```

Zmiana właściciela:
```bash
sudo chown root:root /srv/share/ftp/public
```

Zmiana uprawnień:
```bash
sudo chmod 755 /srv/share/ftp/public
```

**Prywatny**

Tworzenie katalogu:
```bash
sudo mkdir -p /srv/share/ftp/private
```

Zmiana właściciela:
```bash
sudo chown ftpuser:ftpuser /srv/share/ftp/private
```

Zmiana uprawnień
```bash
sudo chmod 750 /srv/share/ftp/private
```

---

## konfiguracja

Pełny plik konfiguracyjny znajduje się w tym samym katalogu co README.

Edytuj plik:
```bash
sudo nano /etc/vsftpd.conf
```

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

Restart usługi:
```bash
sudo systemctl restart vsftpd
```

---

## Weryfikacja działania

Sprawdzenie statusu usługi:
```bash
sudo systemctl status vsftpd
```

Sprawdzenie poprawności pliku konfiguracyjnego:
```bash
sudo vsftpd /etc/vsftpd.conf
```

Sprawdź czy nasłuchuje na porcie 21:
```bash
sudo ss -tulnp | grep 21
```

Sprawdź czy FTP działa:
```bash
ftp 192.168.66.2
```

## Efekt końcowy
- działająca usługa vsftpd na porcie 21
- podział na typ publiczny i prywatny
- podstawowe zabezpieczenie od strony konfiguracji
- brak szyfrowania ponieważ jeszcze nie czuję że rozumiem certyfikacje, więc nie chciałem na ślepo wpisywać poleceń

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| `500 OOPS: missing value in config file` | Usługa nie uruchamia się i zgłasza błąd konfiguracji. | Niepoprawny wpis lub błędna składnia w pliku `vsftpd.conf`. | Sprawdź konfigurację i popraw błędne linie w pliku. |
| `500 OOPS: vsftpd: refusing to run with writable root inside chroot` | Użytkownik nie może się zalogować do serwera FTP. | Włączono `chroot_local_user=YES`, ale nie ustawiono `allow_writeable_chroot=YES`. | Dodaj `allow_writeable_chroot=YES` do pliku `vsftpd.conf` i uruchom ponownie usługę. |
| `status=2/INVALIDARGUMENT` | Usługa `vsftpd` nie uruchamia się. | Jednocześnie włączono `listen=YES` i `listen_ipv6=YES`. | Ustaw `listen=YES` oraz `listen_ipv6=NO` i sprawdź konfigurację poleceniem `sudo vsftpd /etc/vsftpd.conf`. |
| `530 Login incorrect` | Logowanie do serwera FTP kończy się niepowodzeniem. | Niepoprawne dane logowania, brak użytkownika lub użytkownik znajduje się w pliku `/etc/ftpusers`. | Zweryfikuj konto użytkownika oraz sprawdź zawartość pliku `/etc/ftpusers`. |
| Brak widocznych plików po zalogowaniu | Połączenie z serwerem działa, ale katalog jest pusty. | Niepoprawna wartość `anon_root` lub brak plików w katalogu udostępnionym przez FTP. | Sprawdź konfigurację `anon_root` oraz zawartość katalogu udostępnianego przez serwer FTP. |
