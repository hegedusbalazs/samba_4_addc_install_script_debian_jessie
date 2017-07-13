#!/bin/bash

#VALTOZO DEKLARACIO, ELLENORIZD, HOGY HELYES E!!!
#!!!!!!!!!!!!!!!! /srv /var esetleg /home  PARTICIONALASA: ACL USER_XATTR


SAMBA_REALM=example.lan

SAMBA_DOMAIN=EXAMPLE	

SAMBA_HOST=example-addc

SAMBA_IP=192.168.1.11

SAMBA_ADMINPASS=Ab123456



-------------------------------------------------------------------------


#Valtozok feldolgozasa

SAMBA_CONFIG=${SAMBA_CONFIG:-/etc/samba/smb.conf}
SAMBA_OPTIONS=${SAMBA_OPTIONS:-}
: "${SAMBA_REALM:?SAMBA_REALM needs to be set}"
export KERBEROS_REALM=${SAMBA_REALM^^}
export SAMBA_LDAPDC="DC="$(echo $SAMBA_REALM | sed "s/\./,DC=/g")
export SAMBA_NISDOMAIN=$(echo $SAMBA_REALM | cut -d. -f1)
: "${SAMBA_DOMAIN:?SAMBA_DOMAIN needs to be set}"
: "${SAMBA_HOST:?SAMBA_HOST needs to be set}"
: "${SAMBA_IP:?SAMBA_IP needs to be set}"
: "${SAMBA_ADMINPASS:?SAMBA_ADMINPASS needs to be set}"



