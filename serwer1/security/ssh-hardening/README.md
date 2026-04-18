# SSH Hardening - Zabezpieczenie Serwera

## Krótki opis
Celem było zastąpienie domyślnej, niezabezpieczonej konfiguracji SSH przez:
- Wyłączenie logowania hasłem na rzecz kluczy SSH
- Blokadę bezpośredniego logowania jako root
- Ograniczenie dostępu tylko do wybranych użytkowników
- Zmianę domyślnego portu i ustawienie limitów bezpieczeństwa

## Co zostało wykonane
1. Utworzenie użytkownika administracyjnego

Zamiast logować się bezpośrednio jako root, utworzyłem osobnego użytkownika z uprawnieniami sudo.
Logowanie jako root to zła praktyka, ponieważ gdyby atakujący przejąby takie konto to miałby 
od razu pełny dostęp do systemu.

```bash
sudo adduser admin
```
```bash
sudo usermod -aG sudo admin
```

2. Generowanie kluczy SSH na kliencie
Na kliencie wygenerowałem klucze ed25519.
```bash
ssh-keygen -t ed25519 -C "admin@serwer1" -f ~/.ssh/serwer1_ed25519
```

Klucz prywatny został na maszynie klienta, a klucz publiczny skopiowałem na serwer
```bash
ssh-copy-id -i ~/.ssh/serwer1_ed25519.pub admin@192.168.66.1
```

3. Wyłączenie ssh.socked
Na serwerze domyślnie działa ssh.socked, który nadpisuje ustawienia portu z sshd_config.

Przed zmianą portu konieczne było jego wyłączenie:
```bash
sudo systemctl stop ssh.socked
```
```bash
sudo systemctl disable ssh.socked
```
```bash
sudo systemctl restart ssh
```

4. Utwardzanie sshd_config
Wprowadzone zmiany w `/etc/ssh/sshd_config` -- pełna konfiguracja w pliku [`sshd_config`](./sshd_config)

## Testy

1. Na serwerze
Sprawdzenie czy SSH nasłuchuje na porcie 2222:
```bash
sudo ss -tlnp | grep ssh 
```

2. Na kliencie
Test logowania kluczem:
```bash
ssh -i ~/.ssh/serwer1_ed25519 -p 2222 admin@192.168.66.1
```

Test czy logowanie się hasłem jest zablokowane:
```bash
ssh -o PasswordAuthentication=yes -p 2222 admin@192.168.66.1
```

Test czy logowanie się jako root jest zablokowane:
```bash
ssh -p 2222 root@192.168.66.1
```


