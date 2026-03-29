# DHCP Server
Dokumentacja prostej konfiguracjii w moim projekcie.

## Plik konfiguracyjny:
`/etc/dhcp/dhcpd.conf`

## Cel
Serwer DHCP przydziela adresy IP hostom w sieci 192.168.66.0/24.

## Zakres
192.168.66.50 - 192.168.66.100

## Gateway
192.168.66.1

## DNS
192.168.66.1

## Dodatkowo
- domain-name: lab.local
- broadcast-address: 192.168.66.255
- default-lease-time: 600sec
- max-lease-time: 7200sec

## Uruchomienie, Restart i Status usługi
```bash
```bash
sudo systemctl enable --now isc-dhcp-server
sudo systemctl restart isc-dhcp-server
sudo systemctl status isc-dhcp-server
```

---

## Testy na kliencie
Znajdują się w katalogu hosts
```
