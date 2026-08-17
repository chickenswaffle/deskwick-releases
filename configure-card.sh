#!/usr/bin/env bash
# Configure a freshly flashed Desk Wick card: account, SSH and WiFi.
#
#   ./image/configure-card.sh [/Volumes/bootfs]
#
# Raspberry Pi Imager used to do this from its customisation dialog. From
# Imager 2.0 that dialog is greyed out for any image Imager didn't download
# itself, and the image is Trixie-based, so the settings now live in cloud-init
# files on the card's FAT partition: user-data (account, SSH) and
# network-config (WiFi). This writes both.
#
# Nothing here is Desk Wick specific — the same files configure any current
# Raspberry Pi OS image.

set -euo pipefail

BOOTFS="${1:-/Volumes/bootfs}"

die() { echo "error: $*" >&2; exit 1; }

[[ -d $BOOTFS ]] || die "no volume at $BOOTFS — flash the card first, then reinsert it"
[[ -f $BOOTFS/user-data && -f $BOOTFS/network-config ]] ||
  die "$BOOTFS has no user-data/network-config; that isn't a cloud-init Pi OS card"

# openssl's -6 gives a SHA-512 crypt hash, which is what cloud-init's passwd:
# field expects. A plaintext password would otherwise sit readable on a FAT
# partition that mounts on any machine.
command -v openssl >/dev/null || die "openssl not found; needed to hash the password"

# The image already ships a user-data that creates a passwordless "deskwick"
# account, which is enough for the kiosk to come up on its own. Answering blank
# here leaves that alone and only touches WiFi — the common case is wanting a
# password so you can SSH in, not wanting a different account.
echo "Leave the username blank to keep the image's own passwordless account."
read -rp "username [keep]: " USER_NAME

if [[ -n $USER_NAME ]]; then
  read -rsp "password: " USER_PASS; echo
  [[ -n $USER_PASS ]] || die "a password is required"
  read -rsp "password (again): " USER_PASS2; echo
  [[ $USER_PASS == "$USER_PASS2" ]] || die "passwords don't match"

  read -rp "hostname [deskwick]: " HOSTNAME_
  HOSTNAME_="${HOSTNAME_:-deskwick}"
fi

read -rp "WiFi SSID (blank for Ethernet only): " WIFI_SSID
if [[ -n $WIFI_SSID ]]; then
  read -rsp "WiFi passphrase: " WIFI_PASS; echo
  read -rp "WiFi country code [US]: " WIFI_COUNTRY
  WIFI_COUNTRY="${WIFI_COUNTRY:-US}"
fi

if [[ -n $USER_NAME ]]; then
  PASS_HASH="$(openssl passwd -6 "$USER_PASS")"

  cat > "$BOOTFS/user-data" <<EOF
#cloud-config
# Written by Desk Wick configure-card.sh.

hostname: $HOSTNAME_

users:
  - name: $USER_NAME
    groups: users,adm,dialout,audio,netdev,video,plugdev,cdrom,games,input,gpio,spi,i2c,render,sudo
    shell: /bin/bash
    lock_passwd: false
    passwd: $PASS_HASH
    sudo: ALL=(ALL) NOPASSWD:ALL

ssh_pwauth: true
EOF
fi

if [[ -n $WIFI_SSID ]]; then
  cat > "$BOOTFS/network-config" <<EOF
# Written by Desk Wick configure-card.sh.
network:
  version: 2
  wifis:
    renderer: NetworkManager
    wlan0:
      dhcp4: true
      optional: true
      regulatory-domain: "$WIFI_COUNTRY"
      access-points:
        "$WIFI_SSID":
          password: "$WIFI_PASS"
EOF
fi

echo
if [[ -n $USER_NAME ]]; then
  echo "wrote $BOOTFS/user-data"
else
  echo "left $BOOTFS/user-data alone (image's own account)"
fi
if [[ -n $WIFI_SSID ]]; then
  echo "wrote $BOOTFS/network-config"
fi
echo "eject the card and boot the Pi with the screen attached."
