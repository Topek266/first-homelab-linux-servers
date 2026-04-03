# Apache2 Server

## Cel
Nauka podstawowej konfiguracji serwera Apache2 i uruchomienie prostej strony www.lab.local.

---

## Plik Konfiguracji
- `/etc/apache2/sites-available/www.lab.local` --> VirtualHost
- `/var/www/www.lab.local/index.html` --> testowa strona HTML

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

## Krótki opis konfiguracji
- **VirtualHost:** na porcie 80 dla www.lab.local
- **ServerName / ServerAlias:** www.lab.local, lab.local
- **Plik strony:** index.html, a w nim <h1>Strona testowa Apache</h1>
- **Logi:** error log i access log dla monitorowania odzwiedzin i błędów
- **AllowOverride None:** zabrania używania plików .htaccess w katalogu strony
- **DocumentRoot:** katalog ze stroną, czyli miejsce z którego serwer serweruje pliki

---

## Aktywacja strony i przeładowanie serwera
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

---


## Testy
```bash
curl http://localhost
```
- Sprawdzenie logów error i access (`/var/log/apache2/`)
- Test uprawnień plików i katalogów

---

## Testy na kliencie
Znajdują się w katalogu hosts




