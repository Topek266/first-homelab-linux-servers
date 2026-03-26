# Apache2 Server

## Cel
Nauka podstawowej konfiguracji serwera Apache2 i uruchomienie prostej strony www.lab.local.

---

## Plik Konfiguracji
- `/etc/apache2/sites-available/www.lab.local` --> VirtualHost
- `/var/www/www.lab.local/index.html` --> testowa strona HTML

---

## Krótki opis konfiguracji
- **VirtualHost:** na porcie 80 dla www.lab.local
- **ServerName / ServerAlias:** www.lab.local, lab.local
- **Plik strony:** index.html, a w nim <h1>Strona testowa Apache</h1>
- **Uprawnienia katalogu:** właściciel i grupa www-data, chnid 750
- **Uprawnienia pliku index.html:** chmod 664
- **Logi:** error log i access log dla monitorowania odzwiedzin i błędów
- **AllowOverride None:** zabrania używania plików .htaccess w katalogu strony
- **DocumentRoot:** katalog ze stroną, czyli miejsce z którego serwer serweruje pliki

---

## Aktywacja strony i przeładowanie serwera
- Aktywacja VirtualHost:
```bash


sudo a2ensite www.lab.local.conf

sudo systemctl reload apache2
```


---


## Testy
- Sprawdzenie uruchomienia strony w przeglądarce pod adresem `http://www.lab.local`
- Sprawdzenie logów error i access (`/var/log/apache2/`)
- Test uprawnień plików i katalogów
 
