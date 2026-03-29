# Opis klienta

## Host: Ubuntu Server (klient)
- IP: 192.168.66.52 (przydzielone przez DHCP)
- Cel: testowanie serwerów
- System Ubuntu Server 24.04
- CPU/RAM: VM, AMD Ryzen 7, 1 CPU , 2GB RAM

---

# Testy na serwerze 1

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

---

# Testy na serwerze 2

## Testy Samba:
- smbclient -L 192.168.66.2 -N  --> Lista dostępnych udziałów
- smbclient 192.168.66.2/publiczny -N  --> Test udziału publicznego
- smbclient 192.168.66.2/prywatny -U klientsmb  --> Test udziału prywatnego(z hasłem)
- smbclient 192.168.66.2/prywatny -N --> Test odmowy dostępu

