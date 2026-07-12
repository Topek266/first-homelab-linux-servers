# DHCP Server


## Cel
Konfiguracja serwera DHCP, który przydziela adresy IP hostom w sieci 192.168.66.0/24.

## Konfiguracja netplan

Konfiguracja znajduje się w tym samym katalogu co README

Edycja pliku:
```yaml
sudo nano /etc/netplan/50-cloud-init.yaml
```

---

## Instalacja
```bash
sudo apt install isc-dhcp-server -y
```

---

## Konfiguracja dhcpd.conf

Edytuj plik:
```bash
sudo nano /etc/dhcp/dhcpd.conf
```

Krótki opis konfiguracji:
- zakres przydzielanych adresów IP to 192.168.66.50 - 192.168.66.100
- brama domyślna to 192.168.66.0
- ustawiłem serwer DNS
- zarezerwowałem adres IP dla klienta

Pełna konfiguracja znajduje się w tym samym katalogu co README.

---

## Weryfikacja działania

```bash
sudo systemctl enable --now isc-dhcp-server
```
```bash
sudo systemctl restart isc-dhcp-server
```
```bash
sudo systemctl status isc-dhcp-server
```


---

## Testy na kliencie (Windows 10)
Zwolnienie obecnego adresu IP:
```cmd
ipconfig /release
```


Pobranie adresu IP z serwera DHCP:
```cmd
ipconfig /renew
```

Sprawdzenie otrzymanego adresu IP:
```cmd
ipconfig
```

- klient otrzymał adres z puli skonfigurowanej na serwerze DHCP

Sprawdzenie łączności z bramą:
```cmd
ping 192.168.66.1
```

- ICMP odpowiada bez utraty pakietów

---

## Problemy i rozwiązania

| Problem | Objaw | Przyczyna | Rozwiązanie |
|---------|-------|-----------|-------------|
| Literówka w `dhcpd.conf` | Klient wysyła `DHCPDISCOVER`, ale nie otrzymuje adresu IP. | Błąd składni w pliku konfiguracyjnym. | Sprawdź konfigurację poleceniem `dhcpd -t`, popraw literówkę i uruchom ponownie usługę. |
| Niepoprawny interfejs w `/etc/default/isc-dhcp-server` | Usługa działa, ale klienci nie otrzymują adresów IP. | Serwer nasłuchuje na niewłaściwym interfejsie sieciowym. | Ustaw poprawny interfejs przypisany do sieci Internal Network. |
| Niepoprawne wcięcia w pliku Netplan | `netplan apply` zwraca błąd i konfiguracja nie zostaje zastosowana. | Użyto tabulatorów lub błędnych wcięć. | Stosuj dwie spacje do wcięć i zweryfikuj składnię pliku. |
| Różne nazwy sieci Internal Network | Pakiety `DHCPDISCOVER` nie docierają do serwera DHCP. | Maszyny znajdują się w różnych sieciach Internal Network. | Ustaw identyczną nazwę sieci Internal Network na wszystkich maszynach wirtualnych. |
| Brak statycznego adresu IP serwera DHCP | Klienci nie otrzymują poprawnej konfiguracji sieciowej. | Serwer zmienia swój adres IP lub znajduje się poza skonfigurowaną podsiecią. | Skonfiguruj statyczny adres IP dla serwera DHCP. |
| Klient korzysta z NAT zamiast Internal Network | `DHCPDISCOVER` jest wysyłany, ale brak odpowiedzi z serwera DHCP. | Zapytania są wysyłane przez niewłaściwy interfejs sieciowy. | Ustaw kartę Internal Network jako interfejs używany do komunikacji z serwerem DHCP. |
| Konflikt zarezerwowanego adresu IP z pulą DHCP | Klient nie otrzymuje zarezerwowanego adresu IP lub występują błędy przy jego przydzielaniu. | Zarezerwowany adres IP znajduje się jednocześnie w zakresie dynamicznie przydzielanych adresów (`range`). | Wyklucz zarezerwowany adres z puli DHCP lub zmień adres rezerwacji tak, aby nie należał do zakresu `range`. |

