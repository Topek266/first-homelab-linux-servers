#!/bin/bash

# ============================================================================================= #
# OPIS:           Automatyczne monitorowanie i restart usług nginx i node exporter    #
# LOKALIZACJA:    /opt/skrypty/services-watchdog.sh                                             #
# WYMAGANIA:      Nadaj uprawnienia - sudo chmod +x /opt/skrypty/services-watchdog.sh           #
#                 Dodanie skryptu do visudo aby nie wpisywać hasła za każdym razem.             #
#                 Dodanie kilku lini do konfiguracji syslog-ng na serwer4 (znajduje się to już  #
#                 w konfiguracji syslog-ng na serwer4).                                         #
# Użycie:         /opt/skrypty/services-watchdog.sh                                             #
# ============================================================================================= #

# Pętla przechodząca po kolei przez zdefiniowane uslugi
for uslugi in nginx syslog-ng node_exporter; do

  # Ciche sprawdzenie czy usługi są aktywne
  if systemctl is-active --quiet "$uslugi"; then
    echo "$uslugi is active"
  else
    # Wywołanie gdy usługa nie działa
    echo "$uslugi is inactive"

    # Pętla podejmująca maksymalnie 3 próby naprawy
    for proba in 1 2 3; do
      echo "Próba $proba z 3: Restartuje $uslugi"
      systemctl restart "$uslugi"

      # Odczekanie 1 sekundy na wstanie procesu
      sleep 1

      if systemctl is-active --quiet "$uslugi"; then
        echo "$uslugi została uruchomiona za $proba razem"
        # Przerwanie pętli prób, usługa już działa
        break
      else
        echo "$proba próba nie udana"
      fi
    done

    # Jeżeli po wyjściu pętli usługa nadal nie działa - błąd krytyczny
    if ! systemctl is-active --quiet "$uslugi"; then
      # Wysyła na serwer4 log CRITICAL_ERROR
      logger -t service-monitor "CRITICAL ERROR: usługa $uslugi nie została uruchomiona po 3 po próbach."
      echo "CRITICAL ERROR: nie udało się aktywować usługi $uslugi po 3 próbach !!!"
    fi
  fi
done
