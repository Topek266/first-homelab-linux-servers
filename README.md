# pierwszy-homelab-Linux-Servers

Domowy lab  postawiony na KVM/QEMU z Ubuntu Server

## Środowisko
- **Host:** Ubuntu Server (klient1) (AMD Ryzen 7)
- **Serwery:** Ubuntu Server 24.04
- **Wirtualizacja:** KVM/QEMU + virt-manager
- **Sieć izolowana:** 192.168.66.0/24

## Serwery
| Serwer | IP | Usługi |
|--------|----|--------|
| Server1 | 192.168.66.1 | DHCP, DNS, Apache2 |
| Server2 | 192.168.66.2 | Samba, NFS, FTP |
| Server3 | 192.168.66.3 | Nginx (Reverse Proxy + TLS) |
| Server4 | 192.168.66.4 | Syslog-ng, Prometheus, Grafana

## Cel
Nauka administrowania systemami Linux - konfiguracja usług sieciowych, automatyzacja, podstawowe zabezpieczenia i dokumentowanie infrastruktury

## Zabezpieczenia
- konfiguracja SSH
- konfiguracja sudo (visudo)
- podstawowe hardening

## Skrypty


## Status
Projekt w trakcie rozwoju
