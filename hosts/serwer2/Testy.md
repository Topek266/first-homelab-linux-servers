## Testy Samba:
- smbclient -L 192.168.66.2 -N  --> Lista dostępnych udziałów
- smbclient 192.168.66.2/public -N  --> Test udziału publicznego
- smbclient 192.168.66.2/private -U klientsmb  --> Test udziału prywatnego(z hasłem)
- smbclient 192.168.66.2/private -N --> Test odmowy dostępu

---

## Testy NFS
Najpierw musiałem zamontować katalogi

  Publiczny:
  ```bash
  mount 192.168.66.0:/public /mnt/share/public
  ```

  Prywatny:
  ```bash
  mount 192.168.66.2:/private /mnt/share/private
  ```

Później stworzyłem katalog i w nim plik w udziale prywatnym z klienta i na serwerze sprawdziłem czy on się tam znajduje.

  **Montowanie na stałe przez fstab w pliku /etc/fstab :**
  
  Dodaj linie:
  192.168.66.2:/public    /mnt/nfs    nfs    defaults   0 0

  Utwórz punkt montowania:
Katalog dla NFS:
```bash
sudo mkdir -p /mnt/nfs
```

Montowanie wszystkiego z fstab:
```bash
sudo mount -a
```

Sprawdzenie czy jest zamontowany:
```bash
df -h | grep nfs
```

---

## Testy FTP

Publiczny:
```bash
ftp 192.168.66.2
```
login: anonymous
hasło: (Enter)

Prywatny:
```bash
ftp 192.168.66.2
```
login: ftpuser
hasło: <twoje hasło>

