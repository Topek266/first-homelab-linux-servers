# Opis klienta

## Host: Ubuntu Server (klient)
- IP: 192.168.66.52 (przydzielone przez DHCP)
- Cel: testowanie serwerów
- System Ubuntu Server 24.04
- CPU/RAM: VM, AMD Ryzen 7, 1 CPU , 2GB RAM

---

## Testy DHCP:
- Ping do servera DHCP: `ping 192.168.66.1`
- Sprawdzenie IP: `ip a show enp1s0`

---

## Testy DNS:
- dig @192.168.66.1 www.lab.local
- dig @192.168.66.1 serwer.lab.local
- nslookup www.lab.local

---

## Testy Apache2:

### Test DNS + Apache
- Sprawdzenie czy nazwa rozwiązuje się poprawnie:
``` bash
ping www.lab.local
```

Wynik: poprawne tłumaczenie na adres IP serwera

### Test połączenia HTTP
```bash
curl http://www.lab.local
```

Wynik: zwraca kod HTML strony

### Sprawdzenie portu 80
```bash
nc -zv 192.168.66.10 80
```
Wynik: port otwarty
