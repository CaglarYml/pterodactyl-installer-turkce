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

# Domain name / IP
export FQDN=""

# Default MySQL credentials
export MYSQL_DB=""
export MYSQL_USER=""
export MYSQL_PASSWORD=""

# Environment
export timezone=""
export email=""

# Initial admin account
export user_email=""
export user_username=""
export user_firstname=""
export user_lastname=""
export user_password=""

# Assume SSL, will fetch different config if true
export ASSUME_SSL=false
export CONFIGURE_LETSENCRYPT=false

# Firewall
export CONFIGURE_FIREWALL=false

# ------------ User input functions ------------ #

ask_letsencrypt() {
  if [ "$CONFIGURE_UFW" == false ] && [ "$CONFIGURE_FIREWALL_CMD" == false ]; then
    warning "Let's Encrypt 80/443 numarali baglanti noktasinin acilmasini gerektirir! Otomatik guvenlik duvari yapilandirmasini devre disi biraktiniz; bunu kendi sorumlulugunuzda kullanin (80/443 numarali baglanti noktasi kapaliysa, betik basarisiz olur)!"
  fi

  echo -e -n "* Let's Encrypt kullanarak HTTPS'yi otomatik olarak yapilandirmak istiyor musunuz? (y/N): "
  read -r CONFIRM_SSL

  if [[ "$CONFIRM_SSL" =~ [Yy] ]]; then
    CONFIGURE_LETSENCRYPT=true
    ASSUME_SSL=false
  fi
}

ask_assume_ssl() {
  output "Let's Encrypt bu kod tarafindan otomatik olarak yapilandirilmiyacaj (kullanici devre disi birakti)."
  output "Let's Encrypt'i 'varsayabilirsiniz', bu da betigin Let's Encrypt sertifikasi kullanmak uzere yapilandirilmis bir nginx yapilandirmasi indirecegi, ancak betigin sertifikayi sizin icin almayacagi anlamina gelir."
  output "SSL varsayarsaniz ve sertifikayi almazsaniz, kuruluminuz calismayacaktir."
  echo -n "* SSL varsayalim mi, varsaymayalim mi? (y/N):"
  read -r ASSUME_SSL_INPUT

  [[ "$ASSUME_SSL_INPUT" =~ [Yy] ]] && ASSUME_SSL=true
  true
}

check_FQDN_SSL() {
  if [[ $(invalid_ip "$FQDN") == 1 && $FQDN != 'localhost' ]]; then
    SSL_AVAILABLE=true
  else
    warning "* Let's Encrypt IP adresleri icin kullanilamayacak."
    output "Let's Encrypt'i kullanmak icin gecerli bir alan adi kullanmaniz gerekir."
  fi
}

