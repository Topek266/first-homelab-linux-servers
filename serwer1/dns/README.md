# DNS Server
Dokumentacja prostej konfiguracji serwera DNS w moim projekcie


## Cel 
Serwer DNS tłumaczy nazwy domen (np. www.lab.local) na adresy IP w mojej sieci labowej.
Umożliwia testowanie klientów w połączeniu z serwerem DHCP.

---

## Instalacja
```bash
sudo apt install bind9 bind9utils bind9-doc -y 
```

---

## Konfiguracja pliku named.conf.local

Plik konfiguracyjny znajduje się w tym samym katalogu co README.

Utwórz plik:
```bash
sudo nano /etc/bind/named.conf.local
```

**Opis konfiguracji:**
- ten serwer jest głównym serwerem dla tej strefy
- zabezpieczenie przed kopiowaniem strefy

## Konfiguracja db.lab.local

Plik konfiguracyjny znajduje się w tym samym katalogu co README.

Utwórz plik:
```bash
sudo nano /etc/bind/db.lab.local
```


**Opis konfiguracji:**
- Serwer działa z BIND9.
- SOA w strefie używa serialu w formacie "YYYYMMDD", co ułatwia śledzenie zmian.
- $TTL ustawione na 600 sekund dla szybkiego testowania zmian.
- Rekordy hostów aktualnie wskazują na jedno IP serwera DNS
- W plikach zastosowano komentarze do rozdzielenia sekcji `Serwery nazw`, `Hosty` i `Root strefy wskazuje na NS` co ułatwia czytanie i przyszłe zmiany.

---

## Weryfikacja działania

Zrestartuj usługę:
```bash
sudo systemctl restart bind9
```

Sprawdź status:
```bash
sudo systemctl status bind9
```

Sprawdź poprawność konfiguracji named.conf.local:
```bash
sudo named-checkconf
```

Sprawdź poprawność strefy DNS:
```bash
sudo named-checkzone lab.local /etc/bind/db.lab.local
```

Sprawdź czy nasłuchuje na porcie 53:
```bash
sudo ss -tulnp | grep 53
```

Test lokalnego rozwiązywania nazw:
```bash
nslookup lab.local localhost
```

**Testy z klienta (Windows10)**

Test rozwiązywania nazw:
```cmd
nslookup www.lab.local
```


Sprawdź łączność z hostem:
```cmd
ping 192.168.66.1
```



## Efekt końcowy
Po wykonaniu tych kroków serwer DNS:
- poprawnie rozwiązuje nazwy hostów na adresy IP
- obsługuje strefę `lab.local`
- współpracuje z serwerem DHCP, przekazując klientą adres serwera DNS


## Problemy i rozwiązania
| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| Literówka w pliku strefy DNS | Usługa BIND9 nie uruchamia się lub zgłasza błędy podczas sprawdzania strefy. | Błąd składni w pliku strefy DNS. | Zweryfikuj plik poleceniem `named-checkzone` i popraw błędy składni. |
| Brak kropki po nazwie FQDN | Rekordy DNS nie są poprawnie interpretowane. | Pełna nazwa domenowa (FQDN) została zapisana bez końcowej kropki (`.`). | Dodaj kropkę na końcu nazwy FQDN, np. `ns.lab.local.`. |
| Niezwiększony numer `Serial` | Wprowadzone zmiany w strefie DNS nie są uwzględniane. | Po edycji pliku strefy nie został zwiększony numer `Serial` w rekordzie SOA. | Zwiększ wartość `Serial` przed ponownym uruchomieniem lub przeładowaniem usługi BIND9. |
| Klient nie korzysta z właściwego serwera DNS | Polecenia `nslookup` lub `dig` nie zwracają oczekiwanych wyników. | Klient korzysta z innego serwera DNS niż skonfigurowany w laboratorium. | Sprawdź konfigurację klienta (`/etc/resolv.conf` lub ustawienia sieci) i ustaw właściwy adres serwera DNS. |
