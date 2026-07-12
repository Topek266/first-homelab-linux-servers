# Nginx jako Reverse Proxy i TLS

## Cel
Nginx pełni funkcję centralnej bramy sieciowej (Reverse Proxy) z protokołem TLS, który szyfruje dane docelowej strony Apache2.

---

## Schemat działania

+---------------+
|    Klient     +
+---------------+
        |
+---------------+
|     Nginx     |
+---------------+
        |
+---------------+
|    Apache2    |
+---------------+

---

## Główne zadania Nginx
- **Bezpieczeństwo i Szyfrowanie:** Nginx odpowiada za obsługę protokołu HTTPS. Przejmuje na siebie cały ciężar związany z szyfrowaniem i deszyfrowaniem ruchu.
- **Izolacja**: Działa jako jedyny publiczny punkt wejścia (brama), dzięki temu ukrywa strukturę sieci wewnętrznej i numery portów.
- **Optymalizacja Wydajności:** Efektywnie zarządza połączeniami klienta i potrafi zarządzać podstawowym mechanizmem pamięci podręcznej.

---

## Instalacja
```bash
sudo apt install nginx
```

---

## Konfiguracja

Utwórz plik konfiguracyjny:
```bash
/etc/nginx/sites-available/secure.lab.local
```

1) Reverse Proxy

Edytuj plik konfiguracyjny:
```bash
sudo nano /etc/bind/db.lab.local
```


### Dodaj nazwę do Serwera DNS i zwiększ serial:
- secure  IN  A 192.168.66.3

Sprawdz konfigurację:
```bash
sudo named-checkzone lab.local /etc/bind/db.lab.local
```

Test na kliencie czy rozwiązuje nazwę "secure":
```bash
nslookup secure.lab.local
```

### Sprawdz połączenie Nginx --> Apache2
```
curl http:192.168.66.1
```

Powinieneś zobaczyć stronę Apache2

### Krótki opis konfiguracji
- nazwa serwera: secure.lab.local
- nasłuchuje na porcie 80
- przekazuje żądanie dalej do Apache2
- przekazuje nazwę strony do Apache2
- przekazuje prawdziwe IP klienta

### Aktywacja strony
```bash
sudo ln -s \
/etc/nginx/sites-available/secure.lab.local \
/etc/nginx/sites-enabled/
```

Test i przeładowanie konfiguracji:
```bash
sudo systemctl enable nginx
```
```bash
sudo nginx -t
```
```bash
sudo systemctl reload nginx
```

Test reverse proxy:
```bash
curl http://secure.lab.local
```

2) Szyfrowanie TLS

### Generowanie certyfikatu i utworzenie katalogu na certyfikat
```bash
sudo mkdir -p /etc/nginx/ssl
```

```bash
sudo openssl req -x509 -newkey rsa: 4096 -nodes \
-keyout /etc/nginx/ssl/secure.key \
-out /etc/nginx/ssl/secure.crt \
-days 365
```

**WAŻNE !!: ** Common name
Będą wyskakiwały nam opcje wprowadzenie danych do certyfikatu, jako jest to tylko lab przeklikałem wszystko wciskając ENTER oprócz "Common name", w to pole należy wpisać `secure.lab.local`

### Uprawnienia do plików i katalogu

Zmiana właściciela:
```bash
sudo chown root:root /etc/nginx/ssl
```

Uprawnienia do katalogu i plików:
```bash
sudo chmod -R 700 /etc/nginx/ssl
```
```bash
sudo chmod -R 600 /etc/nginx/ssl/secure.key
```
```bash
sudo chmod -R 644 /etc/nginx/ssl/secure.crt
```

### Krótki opis konfiguracji
- nasłuchuje na porcie 443
- nazwa serwera secure.lab.local
- Podałem ścieżki do klucza i certyfikatu
- Pozostałe opcje są takie same jak w konfiguracji Reverse Proxy

### Weryfikacja działania

Test konfiguracji:
```bash
sudo nginx -t
```

Sprawdzenie statusu usługi:
```bash
sudo systemctl status nginx
```

Sprawdzenie czy nginx nasłuchuje na porcie 443:
```bash
sudo ss -tulnp | grep 443
```

Sprawdź certyfikat TLS:
```bash
openssl s_client -connect localhost:443
```

Sprawdź działanie reverse proxy:
```bash
curl -k https://localhost
```

Testy z klienta w katalogu [hosts](/hosts/serwer3)

## Efekt końcowy
- klient łączy się najpierw z nginx, potem nginx przekierowuje do Apache2
- połączenie jest szyfrowane przez HTTPS na porcie 443
- Nginx odciąża w ten sposób Apache2
- klienci nie widzą adresu IP Apache2

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Błąd konfiguracji Nginx | Usługa nie uruchamia się. | Błąd składni w pliku konfiguracyjnym. | Sprawdź konfigurację poleceniem `sudo nginx -t`, popraw błędy i uruchom ponownie usługę. |
| Błąd certyfikatu TLS | Przeglądarka wyświetla ostrzeżenie o certyfikacie. | Niepoprawna ścieżka do certyfikatu lub certyfikat został błędnie wygenerowany. | Zweryfikuj ścieżki `ssl_certificate` i `ssl_certificate_key` oraz poprawność certyfikatu. |
| Brak połączenia z Apache | Nginx zwraca błąd **502 Bad Gateway**. | Serwer Apache nie działa lub błędnie skonfigurowano `proxy_pass`. | Sprawdź status usługi Apache oraz adres ustawiony w `proxy_pass`. |
| Port 443 jest zajęty | Nginx nie uruchamia się i zgłasza błąd `Address already in use`. | Inna usługa korzysta z portu 443. | Sprawdź proces nasłuchujący na porcie (`sudo ss -tulpn | grep :443`) i zwolnij port lub zmień konfigurację. |
| Niepoprawna konfiguracja DNS | Strona nie otwiera się po nazwie domenowej. | Rekord DNS wskazuje niepoprawny adres IP lub klient nie korzysta z właściwego serwera DNS. | Zweryfikuj rekord DNS oraz konfigurację klienta i wykonaj ponowny test `nslookup`. |
