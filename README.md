# First-sysadmin-lab

Domowy lab sysadmin postawiony na KVM/QEMU z Ubuntu Server jako hostem.

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

## Cel
Nauka administrowania systemami Linux - konfiguracja usług sieciowych, automatyzacja, podstawowe zabezpieczenia i dokumentowanie infrastruktury

## Zabezpieczenia
- konfiguracja SSH
- konfiguracja sudo (visudo)
- podstawowe hardening

## Skrypty


## Status
Projekt w trakcie rozwoju
