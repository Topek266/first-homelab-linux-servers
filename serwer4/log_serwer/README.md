# Log Server

## Cel
Usługa syslog-ng zbiera logi se wszystkich serwerów na serwer centralny, aby nie przemieszczać się z serwera na serwer.
Dzięki temu łatwiej monitorować działanie usług, analizować błędy oraz przygotować środowisko pod Prometheus i Grafanę.

## Schemat działania
```
Serwer1----\
Serwer2-----> Serwer4
Serwer3----/
```

## Instalacja usługi
Zainstaluj usługę `syslog-ng` na wszystkich serwerach i sprawdź czy usługa jest aktywna.
```bash
sudo apt update
sudo apt install syslog-ng -y
```

## Utworzenie katalogu na zebrane logi i nadanie uprawnień
```bash
sudo mkdir -p /var/log/central_log
```
```bash
sudo find /var/log/central -type d --exec chmod 750 {} \;
sudo find /var/log/central -type f --exec chmod 640 {} \;
```

Plik konfiguracyjny:
`/etc/syslog-ng/syslog-ng.conf`
[serwer4](/serwer4/log_serwer/konfiguracje)

## Krótki opis konfiguracji

1) Serwer4 (Log serwer)
- nasłuchuje w całej podsieci na porcie 514
- używa protokułu TCP
- jeżeli nie ma katalogu, tworzy go automatycznie
- za pomocą zmiennej `${HOST}` tworzy katalog nazwy hosta z jakiego otrzymał logi
- za pomocą zmiennej `${PROGRAM:-unknow}` tworzy plik o nazwie programu z jakiego pochodzą logi, a jeżeli nie może rozpoznać usługi, logi zapisuje do pliku unknow

2) Pozostałe serwery
- wysyła logi na adres IP serwera logów
- używa protokołu TCP i portu 514

## Logrotate, opis konfiguracji

Do automatycznego zarządzania logami wykorzystuje `logrotate`.

Plik konfiguracyjny:
`/etc/logrotate.d/central-syslog`
[serwer4](/serwer4/log_serwer/konfiguracje/serwer4)
Konfiguracja:
- wykonuje rotację logów raz dziennie
- kompresuje stare logi
- nie obraca pustych plików
- tworzy nowe pliki z odpowiednimi uprawnieniami (`640`, `root:adm`)
