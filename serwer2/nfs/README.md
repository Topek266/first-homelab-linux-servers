# NFS Server, 
 
## Cel
Konfiguracja serwera NFS do udostępniania plików między systemami Linux/Unix.
W przeciwieństwie do Samby, NFS jest natywnym protokołem dla systemów Linux/Unix i nie wymaga dodatkowego uwierzytelniania, dostęp kontrolowany jest przez adresy IP.

---

## Instalacja
```bash
sudo apt install nfs-kernel-server -y
```

---

## Utwórz katalogi
```bash
sudo mkdir -p /srv/share/nfs/public
```

```bash
sudo mkdir -p /srv/share/nfs/private
```

Nadaj uprawnienia:

Publiczny:
```bash
sudo chmod 755 /srv/share/nfs/public
```
```bash
sudo chown $USER:$USER /srv/share/nfs/public
```

Prywatny:
```bash
sudo chmod 700 /srv/share/nfs/private
```
```bash
sudo chown root:root /srv/share/nfs/private
```

---

## Konfiguracja

Edytuj plik konfiguracyjny:
```bash
sudo nano /etc/exports
```

Plik konfiguracyjny znajdzuje się w tym samym katalogu co README.

NFS ma dwa udziały, 1) Publiczny i 2) Prywatny

1) Publiczny - dostępny dla wszystkich w sieci
- Jest tylko do odczytywania plików
- zapisuje pliki odrazu na dysku 
- Wyłącza sprawdzanie czy plik należy do udostępnionego podkatalogu. Poprawia wydajność i stabilność.

2) Prywatny - dostępny tylko dla wyznaczonego hosta
- Odczyt + zapis plików
- zapisuje pliki odrazu na dysku 
- Wyłącza sprawdzanie czy plik należy do udostępnionego podkatalogu. Poprawia wydajność i stabilność.
- Klient ma prawo do root na serwerze.    `!!! UWAGA !!!  no_root_squash` stosuje się tylko dla zaufanych hostów ale z reguły się tego nie stosuje.

Zastosowanie zaminy konfiguracji:
```bash
exportfs -a
```

Zrestartowanie usługi:
```bash
sudo systemctl restart nfs-kernel-server
```

---

## Montowanie dysku nfs
Trzeba jeszcze zamontować dysk nfs aby z niego korzystać

Sprawdź co serwer udostępnia:
```bash
showmount -e 192.168.66.2
```

Zamontuj udział:
```bash
sudo mount 192.168.66.2:/srv/share/nfs/publiczny /mnt
```

Sprawdź czy montowanie przebiegło pomyślnie:
```bash
df -h | grep mnt
```

**Montowanie na stałe przez fstab**

Stwórz katalog w /mnt:
```bash
sudo mkdir -p /mnt/nfs
```

Edytuj plik:
```bash
sudo nano /etc/fstab
```

Dodaj tą linie do pliku:
```fstab
192.168.55.2:/srv/files/nfs/publiczny         /mnt/nfs      nfs       defaults      0 0
```

Zamontuj wszystko z fstab:
```bash
sudo mount -a
```

---

## Weryfikacja działania

- Utworzyłem w publicznym katalog a w nim plik i sprawdziłem czy znajduje się on na innym serwerze
- Utworzyłem w prywatnym katalog a w nim plik i sprawdziłem czy znajduje się na przeznaczonym do tego serwerze
- zresetowałem serwer i udział automatycznie się montuje
- do udziału prywatnego ma tylko dostęp serwer3 

Sprawdzenie czy nasłuchuje na porcie 2049:
```bash
sudo ss -tulnp | grep 2049
```



---

## Efekt końcowy
Po wykonaniu tyvh kroków serwer NFS:
- działająca usługa vsftpd na porcie 2049
- udostępnia wskazany katalog w sieci lokalnej
- umożliwa innym serwerą montowanie udziału NFS
- pozwala na odczyt i zapis danych zgodnie z nadanymi uprawnieniami
- udostępnia udziały zgodnie z konfiguracją pliku `/etc/exports`

## Problemy i rozwiązania

| Problem | Objawy | Przyczyna | Rozwiązanie |
|---------|---------|-----------|-------------|
| `mount.nfs: access denied by server` | Klient nie może zamontować udziału NFS. | Niepoprawna konfiguracja pliku `/etc/exports`, błędny adres IP klienta lub brak przeładowania eksportów. | Sprawdź plik `/etc/exports`, wykonaj `sudo exportfs -ra` i uruchom ponownie usługę `nfs-kernel-server`. |
| `mount.nfs: Connection timed out` | Próba montowania kończy się przekroczeniem limitu czasu. | Usługa NFS nie działa, brak łączności sieciowej lub zapora blokuje ruch. | Sprawdź status usługi, połączenie z serwerem (`ping`) oraz dostępne eksporty (`showmount -e`). |
| `mount.nfs: No route to host` | Klient nie może połączyć się z serwerem NFS. | Niepoprawna konfiguracja sieci lub maszyny znajdują się w różnych podsieciach. | Zweryfikuj konfigurację interfejsów sieciowych oraz sprawdź łączność poleceniem `ping`. |
| Brak uprawnień do zapisu | Udział można zamontować, ale zapis plików kończy się błędem. | Niepoprawne uprawnienia katalogu, opcja `root_squash` lub brak `rw` w `/etc/exports`. | Sprawdź uprawnienia katalogu oraz konfigurację eksportu przy użyciu `exportfs -v`. |
