# Grafana

## Cel
Grafana służy do wirtualizacji danych. W projekcie wykorzystuje Prometheus jako źródło danych i umożliwia monitorowanie stanu serwerów za pomocą dashboardów.

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

## Instalacja

Pobierz oficjalne repozytorium Grafany.

Zainstaluj wymagane pakiety:
```bash
sudo apt install apt-transport-https software-properties-common -y
```

Pobierz klucz GPG repozytorium Grafany:
```bash
wget -q -O - https://apt.grafana.com/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/grafana.gpg
```

Dodaj repozytorium:
```bash
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
```

Zrób update pakietów:
```bash
sudo apt update
```

Zainstaluj Grafanę:
```bash
sudo apt install grafana -y
```

---

## Uruchomienie usługi

Uruchom Grafanę:
```bash
sudo systemctl start grafana-server
```

Włącz automatyczne uruchamianie:
```bash
sudo systemctl enable grafana-server
```

## Weryfikacja działania

Sprawdź status usługi:
```bash
sudo systemctl status grafana-server
```

Sprawdź czy Grafana nasłuchuje na porcie 3000:
```bash
sudo ss -tulnp | grep 3000
```

### Testy z klienta (Windows 10)

Otwórz przeglądarkę:
```
http://grafana:3000
```

Domyślne dane logowania:
```
Login: admin
Hasło: admin
```

Przy pierwszym logowaniu Grafana prosi o zmianę hasła, z racji tego że jest to lab pominąłem to.

---

## Wybranie źródła danych

Po zalogowaniu wybierz:
`Connections --> Data Sources --> Add data sources`

Wybierz:
`Prometheus`

W polu URL wpisz:
`http://localhost:9090`

Następnie kliknij:
`Save & Test`

Po poprawnym połączeniu zostanie wyświetlony komunikat z pomyślnym połączeniu z Prometheus.

---

## Wybranie dashboardu

Przejdź do:
Dashboards --> New --> Import

Wprowadź identyfikator dashboardu:
`11074`

Kliknij:
`Load`

Na dole wybierz:
datasource: Prometheus --> Import

---

## Efekt końcowy

Po wykonaniu wszystkich kroków Grafana:
- działa jako usługa systemd
- uruchamia się automatycznie po starcie sieci
- nasłuchuje na porcie 3000
- pobiera dane z prometheus
- umożliwia wirtualizację metryk Node Exportera za pomocą dashboard

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Nie można zainstalować Grafany | Instalacja kończy się błędem. | Brak repozytorium Grafany lub nieaktualna lista pakietów. | Dodaj oficjalne repozytorium Grafany, zaktualizuj listę pakietów i ponownie wykonaj instalację. |
| Brak dostępu do interfejsu WWW | Strona `http://adres_IP:3000` nie otwiera się. | Usługa nie działa lub port 3000 nie jest dostępny. | Sprawdź status usługi oraz nasłuchiwanie na porcie 3000. |
| Brak danych na dashboardzie | Dashboard nie wyświetla metryk. | Nie dodano źródła danych Prometheus lub skonfigurowano je niepoprawnie. | Dodaj źródło danych Prometheus i zweryfikuj adres serwera. |
| Brak połączenia z Prometheusem | Test połączenia kończy się błędem. | Niepoprawny adres URL Prometheusa lub usługa nie działa. | Sprawdź adres URL, status usługi Prometheus oraz łączność sieciową. |
