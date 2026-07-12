# Samba Server

## Cel
Podstawowa konfiguracja serwera plików Samba do udostępniania plików.
Testy przeprowadzone z klienta Ubuntu Server przy użyciu smbclient.
Protokół SMB jest preferowany dla Windows, jednak dostępny również na systemach Linux.

---

## Instalacja
```bash
sudo apt install samba -y
```

---

## Tworzenie katalogów i uprawnienia
Publiczny:
```bash
sudo mkdir -p /srv/share/samba/public
```
```bash
sudo chmod 777 /srv/share/samba/public
```

Prywatny:
```bash
sudo mkdir -p /srv/share/samba/private
```
```bash
sudo chmod 770 /srv/share/samba/private
```
```bash
sudo chown klientsmb:klientsmb /srv/share/samba/private
```

---

## Utworzenie użytkownika

Użytkownik bez katalogu domowego i bez możliwości logowania:
```bash
sudo useradd -M -s /sbin/nologin klientsmb
```

Dodanie użytkownika do bazy danych Samby:
```bash
sudo smbpasswd -a klientsmb
```

Akceptacja użytkownika w bazie danych Samba:
```bash
sudo smbpasswd -e klientsmb
```

---

## Krótki opis konfiguracji

Konfiguracja znajduje się w tym samym katalogu co README.

Edytuj plik konfiguracyjny:
```bash
sudo nano /etc/samba/smb.conf
```

Samba ma dwa udziały, 1) publiczny , 2) prywatny
  1) publiczny
  - jest widoczny dla klientów.
  - jest on bez hasła.
  - wymusza że wszyscy logują się jako gość, nawet jak ktoś poda login i hasło to potraktuje go jako gość.
  - z użytkownika i grupy nobody będą wrzucane pliki w celu uniknięcia problemów z uprawnieniami.

  2) prywatny
  - jest niewidoczny dla klientów ale można się z nim połączyć.
  - trzeba podać hasło, aby się połączyć.
  - tylko użytkownik klientsmb może się połączyć.
  - z użytkownika i grupy klientsmb będą wrzucane pliki w celu uniknięcia problemów z uprawnienia.
  - wymusza uprawnienia dodawanych plików i katalogów ustawionych w pliku konfiguracyjnym, niezależnie od klienta.

## Weryfikacja działania

Sprawdzenie poprawności konfiguracji:
```bash
testparm
```

Restart i status usługi
```bash
sudo systemctl restart smbd nmbd
sudo systemctl status smbd
```

Sprawdzenie czy usługa nasłuchuje na porcie 445:
```bash
sudo ss -tulnp | grep 445
```

Wyświetl dostępne udziały:
```bash
sudo smbclient -L localhost -U smbclient
```

Sprawdziłem na kliencie z Windows 10 dostęp do udziału:
```
\\192.168.66.2\public
```


Testy znajdują się w katalogu [hosts](/hosts/serwer2)

## Efekt końcowy

Po wykonaniu wszystkich kroków serwer samba:
- udostępnia katalogi do sieci
- umożliwia dostęp do udziałów zgodnie z konfiguracją
- uwierzytelnia użytkowników przy użyciu konta samby
- pozwala na odczyt i zapis plików z kompóterów klienckich
- umożliwia współdzielenie plików pomiędzy systemami Linux i Windows

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| `NT_STATUS_ACCESS_DENIED` | Odmowa dostępu podczas łączenia z udziałem. | Niepoprawne dane logowania, brak użytkownika w bazie Samby lub błędne uprawnienia. | Sprawdź użytkownika (`pdbedit -L`), włącz konto (`smbpasswd -e`) oraz zweryfikuj uprawnienia katalogu. |
| `NT_STATUS_BAD_NETWORK_NAME` | Udział nie jest widoczny lub nie istnieje. | Literówka w nazwie udziału lub błąd konfiguracji `smb.conf`. | Sprawdź konfigurację (`testparm`) i zrestartuj usługę `smbd`. |
| Brak połączenia z serwerem Samba | Klient nie może połączyć się z serwerem. | Usługa `smbd` nie działa, brak łączności sieciowej lub port 445 jest niedostępny. | Sprawdź status usługi, łączność (`ping`) oraz nasłuchiwanie na porcie 445. |
| Brak uprawnień do zapisu | Możliwy jest odczyt plików, ale zapis kończy się błędem. | Niepoprawne uprawnienia katalogu lub konfiguracja udziału. | Zweryfikuj `chmod`, `chown` oraz ustawienia udziału w `smb.conf`. |
| Zmiany w `smb.conf` nie są widoczne | Modyfikacje konfiguracji nie działają. | Usługa Samba nie została zrestartowana po zmianach. | Sprawdź konfigurację poleceniem `testparm` i uruchom ponownie usługę `smbd`. |
