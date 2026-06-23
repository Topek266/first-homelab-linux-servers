# Fail2ban - Monitoring logów

## Krótki opis 
Celem zastosowania fail2ban jest zabezpieczenie serwera przed atakami brute-force przez:
- automatyczne blokowanie IP po zbyt wielu nieudanych próbach logowania do SSH i vsftpd
- Wykluczenie sieci labnet z banowania

## Co zostało wykonane
1. Instalacja fail2ban

```bash
sudo apt install fail2ban
```
```bash
sudo systemctl enable fail2ban
```
```bash
sudo systemctl status fail2ban
```

2. Utworzenie pliku jail.local
Plik /etc/fail2ban/jail.conf jest nadpisywany przy aktualizacji, nie edytujemy go bezpośrednio.
Zamiast tego tworzymy /etc/fail2ban/jail.local który nadpisuje tylko wybrane opcje

```bash
sudo nano /etc/fail2ban/jail.local
```

Pełna konfiguracja znajduje się w [`jail.local`](./jail.local)

Główne ustawienia:
- IP banowane po przekroczeniu limitu nieudanych prób logowania na 1 godzinę
- okno czasowe 10 minut w którym liczone są próby logowania
- liczba nieudanych prób przed banem
- wykluczenie sieci izolowanej (192.168.66.0/24) z banowania

3. Restart i status
```bash
sudo systemctl restart fail2ban
```
```bash
sudo systemctl status fail2ban
```

## Testy

Sprawdzenie aktywnych jaili:
```bash
sudo fail2ban-client status
```

Sprawdzenie konkretnego jaila:
```bash
sudo fail2ban-client status sshd
```
```bash
sudo fail2ban-client status vsftpd
```

Sprawdzenie logów:
```bash
sudo journalctl -u fail2ban -n 50
```


## Napotkane problemy 

Miałem problem z dodaniem jaila samby, ponieważ nie było go w gotowych filtrach.
Na chwilę obecną nie umiem jeszcze napisać filta więc postanowiłem że jak się nauczę to go dodam.
