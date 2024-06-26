#!/bin/bash

set -e

######################################################################################
#                                                                                    #
# Project 'pterodactyl-installer'                                                    #
#                                                                                    #
# Copyright (C) 2018 - 2024, Vilhelm Prytz, <vilhelm@prytznet.se>                    #
#                                                                                    #
#   This program is free software: you can redistribute it and/or modify             #
#   it under the terms of the GNU General Public License as published by             #
#   the Free Software Foundation, either version 3 of the License, or                #
#   (at your option) any later version.                                              #
#                                                                                    #
#   This program is distributed in the hope that it will be useful,                  #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of                   #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    #
#   GNU General Public License for more details.                                     #
#                                                                                    #
#   You should have received a copy of the GNU General Public License                #
#   along with this program.  If not, see <https://www.gnu.org/licenses/>.           #
#                                                                                    #
# https://github.com/pterodactyl-installer/pterodactyl-installer/blob/master/LICENSE #
#                                                                                    #
# This script is not associated with the official Pterodactyl Project.               #
# https://github.com/pterodactyl-installer/pterodactyl-installer                     #
#                                                                                    #
######################################################################################

export GITHUB_SOURCE="v1.0.0"
export SCRIPT_RELEASE="v1.0.0"
export GITHUB_BASE_URL="https://raw.githubusercontent.com/CaglarYml/pterodactyl-installer-turkce"

LOG_PATH="/var/log/pterodactyl-installer.log"

# curl için kontrol edin
if ! [ -x "$(command -v curl)" ]; then
  echo "* Bu betigin calismasi icin curl gereklidir."
  echo "* apt (Debian ve turevleri) veya yum/dnf (CentOS) kullanarak yukleyin"
  exit 1
fi

# İndirmeden önce her zaman lib.sh dosyasını kaldırın
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_BASE_URL"/"$GITHUB_SOURCE"/lib/lib.sh
# shellcheck source=lib/lib.sh
source /tmp/lib.sh

execute() {
  echo -e "\n\n* pterodactyl-installer $(date) \n\n" >>$LOG_PATH

  [[ "$1" == *"canary"* ]] && export GITHUB_SOURCE="master" && export SCRIPT_RELEASE="canary"
  update_lib_source
  run_ui "${1//_canary/}" |& tee -a $LOG_PATH

  if [[ -n $2 ]]; then
    echo -e -n "* Kurulum $1 tamamlandi. $2 kurulumuna devam etmek istiyor musunuz? (y/N): "
    read -r CONFIRM
    if [[ "$CONFIRM" =~ [Yy] ]]; then
      execute "$2"
    else
      error "Kurulum $2 iptal edildi."
      exit 1
    fi
  fi
}

welcome ""

done=false
while [ "$done" == false ]; do
  options=(
    "Panel Kur"
    "Wings Kur"
    "Hem [0] hem de [1]i beraber kurun. (Wings betigi panelden sonra calisir.)"
    # "Uninstall panel or wings\n"

    "Paneli betigin test surumu ile yukleyin (master'da bulunan surumler bozuk olabilir!)"
    "Wingsi betigin test surumu ile yukleyin (master'da bulunan surumler bozuk olabilir!)"
    "Hem [3] hem de [4]u beraber kurun. (Wings betigi panelden sonra calisir.)"
    "Betigin test surumuyle Panel ve Wingsi kaldırın. (master'da bulunan surumler bozuk olabilir!)"
  )

  actions=(
    "panel"
    "wings"
    "panel;wings"
    # "uninstall"

    "panel_canary"
    "wings_canary"
    "panel_canary;wings_canary"
    "uninstall_canary"
  )

  output "Ne yapmak istersiniz?"

  for i in "${!options[@]}"; do
    output "[$i] ${options[$i]}"
  done

  echo -n "* Girdi 0-$((${#actions[@]} - 1)): "
  read -r action

  [ -z "$action" ] && error "Girdi gereklidir" && continue

  valid_input=("$(for ((i = 0; i <= ${#actions[@]} - 1; i += 1)); do echo "${i}"; done)")
  [[ ! " ${valid_input[*]} " =~ ${action} ]] && error "Gecersiz secenek"
  [[ " ${valid_input[*]} " =~ ${action} ]] && done=true && IFS=";" read -r i1 i2 <<<"${actions[$action]}" && execute "$i1" "$i2"
done

# Remove lib.sh, so next time the script is run the, newest version is downloaded.
rm -rf /tmp/lib.sh
