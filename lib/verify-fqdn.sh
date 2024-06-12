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

# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* HATA: Lib betiği yüklenemedi" && exit 1
fi

CHECKIP_URL="https://checkip.pterodactyl-installer.se"
DNS_SERVER="8.8.8.8"

# exit with error status code if user is not root
if [[ $EUID -ne 0 ]]; then
  echo "* Bu betik root yetkileriyle (sudo) calistirilmalidir." 1>&2
  exit 1
fi

fail() {
  output "DNS kaydi ($dns_record) sunucunuzun IP'siyle eslesmiyor. Lutfen FQDN'nin $fqdn sunucunuzun IP'sini gosterdiginden emin olun, $ip"
  output "Cloudflare kullaniyorsaniz, lutfen proxy'yi devre disi birakin veya Let's Encrypt'ten cikin."

  echo -n "* Yine de devam et (ne yaptiginizi bilmiyorsaniz kurulumunuz bozulacaktir)? (y/N): "
  read -r override

  [[ ! "$override" =~ [Yy] ]] && error "Gecersiz FQDN veya DNS kaydi" && exit 1
  return 0
}

dep_install() {
  update_repos true

  case "$OS" in
  ubuntu | debian)
    install_packages "dnsutils" true
    ;;
  rocky | almalinux)
    install_packages "bind-utils" true
    ;;
  esac

  return 0
}

confirm() {
  output "Bu betik uc noktaya bir HTTPS istegi gerceklestirecektir $CHECKIP_URL"
  output "Bu betik icin resmi IP kontrol hizmeti, https://checkip.pterodactyl-installer.se"
  output "herhangi bir IP bilgisini günlüge kaydetmeyecek veya herhangi bir ucuncu tarafla paylasmayacaktir."
  output "Baska bir hizmet kullanmak isterseniz, komut dosyasini degistirmekten cekinmeyin."

  echo -e -n "* Bu HTTPS isteginin gercekleştirilmesini kabul ediyorum (y/N): "
  read -r confirm
  [[ "$confirm" =~ [Yy] ]] || (error "Kullanıcı kabul etmedi" && false)
}

dns_verify() {
  output "$fqdn icin DNS cozumleniyor..."
  ip=$(curl -4 -s $CHECKIP_URL)
  dns_record=$(dig +short @$DNS_SERVER "$fqdn" | tail -n1)
  [ "${ip}" != "${dns_record}" ] && fail
  output "DNS onaylandi!"
}

main() {
  fqdn="$1"
  dep_install
  confirm && dns_verify
  true
}

main "$1" "$2"
