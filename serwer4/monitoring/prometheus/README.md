# Prometheus

## Cel
Prometheus zbiera metryki udostępnione przez Node Exporter i zapisuje je w bazie danych. Następnie udostępnia je do wizualizacji Grafanie.

---

## Instalacja

Przejdź do katalogu `/tmp`
```bash
cd /tmp
```

Pobierz wersję Prometheus 3.5.0 z oficjalnego repozytorium:
```bash
wget https://github.com/prometheus/prometheus/releases/download/v3.5.0/prometheus-3.5.0.linux-amd64.tar.gz
```

Rozpakowanie:
```bash
tar -xvf prometheus-3.5.0.linux-amd64.tar.gz
```

---

## Dodanie rekordu do Serwera DNS

Dodaj linie w db.lab.local:
prometheus    IN    A   192.168.66.4

Następnie zwiększ serial i zrestartuj bind9

---

## Tworzenie użytkownika

Tworzymy użytkownika bez katalogu domowego i bez możliwości logowania.
```bash
sudo useradd -M -s /usr/sbin/nologin prometheus
```

---

## Przygotowanie katalogów

Utwórz katalogi na konfigurację i bazę danych.
```bash
sudo mkdir /etc/prometheus
```
```bash
sudo mkdir /var/lib/prometheus
```

Nadaj odpowiedniego właściciela.
```bash
sudo chown prometheus:prometheus /etc/prometheus
```
```bash
sudo chown prometheus:prometheus /var/lib/prometheus
```

---

## Kopiowanie plików

Przejdź do rozpakowanego katalogu.
```bash
cd prometheus-3.5.0.linux-amd64
```

Skopiuj pliki wykonalne.
```bash
sudo cp prometheus promtool /usr/local/bin/
```

Skopiuj plik konfiguracyjny.
```bash
sudo cp prometheus.yml /etc/prometheus/
```

Nadaj właściciela.
```bash
sudo chown prometheus:prometheus /usr/local/bin/prometheus
```
```bash
sudo chown prometheus:prometheus /usr/local/bin/promtool
```
```bash
sudo chown prometheus:prometheus /etc/prometheus/prometheus.yml
```

---

## Konfiguracja

Edytuj plik:
```bash
sudo nano /etc/prometheus/prometheus.yml
```

Dodajemy serwery z uruchomionym Node Exporter.
W konfiguracji zastosowałem "static_configs", ponieważ monitoruję tylko 4 serwery.

Plik konfiguracyjny z opisaniem każdej lini znajduje się w tym samym katalogu co README.

---

## Konfiguracja systemd

Utwórz usługę.
```bash
sudo nano /etc/systemd/system/prometheus.service
```

Plik konfiguracyjny usługi znajduje się w tym samym katalogu co README.

Wczytanie usługi:
```bash
sudo systemctl daemon-reload
```
```bash
sudo systemctl start prometheus
```
```bash
sudo systemctl enable prometheus
```

---

## Weryfikacja działania

Status usługi:
```bash
sudo systemctl status prometheus
```

Sprawdzenie czy usługa nasłuchuje na porcie 9090:
```bash
sudo ss -tulnp | grep 9090
```

Sprawdzenie poprawności konfiguracji:
```bash
promtool check config /etc/prometheus/prometheus.yml
```

Sprawdzenie czy DNS rozwiązuje nazwę:
```bash
nslookup prometheus
```

### Testy z klienta (Windows 10)

Sprawdzenie strony WWW:
```
http://192.168.66.4:9090
```

Sprawdzenie targetów:
**Status --> Target Health**

Wszystkie serwery z uruchomionym Node Exporter powinny mieć status **UP**.

## Efekt końcowy

Po wykonaniu tych kroków Prometheus:

- działa jako usługa systemd
- uruchamia się automatycznie po starcie sieci
- nasłuchuje na porcie 9090
- pobiera metryki z Node Exporter
- udostępnia dane do Grafany

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Błąd konfiguracji `prometheus.yml` | Usługa nie uruchamia się. | Niepoprawna składnia pliku konfiguracyjnego. | Zweryfikuj konfigurację poleceniem `promtool check config` i popraw błędy. |
| Brak połączenia z Node Exporter | Target posiada status **DOWN**. | Niepoprawny adres IP, port lub usługa `node_exporter` nie działa. | Sprawdź adres targetu oraz status usługi `node_exporter`. |
| Brak katalogów `consoles` i `console_libraries` | Podczas kopiowania plików pojawia się komunikat o braku katalogów. | W używanej wersji Prometheus katalogi nie są dostarczane lub nie są wymagane. | Pomiń ten krok i kontynuuj konfigurację. |
| Brak dostępu do interfejsu WWW | Strona `http://adres_IP:9090` nie otwiera się. | Usługa nie działa lub port 9090 nie jest dostępny. | Sprawdź status usługi oraz nasłuchiwanie na porcie 9090. |
| Target posiada status `DOWN` | Prometheus nie zbiera metryk z hosta. | Host jest wyłączony lub nieosiągalny. | Uruchom monitorowany host i sprawdź połączenie sieciowe. |