main() {
  # check if we can detect an already existing installation
  if [ -d "/var/www/pterodactyl" ]; then
    warning "Betik, sisteminizde zaten Pterodactyl paneli oldugunu tespit etti! Betigi birden fazla kez calistiramazsiniz, basarisiz olur!"
    echo -e -n "* Devam etmek istiyor musun? (y/N): "
    read -r CONFIRM_PROCEED
    if [[ ! "$CONFIRM_PROCEED" =~ [Yy] ]]; then
      error "Kurulum iptal edildi!"
      exit 1
    fi
  fi

  welcome "panel"

  check_os_x86_64

  # set database credentials
output "Veritabani yapilandirmasi."
output ""
output "Bu, MySQL arasindaki iletisim icin kullanilan kimlik bilgileri olacaktir"
output "veritabani ve panel. Veritabani olusturmaniza gerek yok"
output "bu betigi calistirmadan once, betik bunu sizin icin yapacaktir."
output ""

  MYSQL_DB="-"
  while [[ "$MYSQL_DB" == *"-"* ]]; do
    required_input MYSQL_DB "Veritabani adi (panel): " "" "panel"
    [[ "$MYSQL_DB" == *"-"* ]] && error "Veritabani adi kisa cizgi iceremez"
  done

  MYSQL_USER="-"
  while [[ "$MYSQL_USER" == *"-"* ]]; do
    required_input MYSQL_USER "Veritabani kullanici adi (pterodactyl): " "" "pterodactyl"
    [[ "$MYSQL_USER" == *"-"* ]] && error "Veritabani kullanici adi kisa cizgi iceremez"
  done

  # MySQL password input
  rand_pw=$(gen_passwd 64)
  password_input MYSQL_PASSWORD "Veritabani sifresi (rastgele sifre olusturmak icin enter tusuna basin): " "MySQL parolasi bos olamaz" "$rand_pw"

  readarray -t valid_timezones <<<"$(curl -s "$GITHUB_URL"/configs/valid_timezones.txt)"
  output "Gecerli saat dilimlerinin listesi burada $(hyperlink "https://www.php.net/manual/en/timezones.php")"

  while [ -z "$timezone" ]; do
    echo -n "* Zaman dilimi sec [Europe/Istanbul]: "
    read -r timezone_input

    array_contains_element "$timezone_input" "${valid_timezones[@]}" && timezone="$timezone_input"
    [ -z "$timezone_input" ] && timezone="Europe/Istanbul" # because köttbullar!
  done

  email_input email "Let's Encrypt ve Pterodactyl'i yapilandirmak icin kullanilacak e-posta adresini girin: " "E-posta bos veya gecersiz olamaz"

  # Initial admin account
  email_input user_email "Ilk yonetici hesabi icin e-posta adresi: " "Email bos olamaz veya gecersizdir"
  required_input user_username "Ilk yonetici hesabi icin kullanici adi: " "Username bos olamaz"
  required_input user_firstname "Ilk yonetici hesabi icin ilk reklam: " "Isim bos olamaz"
  required_input user_lastname "Ilk yonetici hesabi icin soyadi: " "Ad bos olamaz"
  password_input user_password "Ilk yonetici hesabi icin parola: " "Parola bos olamaz"

  print_brake 72

  # set FQDN
  while [ -z "$FQDN" ]; do
    echo -n "* Bu panelin FQDN'sini ayarlayin (panel.example.com): "
    read -r FQDN
    [ -z "$FQDN" ] && error "FQDN bos olamaz."
  done

  # Check if SSL is available
  check_FQDN_SSL

  # Ask if firewall is needed
  ask_firewall CONFIGURE_FIREWALL

  # Only ask about SSL if it is available
  if [ "$SSL_AVAILABLE" == true ]; then
    # Ask if letsencrypt is needed
    ask_letsencrypt
    # If it's already true, this should be a no-brainer
    [ "$CONFIGURE_LETSENCRYPT" == false ] && ask_assume_ssl
  fi

  # verify FQDN if user has selected to assume SSL or configure Let's Encrypt
  [ "$CONFIGURE_LETSENCRYPT" == true ] || [ "$ASSUME_SSL" == true ] && bash <(curl -s "$GITHUB_URL"/lib/verify-fqdn.sh) "$FQDN"

  # summary
  summary

  # confirm installation
  echo -e -n "\n* Ilk yapilandirma tamamlandi. Kuruluma devam edelim mi? (y/N): "
  read -r CONFIRM
  if [[ "$CONFIRM" =~ [Yy] ]]; then
    run_installer "panel"
  else
    error "Kurulum iptal edildi."
    exit 1
  fi
}

summary() {
  print_brake 62
  output "$OS uzerinde Nginx ile Pterodactyl $PTERODACTYL_PANEL_VERSION $OS"
  output "Veritabani adi: $MYSQL_DB"
  output "Veritabani kullanicisi: $MYSQL_USER"
  output "Veritabani parolasi: (sansurlu)"
  output "Zaman dilimi: $timezone"
  output "E-posta: $email"
  output "Kullanici e-postasi: $user_email"
  output "Kullanici adi: $user_username"
  output "Ilk ad: $user_firstname"
  output "Soyadi: $user_lastname"
  output "Kullanici parolasi: (sansurlu)"
  output "FQDN: $FQDN"
  output "Guvenlik Duvari Yapilandirilsin mi? $CONFIGURE_FIREWALL"
  output "Let's Encrypt'i Yapilandir? $CONFIGURE_LETSENCRYPT"
  output "SSL varsayalim mi? $ASSUME_SSL"
  print_brake 62
}

goodbye() {
  print_brake 62
  output "Panel kurulumu tamamlandi"
  output ""

  [ "$CONFIGURE_LETSENCRYPT" == true ] && output "Panelinize $(hyperlink "$FQDN") adresinden erisilebilmelidir."
  [ "$ASSUME_SSL" == true ] && [ "$CONFIGURE_LETSENCRYPT" == false ] && output "SSL kullanmayi sectiniz, ancak Let's Encrypt araciligiyla otomatik olarak degil. SSL yapilandirilana kadar paneliniz calismayacaktir."
  [ "$ASSUME_SSL" == false ] && [ "$CONFIGURE_LETSENCRYPT" == false ] && output "Panelinize $(hyperlink "$FQDN") adresinden erisilebilmelidir."

  output ""
  output "Kurulum $OS üzerinde nginx kullanıyor"
  output "Bu betigi kullandiginiz icin tesekkur ederiz."
  [ "$CONFIGURE_FIREWALL" == false ] && echo -e "* ${COLOR_RED}Note${COLOR_NC}:Eger guvenlik duvarini yapilandirmadiysaniz: 80/443 (HTTP/HTTPS) acik olmalidir!"
  print_brake 62
}

# run script
main
goodbye
