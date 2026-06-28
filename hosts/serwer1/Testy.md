## Testy DHCP:
- Ping do servera DHCP:
```bash
ping 192.168.66.1
```

- Sprawdzenie IP:
```bash
ip a show enp1s0
```

---

## Testy DNS:
```bash
dig @192.168.66.1 www.lab.local
```
```bash
dig @192.168.66.1 serwer.lab.local
```
```bash
nslookup www.lab.local
```

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

