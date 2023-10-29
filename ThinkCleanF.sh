#!/bin/bash

##########################################################
# Script de curățare pentru Fedora
# Autor: ThinkRoot99
# Descriere: Acest script curăță sistemul Fedora de fișiere temporare,
# cache-uri, log-uri, aplicații Flatpak și alte date inutile pentru a menține sistemul curat și organizat.
# Versiune: 3.1
# Data ultimei actualizări: [Data ultimei actualizări]

# Culori pentru mesaje
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Instrucțiuni de utilizare:
# 1. Salvează acest script într-un fișier cu extensia .sh (de exemplu, clean_fedora.sh).
# 2. Acordă permisiuni de execuție cu comanda: chmod +x clean_fedora.sh
# 3. Rulează scriptul ca utilizator cu privilegii de administrator: sudo ./clean_fedora.sh

# Funcții pentru afișarea mesajelor
show_header() {
  clear
  echo -e "${GREEN}==============================================="
  echo "Script de curățare pentru Fedora"
  echo "Autor: [Numele tău]"
  echo "Versiune: 3.1"
  echo -e "===============================================${RESET}"
}

show_message() {
  echo -e "${YELLOW}$1${RESET}"
}

show_footer() {
  echo -e "${GREEN}===============================================${RESET}"
}

# Funcție pentru curățare
cleanup() {
  show_header
  show_message "Începe curățarea sistemului Fedora..."

  # Curățarea log-urilor X11 Debug
  sudo rm -rf /var/log/Xorg.*.log
  show_message "Log-urile X11 Debug au fost curățate."

  # Curățarea log-urilor Wayland Debug
  sudo rm -rf /var/log/wayland/*.log
  show_message "Log-urile Wayland Debug au fost curățate."

  # Curățarea log-urilor din /var/log/
  sudo rm -rf /var/log/* 
  show_message "Log-urile din /var/log/ au fost curățate."

  # Curățarea log-urilor jurnalului sistemului
  sudo journalctl --rotate
  sudo journalctl --vacuum-time=7d
  show_message "Jurnalul sistemului a fost curățat."

  # Curățarea log-urilor rotative
  sudo logrotate -f /etc/logrotate.conf
  show_message "Log-urile rotative au fost curățate."

  # Curățarea cache-ului de pachete
  sudo dnf clean all
  show_message "Cache-ul de pachete a fost curățat."

  # Curățarea cache-ului utilizatorului curent
  rm -r "$HOME"/.cache/*
  show_message "Cache-ul utilizatorului curent a fost curățat."

  # Curățarea fișierelor temporare
  if ! rm -rf /tmp/*; then
    show_message "Atenție: Unele fișiere temporare nu au putut fi șterse. Aceasta este o caracteristică normală."
  else
    show_message "Fișierele temporare au fost curățate."
  fi

  # Curățarea fișierelor de tipul .trash din directorul home
  rm -rf ~/.local/share/Trash/files/*
  show_message "Fișierele de tipul .trash au fost curățate."

  # Curățarea aplicațiilor Flatpak neutilizate
  flatpak uninstall --unused -y
  show_message "Aplicațiile Flatpak neutilizate au fost eliminate."

  # Autoremove pentru pachetele inutile
  sudo dnf autoremove -y
  show_message "Pachetele inutile au fost eliminate."

  # Curățarea istoricului terminalului (opțional)
  # istoricul terminalului se găsește în ~/.bash_history
  # dacă dorești să-l ștergi, poți utiliza:
  # rm ~/.bash_history

  show_message "Curățare completă finalizată."
  show_footer
}

# Meniu interactiv
while true; do
  show_header
  echo "1. Execută curățarea"
  echo "2. Ieșire"

  read -p "Selectează o opțiune: " choice

  case $choice in
    1)
      cleanup
      ;;
    2)
      show_message "Încheiere. La revedere!"
      exit 0
      ;;
    *)
      show_message "Opțiune invalidă. Te rog selectează din nou."
      ;;
  esac

  read -p "Apasă Enter pentru a continua..."
done
