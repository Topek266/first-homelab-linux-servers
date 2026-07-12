# Log Server

## Cel
Usługa syslog-ng zbiera logi se wszystkich serwerów na serwer centralny, aby nie przemieszczać się z serwera na serwer.
Dzięki temu łatwiej monitorować działanie usług, analizować błędy oraz przygotować środowisko pod Prometheus i Grafanę.

---

## Schemat działania

+
|   Serwer1   |--\
+-------------+    \
+-------------+      \    +-------------+
|   Serwer2   |-----------|   Serwer4   |
+-------------+      /    +-------------+
+-------------+    /
|   Serwer3   |--/
+-------------+

---

## Instalacja
Zainstaluj usługę `syslog-ng` na wszystkich serwerach i sprawdź czy usługa jest aktywna.

Zaaktualizuj system:
```bash
sudo apt update
```

Instalacja syslog-ng:
```bash
sudo apt install syslog-ng -y
```

---

## Utworzenie katalogu
Utworzenie katalogu na zebrane logi:
```bash
sudo mkdir -p /var/log/central_log
```

Nadanie uprawnień katalogowi:
```bash
sudo find /var/log/central -type d --exec chmod 750 {} \;
```

Nadanie uprawnień plikowi
```bash
sudo find /var/log/central -type f --exec chmod 640 {} \;
```

---

## Konfiguracja syslog-ng

Edytuj plik:
```bash
sudo nano /etc/syslog-ng/syslog-ng.conf
```

**Plik konfiguracyjny usługi znajduje się w tym samym katalogu co README, w katalogu "konfiguracje""**

1) Serwer4 (Log serwer)
- nasłuchuje w całej podsieci na porcie 514
- używa protokułu TCP
- jeżeli nie ma katalogu, tworzy go automatycznie
- za pomocą zmiennej `${HOST}` tworzy katalog nazwy hosta z jakiego otrzymał logi
- za pomocą zmiennej `${PROGRAM:-unknow}` tworzy plik o nazwie programu z jakiego pochodzą logi, a jeżeli nie może rozpoznać usługi, logi zapisuje do pliku unknow

2) Pozostałe serwery
- wysyła logi na adres IP serwera4
- używa protokołu TCP i portu 514

Automatyczny start:
```bash
sudo systemctl enable syslog-ng
```

---

## Logrotate, opis konfiguracji

Do automatycznego zarządzania logami wykorzystuje `logrotate`.

Utwórz plik:
```bash
sudo nano /etc/logrotate.d/central-syslog
```

Opis konfiguracji:
- wykonuje rotację logów raz dziennie
- kompresuje stare logi
- nie obraca pustych plików
- tworzy nowe pliki z odpowiednimi uprawnieniami (`640`, `root:adm`)

---

## Weryfikacja działania

Sprawdź status syslog-ng:
```bash
sudo systemctl status syslog-ng
```

Sprawdź status logrotate:
```bash
sudo systemctl status logrotate
```

Sprawdź poprawność konfiguracji syslog-ng:
```bash
sudo syslog-ng --syntax-only
```

Sprawdź czy serwer4 odbiera logi z pozostałych serwerów:
```bash
ls -R /var/log/central
```

Sprawdź poprawność konfiguracji logrotate:
```bash
sudo logrotate -d /etc/logrotate.conf
```

Wymuś rotację logów:
```bash
sudo logrotate -f /etc/logrotate.conf
```

---

## Efekt końcowy

Po wykonaniu tych kroków syslog-ng i logrotate:
- Uruchamia się automatycznie po starcie systemu
- działa na porcie 514
- wysyła wszystkie logi do serwer4
- odrazu wiadomo z jakiego serweras są logi i z jakiego programu
- automatycznie tworzy katalogi jeżeli ich nie ma
- posiada zautomatyzowaną rotację logów\

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Serwer nie odbiera logów | W katalogu `/var/log/remote` nie pojawiają się nowe wpisy. | Klient nie wysyła logów lub błędnie skonfigurowano adres serwera. | Sprawdź konfigurację klienta oraz poprawność wpisów w `syslog-ng.conf`. |
| Błąd konfiguracji `syslog-ng` | Usługa nie uruchamia się. | Błąd składni w pliku konfiguracyjnym. | Zweryfikuj konfigurację poleceniem `sudo syslog-ng --syntax-only` i popraw błędy. |
| Logi zapisywane są pod adresem IP zamiast nazwą hosta | Tworzone katalogi mają nazwy adresów IP. | Serwer otrzymuje adres IP zamiast nazwy hosta lub nie użyto odpowiedniej opcji w konfiguracji. | Skonfiguruj przesyłanie nazwy hosta (`keep-hostname(yes)`) oraz upewnij się, że klient wysyła nazwę hosta. |
| Rotacja logów nie działa | Pliki logów stale rosną i nie są archiwizowane. | Niepoprawna konfiguracja `logrotate` lub brak wymuszenia rotacji. | Zweryfikuj konfigurację (`logrotate -d`) i przetestuj ją poleceniem `logrotate -f`. |
| Brak uprawnień do zapisu logów | Logi nie są tworzone w katalogu docelowym. | Niepoprawne uprawnienia do katalogu lub plików logów. | Sprawdź właściciela oraz uprawnienia katalogu docelowego i nadaj odpowiednie prawa dostępu. |
