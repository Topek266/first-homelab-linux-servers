# Nginx jako Reverse Proxy i TLS

## Cel
Nginx pełni funkcję centralnej bramy sieciowej (Reverse Proxy) z protokołem TLS, który szyfruje dane docelowej strony Apache2.

## Główne zadania Nginx
- **Bezpieczeństwo i Szyfrowanie:** Nginx odpowiada za obsługę protokołu HTTPS. Przejmuje na siebie cały ciężar związany z szyfrowaniem i deszyfrowaniem ruchu.
- **Izolacja**: Działa jako jedyny publiczny punkt wejścia (brama), dzięki temu ukrywa strukturę sieci wewnętrznej i numery portów.
- **Optymalizacja Wydajności:** Efektywnie zarządza połączeniami klienta i potrafi zarządzać podstawowym mechanizmem pamięci podręcznej.

## Plik konfiguracyjny
- /etc/nginx/sites-available/secure.lab.local

1) Reverse Proxy

Plik konfiguracyjny: **/etc/bind/db.lab.local**

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

### Testy
Test i przeładowanie konfiguracji:
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
Będą wyskakiwały nam opcje wprowadzenie danych do certyfikatu, jako jest to tylko lab przeklikałem wszystko wciskając ENTER oprócz "Common name", w to pole należy wpisać `secure.lab.net`

### Uprawnienia do plików i katalogu
```bash
sudo chown root:root /etc/nginx/ssl
```
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

### Testy
Test i przeładowanie konfiguracj:
```bash
sudo nginx -t
```
```bash
sudo systemctl reload nginx
```

Testy z klienta w katalogu [hosts](/hosts/serwer3)

