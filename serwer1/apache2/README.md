# Apache2 Server

## Cel
Nauka podstawowej konfiguracji serwera Apache2 i uruchomienie prostej strony www.lab.local.

---

`/var/www/www.lab.local/index.html` --> testowa strona HTML

---

## Instalacja
```bash
sudo apt install apache2
```


## Tworzenie katalogów i uprawnienia
```bash
sudo mkdir -p /var/www/www.lab.local
```
```bash
sudo chown -R www-data:www-data /var/www/www.lab.local
```
```bash
sudo chmod -R 750 /var/www/www.lab.local
```

```bash
sudo touch /var/www/www.lab.local/index.html
```
```bash
sudo chmod -R /var/www/www.lab.local/index.html
```

---

Plik index.html znajduje się w tym samym katalogu co README.

---

## Konfiguracja VirtualHost

Plik konfiguracji znajduje się w tym samym katalogu co README.

Stwórz plik:
```bash
sudo nano /etc/apache2/sites-available.www.lab.local
```

Opis konfiguracji:

- **VirtualHost:** na porcie 80 dla www.lab.local
- **ServerName / ServerAlias:** www.lab.local, lab.local
- **Plik strony:** index.html, a w nim <h1>Strona testowa Apache</h1>
- **Logi:** error log i access log dla monitorowania odzwiedzin i błędów
- **AllowOverride None:** zabrania używania plików .htaccess w katalogu strony
- **DocumentRoot:** katalog ze stroną, czyli miejsce z którego serwer serweruje pliki

---

## Aktywacja strony i przeładowanie usługi
Aktywacja VirtualHost:
```bash
sudo a2ensite www.lab.local.conf
```
```bash
sudo systemctl reload apache2
```
```bash
sudo systemctl status apache2
```
```bash
sudo systemctl enable apache2
```

---


## weryfikacja działania

Test lokalny strony:
```bash
curl http://localhost
```

Sprawdzenie poprawności pliku konfiguracyjnego:
```bash
sudo apache2ctl configtest
```

Sprawdzenie czy apache2 nasłuchuje na porcie 80:
```bash
sudo ss -tulnp | grep 80
```

### Testy na kliencie (Windows10)

Test dostępności strony w przeglądarce:
```URL
http://www.lab.local
```

Sprawdzenie łączności z serwerem:
```cmd
ping 192.168.66.1
```

## Efekt końcowy

Po wykonaniu wszystkich kroków serwer Apache2:

- udostępnia stronę internetową przez protokół HTTP,
- nasłuchuje na porcie **80**,
- automatycznie uruchamia usługę po starcie systemu,
- obsługuje żądania klientów w sieci lokalnej,
- współpracuje z serwerem DNS, umożliwiając dostęp do strony za pomocą nazwy domenowej,
- współpracuje z serwerem Nginx pełniącym rolę reverse proxy i terminującego połączenia TLS.

## Problemy i Rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Niepoprawna konfiguracja serwera DNS | Polecenia `apt`, `wget` lub `curl` zwracają komunikat `Temporary failure in name resolution`. | Serwer korzysta z niepoprawnie skonfigurowanego serwera DNS lub wpis w `/etc/resolv.conf` jest błędny. | Sprawdź zawartość pliku `/etc/resolv.conf` i ustaw poprawny adres serwera DNS, np. `nameserver 192.168.66.1`. |
| Niepoprawny `DocumentRoot` | Serwer zwraca błąd **404 Not Found**, mimo że pliki strony istnieją. | Dyrektywa `DocumentRoot` wskazuje niewłaściwy katalog. | Sprawdź konfigurację VirtualHost i ustaw poprawną ścieżkę w `DocumentRoot`. |
| Błąd konfiguracji Apache2 | Usługa Apache2 nie uruchamia się lub nie wczytuje zmian. | Błąd składni w plikach konfiguracyjnych. | Zweryfikuj konfigurację poleceniem `apache2ctl configtest`, popraw błędy i uruchom ponownie usługę. |
