# Samba Server

## Cel
Podstawowa konfiguracja serwera plików Samba do udostępniania plików.
Testy przeprowadzone z klienta Ubuntu Server przy użyciu smbclient.
Protokół SMB jest preferowany dla Windows, jednak dostępny również na systemach Linux

## Plik konfiguracyjny
- `/etc/samba/smb.conf`

## Konfiguracja użytkownika
- Utworzenie użytkownika systemowego: `sudo useradd -M -s /sbin/nologin klientsmb`
- Dodanie użytkownika do bazy danych Samba: `sudo smbpasswd -a klientsmb`
- Aktywacja użytkownika w bazie danych Samba: `sudo smbpasswd -e klientsmb`

## Krótki opis konfiguracji
Samba ma dwa udziały, 1) publiczny , 2) prywatny
  1) publiczny
  - jest widoczny dla klientów
  - jest on bez hasła
  - wymusza że wszyscy logują się jako gość, nawet jak ktoś poda login i hasło to potraktuje go jako gość
  - z użytkownika i grupy nobody będą wrzucane pliki w celu uniknięcia problemów z uprawnieniami
  - uprawnienia katalogu: chmod 777 

  2) prywatny
  - jest niewidoczny dla klientów ale można się z nim połączyć
  - trzeba podać hasło, aby się połączyć
  - tylko użytkownik klientsmb może się połączyć 
  - z użytkownika i grupy klientsmb będą wrzucane pliki w celu uniknięcia problemów z uprawnienia
  - uprawnienia katalogu: `chmod 770`, właściciel: `chown klientsmb:klientsmb`
  - wymusza uprawnienia dodawanych plików i katalogów ustawionych w pliku konfiguracyjnym, niezależnie od klienta

## Sprawdzenie poprawności konfiguracji, restart usługi i sprawdzenie statusu

```bash
testparm
sudo systemctl restart smbd nmbd
sudo systemctl status smbd
```

## Testy na kliencie

Testy znajdują się w katalogu hosts







