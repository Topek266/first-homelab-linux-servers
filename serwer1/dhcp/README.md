# DHCP Server
Dokumentacja prostej konfiguracjii w moim projekcie.

## Plik konfiguracyjny:
`/etc/dhcp/dhcpd.conf`

## Cel
Konfiguracja serwera DHCP, który przydziela adresy IP hostom w sieci 192.168.66.0/24.

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
sudo systemctl enable --now isc-dhcp-server
```
```bash
sudo systemctl restart isc-dhcp-server
```
```bash
sudo systemctl status isc-dhcp-server
```

---

## Testy na kliencie
Znajdują się w katalogu hosts

## Problemy i rozwiązania

1. Konflikt zarezerwowanego adresu IP z przydzielanym adresem IP --> zarezerwowałem IP 192.168.66.50 i miałem ustawiony zakres przydzielania IP 
   192.168.66.50 192.168.66.100 i nie mogło mi przydzielić tego IP, ponieważ bytł w zakresie przydziału.

   Zmieniłem zarezerwowany adres IP na 192.168.66.49 i już błędu nie było.

