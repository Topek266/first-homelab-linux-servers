# Node Exporter

## Cel 
Node Exporter udostępnia metryki systemowe (CPU, RAM, dyski, sieć, system plików itp.) na porcie 9100, dzięki czemu Prometheus może je cyklicznie pobierać i zapisywać.

**Node Exporter instalujemy na każdym serwerze.**

---

## Schemat działania

+------------------+
|   Node Exporter  |
+------------------+ 
         |
+------------------+
|    Prometheus    |
+------------------+
         |
+------------------+
|     Grafana     |
+------------------+

---

## Tworzenie użytkownika

Użytkownik bez katalogu domowego i bez możliwości zalogowania się na niego
```bash
sudo useradd -M -s /usr/sbin/nologin node_exporter
```

---

## Pobranie i rozpakowanie Node Exporter

Przejdź do katalogu `/tmp`:
```bash
cd /tmp
```

Pobierz archiwum z oficjalnego repozytorium:
```bash
wget https://github.com/prometheus/node_exporter/releases/download/v1.11.1/node_exporter-1.11.1.linux-amd64.tar.gz
```

Rozpakowanie:
```bash
tar -xvf node_exporter-1.11.1.linux-amd64.tar.gz
```

---

## Przeniesienie Node Exporter i uprawnienia

Przeniesienie Node Exporter:
```bash
sudo mv /tmp/node_exporter-1.11.1.linux-amd64/node_exporter /usr/local/bin
```

Nadanie właściciela:
```bash
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
```

---

## Uruchomienie

Uruchomienie:
```bash
/usr/local/bin/node_exporter
```
Ostatnia linia powinna pokazać :9100 czyli nasłuchuje na porcie 9100.

---

## Ustawienie Systemd
```bash
sudo nano /etc/systemd/system/node_export.service
```

Plik konfiguracyjny znajduje się w tym samym katalogu co ten bieżący plik.
Plik został opisany komentarzami wyjaśniającymi znaczenie każdej lini.

Wczytanie, uruchomienie i automatyczny start:
```bash
sudo systemctl daemon-reload
```
```bash
sudo systemctl start node_exporter
```
```bash
sudo systemctl enable node_exporter
```

Sprawdzenie logów:
```bash
journalctl -u node_exporter
```

## Weryfikacja działania

Sprawdzenie statusu:
```bash
sudo systemctl status node_exporter
```

Sprawdzenie czy działa lokalnie:
```bash
curl http://localhost:9100/metrics
```
Powinno wyświetlić mnóstwo metryk ale jeszcze nieczytelnych.

Sprawdzenie czy nasłuchuje na porcie 9100:
```bash
sudo ss -tulnp | grep 9100
```


## Efekt końcowy
Po wykonaniu tych kroków Node Exporter:
- działa jako usługa w systemd
- uruchamia się automatycznie po starcie sieci
- nasłuchuje na porcie 9100
- pobiera metryki z systemu i udostępnia je na porcie 9100

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Brak odpowiedzi pod adresem `:9100/metrics` | Polecenie `curl` nie zwraca metryk. | Usługa `node_exporter` nie została uruchomiona. | Sprawdź status usługi i uruchom ją poleceniem `sudo systemctl start node_exporter`. |
| `wget` nie pobiera pliku | Pobieranie kończy się błędem. | Użyto niepoprawnego adresu URL zawierającego znak `*`. | Pobierz plik z pełnym adresem URL odpowiadającym wersji Node Exporter. |
| Node Exporter nie uruchamia się po restarcie systemu | Po ponownym uruchomieniu systemu usługa nie działa. | Usługa nie została dodana do autostartu. | Wykonaj `sudo systemctl enable node_exporter`. |
