# DNS Server
Dokumentacja prostej konfiguracji serwera DNS w moim projekcie

## Pliki konfiguracyjne:
`/etc/bind/named.conf.local`
`/etc/bind/db.lab.local`

## Cel 
Serwer DNS tłumaczy nazwy domen (np. www.lab.local) na adresy IP w mojej sieci labowej.
Umożliwia testowanie klientów w połączeniu z serwerem DHCP.

---

## Krótki opis konfiguracji db.lab.local
- Serwer działa z BIND9.
- SOA w strefie używa serialu w formacie "YYYYMMDD", co ułatwia śledzenie zmian.
- $TTL ustawione na 600 sekund dla szybkiego testowania zmian.
- Rekordy hostów aktualnie wskazują na jedno IP serwera DNS
- W plikach zastosowano komentarze do rozdzielenia sekcji `Serwery nazw`, `Hosty` i `Root strefy wskazuje na NS` co ułatwia czytanie i przyszłe zmiany.

---

## Testy na kliencie
Znajdują się w katalogu hosts
