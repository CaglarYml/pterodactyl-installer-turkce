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
  ! fn_exists lib_loaded && echo "* HATA: Lib betigi yuklenemedi" && exit 1
fi

# ------------------ Variables ----------------- #

# Install mariadb
export INSTALL_MARIADB=false

# Firewall
export CONFIGURE_FIREWALL=false

# SSL (Let's Encrypt)
export CONFIGURE_LETSENCRYPT=false
export FQDN=""
export EMAIL=""

# Database host
export CONFIGURE_DBHOST=false
export CONFIGURE_DB_FIREWALL=false
export MYSQL_DBHOST_HOST="127.0.0.1"
export MYSQL_DBHOST_USER="pterodactyluser"
export MYSQL_DBHOST_PASSWORD=""

# ------------ User input functions ------------ #

ask_letsencrypt() {
  if [ "$CONFIGURE_UFW" == false ] && [ "$CONFIGURE_FIREWALL_CMD" == false ]; then
    warning "Let's Encrypt 80/443 numarali portun acilmasini gerektirir! Otomatik guvenlik duvari yapilandirmasini devre disi biraktiniz; bunu kendi sorumlulugunuzda kullanin (80/443 numarali baglanti noktasi kapaliysa, komut dosyasi basarisiz olur)!"
  fi

  warning "Let's Encrypt'i IP adresi olarak ana bilgisayar adinizla kullanamazsiniz! Bu bir FQDN olmalidir (orn. node.example.org)."

  echo -e -n "* Let's Encrypt kullanarak HTTPS'yi otomatik olarak yapilandirmak istiyor musunuz? (y/N): "
  read -r CONFIRM_SSL

  if [[ "$CONFIRM_SSL" =~ [Yy] ]]; then
    CONFIGURE_LETSENCRYPT=true
  fi
}

ask_database_user() {
  echo -n "* Veritabani ana bilgisayarlari icin otomatik olarak bir kullanici yapilandirmak istiyor musunuz? (y/N): "
  read -r CONFIRM_DBHOST

  if [[ "$CONFIRM_DBHOST" =~ [Yy] ]]; then
    ask_database_external
    CONFIGURE_DBHOST=true
  fi
}

ask_database_external() {
  echo -n "* MySQL'i harici olarak erisilecek sekilde yapilandirmak istiyor musunuz? (y/N): "
  read -r CONFIRM_DBEXTERNAL

  if [[ "$CONFIRM_DBEXTERNAL" =~ [Yy] ]]; then
    echo -n "* Panel adresini girin (herhangi bir adres için bos): "
    read -r CONFIRM_DBEXTERNAL_HOST
    if [ "$CONFIRM_DBEXTERNAL_HOST" == "" ]; then
      MYSQL_DBHOST_HOST="%"
    else
      MYSQL_DBHOST_HOST="$CONFIRM_DBEXTERNAL_HOST"
    fi
    [ "$CONFIGURE_FIREWALL" == true ] && ask_database_firewall
    return 0
  fi
}

ask_database_firewall() {
  warning "Ne yaptiğinizi bilmiyorsaniz, 3306 (MySQL) portuna gelen trafige izin vermek potansiyel olarak bir guvenlik riski olusturabilir!"
  echo -n "* 3306 numarali baglanti noktasina gelen trafige izin vermek ister misiniz? (y/N): "
  read -r CONFIRM_DB_FIREWALL
  if [[ "$CONFIRM_DB_FIREWALL" =~ [Yy] ]]; then
    CONFIGURE_DB_FIREWALL=true
  fi
}

####################
## MAIN FUNCTIONS ##
####################

