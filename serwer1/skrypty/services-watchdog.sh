#!/bin/bash

# ===================================================================================#
# OPIS:           Automatyczne monitorowanie i restart usług dhcp, dns i apache2     #
# LOKALIZACJA:    /opt/skrypty/services-watchdog.sh                                  #
# WYMAGANIA:      Dodanie skryptu do visudo aby nie wpisywać hasła za każdym razem.  #
# Użycie:         sudo /opt/skrypty/services-watchdog.sh                             #
# ===================================================================================#
# PLANY I ROZWÓJ:                                                                    #
# 1. Dodać skrypt do cron (automatyczne uruchamianie co 10 minut).                   #
# 2. Po zakończeniu konfiguracji serwera logów, dodać wysyłanie komunikatów o        #
#    błędach (error/critical) na zewnętrzny serwer.                                  #
# ===================================================================================#

# Pętla przechodząca po kolei przez zdefiniowane uslugi
for uslugi in bind9 isc-dhcp-server apache2; do

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
      echo "BŁĄD KRYTYCZNY: nie udało się aktywować usługi $uslugi po 3 próbach !!!"
    fi
  fi
done
