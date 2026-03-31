# NFS Server, 
 
## Cel
Konfiguracja serwera NFS do udostępniania plików między systemami Linux/Unix.
W przeciwieństwie do Samby, NFS jest natywnym protokołem dla systemów Linux/Unix i nie wymaga dodatkowego uwierzytelniania, dostęp kontrolowany jest przez adresy IP

## Krótki opis konfiguracji
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

## Uprawnienia do katalogów
Publiczny --> chmod 755, chown $USER:$USER
Prywatny --> chmod 700, chown root:root

## Testy na serwerze
- Utworzyłem w publicznym katalog a w nim plik i sprawdziłem czy znajduje się on na kliencie
- Utworzyłem w prywatnym katalog a w nim plik i sprawdziłem czy znajduje się na kliencie

## Testy na kliencie
Testy znajdują się w katalogu hosts