main() {
  # check if we can detect an already existing installation
  if [ -d "/etc/pterodactyl" ]; then
    warning "Betik, sisteminizde zaten Pterodactyl kanatlari oldugunu tespit etti! Betigi birden fazla kez calistiramazsiniz, basarisiz olur!"
    echo -e -n "* Devam etmek istiyor musun? (y/N): "
    read -r CONFIRM_PROCEED
    if [[ ! "$CONFIRM_PROCEED" =~ [Yy] ]]; then
      error "Kurulum iptal edildi!"
      exit 1
    fi
  fi

  welcome "wings"

  check_virt

  echo "*"
  echo "* Yukleyici Docker'i ve Wings icin gerekli bagimliliklari yukleyecektir"
  echo "* yani sira Wings'in kendisi. Ancak dugumu olusturmak icin yine de gereklidir"
  echo "* panelde ve ardindan yapilandırma dosyasini dugume manuel olarak yerlestirin"
  echo "* kurulum tamamlandi. Bu islem hakkinda daha fazla bilgi icin"
  echo "* resmi belgeler: $(hyperlink 'https://pterodactyl.io/wings/1.0/installing.html#configure')"
  echo "*"
  echo -e "* ${COLOR_RED}Not${COLOR_NC}: bu betik Wings'i otomatik olarak baslatmayacaktir (systemd hizmetini kuracak, baslatmayacaktir)."
  echo -e "* ${COLOR_RED}Not${COLOR_NC}: bu betik takasi etkinlestirmeyecektir (docker icin)."
  print_brake 42

  ask_firewall CONFIGURE_FIREWALL

  ask_database_user

  if [ "$CONFIGURE_DBHOST" == true ]; then
    type mysql >/dev/null 2>&1 && HAS_MYSQL=true || HAS_MYSQL=false

    if [ "$HAS_MYSQL" == false ]; then
      INSTALL_MARIADB=true
    fi

    MYSQL_DBHOST_USER="-"
    while [[ "$MYSQL_DBHOST_USER" == *"-"* ]]; do
      required_input MYSQL_DBHOST_USER "Veritabani kullanici adi (pterodactyluser): " "" "pterodactyluser"
      [[ "$MYSQL_DBHOST_USER" == *"-"* ]] && error "Veritabani kullanicisi kisa cizgi iceremez"
    done

    password_input MYSQL_DBHOST_PASSWORD "Veritabani sifresi: " "Sifre bos olamaz"
  fi

  ask_letsencrypt

  if [ "$CONFIGURE_LETSENCRYPT" == true ]; then
    while [ -z "$FQDN" ]; do
      echo -n "* Let's Encrypt icin kullanilacak FQDN'yi ayarlayin (node.example.com): "
      read -r FQDN

      ASK=false

      [ -z "$FQDN" ] && error "FQDN bos olamaz"                                                            # check if FQDN is empty
      bash <(curl -s "$GITHUB_URL"/lib/verify-fqdn.sh) "$FQDN" || ASK=true                                      # check if FQDN is valid
      [ -d "/etc/letsencrypt/live/$FQDN/" ] && error "Bu FQDN'ye sahip bir sertifika zaten mevcut!" && ASK=true # check if cert exists

      [ "$ASK" == true ] && FQDN=""
      [ "$ASK" == true ] && echo -e -n "* Hala Let's Encrypt kullanarak HTTPS'yi otomatik olarak yapilandirmak istiyor musunuz? (y/N): "
      [ "$ASK" == true ] && read -r CONFIRM_SSL

      if [[ ! "$CONFIRM_SSL" =~ [Yy] ]] && [ "$ASK" == true ]; then
        CONFIGURE_LETSENCRYPT=false
        FQDN=""
      fi
    done
  fi

  if [ "$CONFIGURE_LETSENCRYPT" == true ]; then
    # set EMAIL
    while ! valid_email "$EMAIL"; do
      echo -n "* Let's Encrypt icin e-posta adresinizi girin: "
      read -r EMAIL

      valid_email "$EMAIL" || error "E-posta bos veya gecersiz olamaz"
    done
  fi

  echo -n "* Kuruluma devam edin? (y/N): "

  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "wings"
  else
    error "Kurulum iptal edildi."
    exit 1
  fi
}

function goodbye {
  echo ""
  print_brake 70
  echo "* Wings kurulumu tamamlandi"
  echo "*"
  echo "* Devam etmek icin Wings'i panelinizle calisacak sekilde yapilandirmaniz gerekir"
  echo "* Lutfen resmi kilavuza bakin, $(hyperlink 'https://pterodactyl.io/wings/1.0/installing.html#configure')"
  echo "* "
  echo "* Yapilandirma dosyasini panelden manuel olarak /etc/pterodactyl/config.yml dosyasina kopyalayabilirsiniz"
  echo "* veya, panelden \"auto deploy\" dugmesini kullanabilir ve komutu bu terminale yapistirabilirsiniz"
  echo "* "
  echo "* Daha sonra calistigini dogrulamak icin Wings'i manuel olarak baslatabilirsiniz"
  echo "*"
  echo "* sudo wings"
  echo "*"
  echo "* Calistigini dogruladiktan sonra CTRL+C tuslarini kullanin ve ardindan Wings'i bir hizmet olarak baslatin (arka planda calisir)"
  echo "*"
  echo "* systemctl start wings"
  echo "*"
  echo -e "* ${COLOR_RED}Not${COLOR_NC}: Takasin etkinlestirilmesi onerilir (Docker icin, resmi belgelerde bu konuda daha fazla bilgi edinin)."
[ "$CONFIGURE_FIREWALL" == false ] && echo -e "* ${COLOR_RED}Not${COLOR_NC}: Guvenlik duvarinizi yapilandirmadıysaniz, 8080 ve 2022 numarali baglanti noktalarinin acik olmasi gerekir."
  print_brake 70
  echo ""
}

# run script
main
goodbye
